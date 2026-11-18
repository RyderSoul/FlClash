package toolbox

import (
	"bufio"
	"cmp"
	"context"
	"crypto/md5"
	"encoding/binary"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
	"path"
	"path/filepath"
	"slices"
	"strings"
	"sync"
	"time"

	"github.com/klauspost/compress/zstd"
	"github.com/metacubex/mihomo/component/resolver"
	"github.com/metacubex/mihomo/constant"
	P "github.com/metacubex/mihomo/constant/provider"
	"github.com/metacubex/mihomo/rules/provider"
	"github.com/metacubex/sevenzip"
)

const (
	mrsKindGeosite = "geosite"
	mrsKindGeoip   = "geoip"

	mrsErrorMissing = "missing"
	mrsErrorInvalid = "invalid"
	mrsErrorFailed  = "failed"

	mrsScanWorkers = 2
)

type mrsMatcher interface {
	Match(metadata *constant.Metadata, helper constant.RuleMatchHelper) bool
	DumpMrs(f func(key string) bool)
}

type mrsFile struct {
	kind string
	name string
	file string
	path string
}

type MrsPrepareResult struct {
	Version   string  `json:"version"`
	Geosite   int     `json:"geosite"`
	Geoip     int     `json:"geoip"`
	Extracted bool    `json:"extracted"`
	Elapsed   float64 `json:"elapsed"`
	Error     string  `json:"error"`
}

type MrsMatch struct {
	Kind       string `json:"kind"`
	Name       string `json:"name"`
	File       string `json:"file"`
	Count      int    `json:"count"`
	Via        string `json:"via"`
	Referenced bool   `json:"referenced"`
}

type MrsLookupResult struct {
	Target  string     `json:"target"`
	Host    string     `json:"host"`
	IPs     []string   `json:"ips"`
	Matches []MrsMatch `json:"matches"`
	Elapsed float64    `json:"elapsed"`
	Error   string     `json:"error"`
}

var (
	mrsLock         sync.Mutex
	mrsCancelLock   sync.Mutex
	mrsLookupCancel context.CancelFunc
	mrsLookupSerial uint64
)

func mrsDir() string {
	return filepath.Join(constant.Path.HomeDir(), "toolbox", "mrs")
}

func mrsKindOf(rel string) string {
	if strings.Contains("/"+rel, "/geoip/") {
		return mrsKindGeoip
	}
	return mrsKindGeosite
}

func mrsBundleVersion(bundle string) (string, error) {
	info, err := os.Stat(bundle)
	if err != nil {
		return "", err
	}
	if data, err := os.ReadFile(bundle + ".version"); err == nil {
		if version := strings.TrimSpace(string(data)); version != "" {
			return version, nil
		}
	}
	return fmt.Sprintf("%d-%d", info.ModTime().Unix(), info.Size()), nil
}

func extractMrsFile(file *sevenzip.File, target string) error {
	if err := os.MkdirAll(filepath.Dir(target), 0o755); err != nil {
		return err
	}
	content, err := file.Open()
	if err != nil {
		return err
	}
	defer content.Close()
	out, err := os.OpenFile(target, os.O_CREATE|os.O_WRONLY|os.O_TRUNC, 0o644)
	if err != nil {
		return err
	}
	if _, err := io.Copy(out, content); err != nil {
		_ = out.Close()
		return err
	}
	return out.Close()
}

func extractMrsBundle(bundle, dir, version string) (err error) {
	reader, err := sevenzip.OpenReader(bundle)
	if err != nil {
		return err
	}
	defer reader.Close()
	temp := dir + ".tmp"
	_ = os.RemoveAll(temp)
	defer func() {
		if err != nil {
			_ = os.RemoveAll(temp)
		}
	}()
	for _, file := range reader.File {
		name := path.Clean(filepath.ToSlash(file.Name))
		if file.FileInfo().IsDir() || !strings.HasSuffix(name, ".mrs") || strings.HasPrefix(name, "..") || path.IsAbs(name) {
			continue
		}
		if err = extractMrsFile(file, filepath.Join(temp, filepath.FromSlash(name))); err != nil {
			return err
		}
	}
	if err = os.WriteFile(filepath.Join(temp, ".version"), []byte(version), 0o644); err != nil {
		return err
	}
	_ = os.RemoveAll(dir)
	return os.Rename(temp, dir)
}

func readMrsMatcher(reader io.Reader, kind string) (mrsMatcher, int, error) {
	var header [4]byte
	if _, err := io.ReadFull(reader, header[:]); err != nil {
		return nil, 0, err
	}
	if header != provider.MrsMagicBytes {
		return nil, 0, errors.New("invalid mrs magic")
	}
	var behavior [1]byte
	if _, err := io.ReadFull(reader, behavior[:]); err != nil {
		return nil, 0, err
	}
	if kind == "" {
		switch behavior[0] {
		case P.Domain.Byte():
			kind = mrsKindGeosite
		case P.IPCIDR.Byte():
			kind = mrsKindGeoip
		default:
			return nil, 0, errors.New("unsupported mrs behavior")
		}
	}
	var count, length int64
	if err := binary.Read(reader, binary.BigEndian, &count); err != nil {
		return nil, 0, err
	}
	if err := binary.Read(reader, binary.BigEndian, &length); err != nil {
		return nil, 0, err
	}
	if length < 0 {
		return nil, 0, errors.New("invalid mrs extra")
	}
	if _, err := io.CopyN(io.Discard, reader, length); err != nil {
		return nil, 0, err
	}
	if kind == mrsKindGeoip {
		strategy := provider.NewIPCidrStrategy()
		if err := strategy.FromMrs(reader, int(count)); err != nil {
			return nil, 0, err
		}
		return strategy, int(count), nil
	}
	strategy := provider.NewDomainStrategy()
	if err := strategy.FromMrs(reader, int(count)); err != nil {
		return nil, 0, err
	}
	return strategy, int(count), nil
}

func listMrsFiles(dir string) ([]mrsFile, error) {
	var files []mrsFile
	err := filepath.WalkDir(dir, func(file string, entry os.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if entry.IsDir() || !strings.HasSuffix(file, ".mrs") {
			return nil
		}
		rel, err := filepath.Rel(dir, file)
		if err != nil {
			return nil
		}
		rel = filepath.ToSlash(rel)
		files = append(files, mrsFile{
			kind: mrsKindOf(rel),
			name: strings.TrimSuffix(path.Base(rel), ".mrs"),
			file: rel,
			path: file,
		})
		return nil
	})
	if err != nil {
		return nil, err
	}
	slices.SortFunc(files, func(a, b mrsFile) int {
		return strings.Compare(a.file, b.file)
	})
	return files, nil
}

type mrsScanTarget struct {
	host  string
	addrs []constant.Metadata
}

func (target mrsScanTarget) match(file mrsFile, matcher mrsMatcher) string {
	helper := constant.RuleMatchHelper{ResolveIP: func() {}, FindProcess: func() {}}
	if file.kind == mrsKindGeosite {
		if target.host != "" && matcher.Match(&constant.Metadata{Host: target.host}, helper) {
			return target.host
		}
		return ""
	}
	for i := range target.addrs {
		metadata := target.addrs[i]
		if matcher.Match(&metadata, helper) {
			return metadata.DstIP.String()
		}
	}
	return ""
}

func scanMrsFiles(ctx context.Context, files []mrsFile, target mrsScanTarget, refs map[string]bool) []MrsMatch {
	var candidates []mrsFile
	for _, file := range files {
		if file.kind == mrsKindGeosite && target.host == "" {
			continue
		}
		if file.kind == mrsKindGeoip && len(target.addrs) == 0 {
			continue
		}
		candidates = append(candidates, file)
	}
	found := make([]*MrsMatch, len(candidates))
	jobs := make(chan int)
	var wg sync.WaitGroup
	for range mrsScanWorkers {
		wg.Add(1)
		go func() {
			defer wg.Done()
			decoder, err := zstd.NewReader(nil, zstd.WithDecoderConcurrency(1), zstd.WithDecoderLowmem(true))
			if err != nil {
				for range jobs {
				}
				return
			}
			defer decoder.Close()
			for index := range jobs {
				file := candidates[index]
				handle, err := os.Open(file.path)
				if err != nil {
					continue
				}
				if err := decoder.Reset(bufio.NewReader(handle)); err != nil {
					_ = handle.Close()
					continue
				}
				matcher, count, err := readMrsMatcher(decoder, file.kind)
				_ = handle.Close()
				if err != nil {
					continue
				}
				if via := target.match(file, matcher); via != "" {
					found[index] = &MrsMatch{
						Kind:       file.kind,
						Name:       file.name,
						File:       file.file,
						Count:      count,
						Via:        via,
						Referenced: refs[file.file] || refs[file.kind+":"+strings.ToLower(file.name)],
					}
				}
			}
		}()
	}
	for index := range candidates {
		if ctx.Err() != nil {
			break
		}
		jobs <- index
	}
	close(jobs)
	wg.Wait()
	matches := []MrsMatch{}
	for _, match := range found {
		if match != nil {
			matches = append(matches, *match)
		}
	}
	return matches
}

func peekMrsKind(file string, decoder *zstd.Decoder) (string, bool) {
	handle, err := os.Open(file)
	if err != nil {
		return "", false
	}
	defer handle.Close()
	if err := decoder.Reset(bufio.NewReader(handle)); err != nil {
		return "", false
	}
	var header [4]byte
	if _, err := io.ReadFull(decoder, header[:]); err != nil || header != provider.MrsMagicBytes {
		return "", false
	}
	var behavior [1]byte
	if _, err := io.ReadFull(decoder, behavior[:]); err != nil {
		return "", false
	}
	switch behavior[0] {
	case P.Domain.Byte():
		return mrsKindGeosite, true
	case P.IPCIDR.Byte():
		return mrsKindGeoip, true
	default:
		return "", false
	}
}

func mrsProviderIndexes() (byRelPath, byDigest map[string]string) {
	byRelPath = map[string]string{}
	byDigest = map[string]string{}
	_, _, cfg := coreState()
	if cfg == nil {
		return byRelPath, byDigest
	}
	home := constant.Path.HomeDir()
	for name, mapping := range cfg.RuleProvider {
		if rawPath, _ := mapping["path"].(string); rawPath != "" {
			clean := path.Clean(filepath.ToSlash(rawPath))
			if filepath.IsAbs(rawPath) && home != "" {
				if rel, err := filepath.Rel(home, rawPath); err == nil {
					clean = path.Clean(filepath.ToSlash(rel))
				}
			}
			byRelPath[strings.TrimPrefix(clean, "./")] = name
		}
		if rawURL, _ := mapping["url"].(string); rawURL != "" {
			digest := fmt.Sprintf("%x", md5.Sum([]byte(name+"@"+rawURL)))
			byDigest[digest] = name
		}
		byDigest[fmt.Sprintf("%x", md5.Sum([]byte("rule-providers/"+name)))] = name
	}
	return byRelPath, byDigest
}

func listCachedMrsFiles() []mrsFile {
	home := constant.Path.HomeDir()
	if home == "" {
		return nil
	}
	decoder, err := zstd.NewReader(nil, zstd.WithDecoderConcurrency(1), zstd.WithDecoderLowmem(true))
	if err != nil {
		return nil
	}
	defer decoder.Close()
	byRelPath, byDigest := mrsProviderIndexes()
	seen := map[string]bool{}
	var files []mrsFile
	addFile := func(fullPath string) {
		clean := filepath.Clean(fullPath)
		if seen[clean] {
			return
		}
		seen[clean] = true
		rel, err := filepath.Rel(home, clean)
		if err != nil || rel == "." || strings.HasPrefix(rel, "..") {
			return
		}
		relSlash := path.Clean(filepath.ToSlash(rel))
		kind, ok := peekMrsKind(clean, decoder)
		if !ok {
			return
		}
		name := byRelPath[relSlash]
		if name == "" {
			name = byDigest[filepath.Base(clean)]
		}
		if name == "" {
			name = strings.TrimSuffix(filepath.Base(clean), ".mrs")
		}
		files = append(files, mrsFile{
			kind: kind,
			name: name,
			file: relSlash,
			path: clean,
		})
	}
	roots := []string{
		filepath.Join(home, "profiles", "providers"),
		filepath.Join(home, "providers"),
		filepath.Join(home, "ruleset"),
	}
	for _, root := range roots {
		_ = filepath.WalkDir(root, func(fullPath string, entry os.DirEntry, walkErr error) error {
			if walkErr != nil {
				return nil
			}
			if !entry.IsDir() {
				addFile(fullPath)
			}
			return nil
		})
	}
	for relPath := range byRelPath {
		if !path.IsAbs(relPath) && !strings.HasPrefix(relPath, "..") {
			addFile(filepath.Join(home, filepath.FromSlash(relPath)))
		}
	}
	slices.SortFunc(files, func(a, b mrsFile) int {
		if c := cmp.Compare(a.kind, b.kind); c != 0 {
			return c
		}
		if c := cmp.Compare(a.name, b.name); c != 0 {
			return c
		}
		return cmp.Compare(a.file, b.file)
	})
	return files
}

func prepareMrs() ([]mrsFile, MrsPrepareResult) {
	start := time.Now()
	result := MrsPrepareResult{}
	bundle := constant.Path.BundleMRS()
	version, err := mrsBundleVersion(bundle)
	var files []mrsFile
	if err != nil {
		files = listCachedMrsFiles()
		if len(files) == 0 {
			result.Error = mrsErrorMissing
			return nil, result
		}
		result.Version = "cached"
	} else {
		result.Version = version
		dir := mrsDir()
		stamp, _ := os.ReadFile(filepath.Join(dir, ".version"))
		if strings.TrimSpace(string(stamp)) != version {
			if err := extractMrsBundle(bundle, dir, version); err != nil {
				result.Error = mrsErrorFailed
				return nil, result
			}
			result.Extracted = true
		}
		var listErr error
		files, listErr = listMrsFiles(dir)
		if listErr != nil || len(files) == 0 {
			result.Error = mrsErrorFailed
			return nil, result
		}
	}
	for _, file := range files {
		if file.kind == mrsKindGeoip {
			result.Geoip++
		} else {
			result.Geosite++
		}
	}
	result.Elapsed = float64(time.Since(start).Microseconds()) / 1000
	return files, result
}

func mrsReferences() map[string]bool {
	refs := map[string]bool{}
	_, _, cfg := coreState()
	if cfg == nil {
		return refs
	}
	home := constant.Path.HomeDir()
	for name, mapping := range cfg.RuleProvider {
		if bundlePath, _ := mapping["path-in-bundle"].(string); bundlePath != "" {
			refs[path.Clean(strings.TrimPrefix(filepath.ToSlash(bundlePath), "./"))] = true
		}
		if rulePath, _ := mapping["path"].(string); rulePath != "" {
			clean := path.Clean(strings.TrimPrefix(filepath.ToSlash(rulePath), "./"))
			if filepath.IsAbs(rulePath) && home != "" {
				if rel, err := filepath.Rel(home, rulePath); err == nil {
					clean = path.Clean(filepath.ToSlash(rel))
				}
			}
			refs[clean] = true
		}
		lowerName := strings.ToLower(name)
		refs[mrsKindGeosite+":"+lowerName] = true
		refs[mrsKindGeoip+":"+lowerName] = true
	}
	for _, rule := range cfg.Rule {
		parts := strings.Split(rule, ",")
		if len(parts) < 2 {
			continue
		}
		name := strings.ToLower(strings.TrimSpace(parts[1]))
		switch strings.ToUpper(strings.TrimSpace(parts[0])) {
		case "GEOSITE":
			refs[mrsKindGeosite+":"+name] = true
		case "GEOIP":
			refs[mrsKindGeoip+":"+name] = true
		case "RULE-SET":
			refs[mrsKindGeosite+":"+name] = true
			refs[mrsKindGeoip+":"+name] = true
		}
	}
	return refs
}

type MrsLookupParams struct {
	Target  string `json:"target"`
	Resolve bool   `json:"resolve"`
}

type MrsDumpParams struct {
	File string `json:"file"`
}

func lookupMrs(ctx context.Context, files []mrsFile, target string, resolve bool) MrsLookupResult {
	start := time.Now()
	result := MrsLookupResult{Target: target, IPs: []string{}, Matches: []MrsMatch{}}
	host, ip, ok := parseRouteTarget(target)
	if !ok {
		result.Error = mrsErrorInvalid
		return result
	}
	result.Host = host
	scan := mrsScanTarget{host: host}
	if ip.IsValid() {
		scan.addrs = append(scan.addrs, constant.Metadata{DstIP: ip})
		result.IPs = append(result.IPs, ip.String())
	} else if resolve {
		resolveCtx, cancel := context.WithTimeout(ctx, 5*time.Second)
		resolved, _ := resolver.LookupIP(resolveCtx, host)
		cancel()
		for i, addr := range resolved {
			if i >= 4 {
				break
			}
			scan.addrs = append(scan.addrs, constant.Metadata{DstIP: addr})
			result.IPs = append(result.IPs, addr.String())
		}
	}
	result.Matches = scanMrsFiles(ctx, files, scan, mrsReferences())
	result.Elapsed = float64(time.Since(start).Microseconds()) / 1000
	return result
}

func PrepareMrs() MrsPrepareResult {
	mrsLock.Lock()
	defer mrsLock.Unlock()
	_, result := prepareMrs()
	if result.Extracted {
		releaseToolMemory()
	}
	return result
}

func HandleMrsPrepare() string {
	data, _ := json.Marshal(PrepareMrs())
	return string(data)
}

func LookupMrs(params MrsLookupParams) MrsLookupResult {
	target := params.Target
	ctx, cancel := context.WithCancel(context.Background())
	mrsCancelLock.Lock()
	if mrsLookupCancel != nil {
		mrsLookupCancel()
	}
	mrsLookupCancel = cancel
	mrsLookupSerial++
	serial := mrsLookupSerial
	mrsCancelLock.Unlock()
	defer func() {
		mrsCancelLock.Lock()
		if mrsLookupSerial == serial {
			mrsLookupCancel = nil
		}
		mrsCancelLock.Unlock()
		cancel()
	}()
	mrsLock.Lock()
	defer mrsLock.Unlock()
	files, prepared := prepareMrs()
	var result MrsLookupResult
	if files == nil {
		result = MrsLookupResult{Target: target, IPs: []string{}, Matches: []MrsMatch{}, Error: prepared.Error}
	} else {
		result = lookupMrs(ctx, files, target, params.Resolve)
		releaseToolMemory()
	}
	return result
}

func HandleMrsLookup(paramsString string) string {
	params := MrsLookupParams{}
	_ = json.Unmarshal([]byte(paramsString), &params)
	data, _ := json.Marshal(LookupMrs(params))
	return string(data)
}

func dumpMrs(dir, file string) (string, error) {
	rel := path.Clean(strings.TrimPrefix(filepath.ToSlash(file), "./"))
	if !strings.HasSuffix(rel, ".mrs") || rel == ".." || strings.HasPrefix(rel, "../") || path.IsAbs(rel) {
		return "", errors.New("invalid mrs path")
	}
	return dumpMrsDecoded(filepath.Join(dir, filepath.FromSlash(rel)), mrsKindOf(rel))
}

func dumpMrsDecoded(targetPath, kind string) (string, error) {
	handle, err := os.Open(targetPath)
	if err != nil {
		return "", err
	}
	defer handle.Close()
	decoder, err := zstd.NewReader(bufio.NewReader(handle), zstd.WithDecoderConcurrency(1), zstd.WithDecoderLowmem(true))
	if err != nil {
		return "", err
	}
	defer decoder.Close()
	matcher, _, err := readMrsMatcher(decoder, kind)
	if err != nil {
		return "", err
	}
	var builder strings.Builder
	matcher.DumpMrs(func(key string) bool {
		builder.WriteString(key)
		builder.WriteByte('\n')
		return true
	})
	return builder.String(), nil
}

func DumpMrsFile(file string) (string, error) {
	mrsLock.Lock()
	defer mrsLock.Unlock()
	defer releaseToolMemory()
	if _, err := mrsBundleVersion(constant.Path.BundleMRS()); err == nil {
		return dumpMrs(mrsDir(), file)
	}
	rel := path.Clean(strings.TrimPrefix(filepath.ToSlash(strings.TrimSpace(file)), "./"))
	if rel == "" || rel == "." || rel == ".." || strings.HasPrefix(rel, "../") || path.IsAbs(rel) || filepath.VolumeName(rel) != "" {
		return "", errors.New("invalid mrs path")
	}
	home := constant.Path.HomeDir()
	target := filepath.Join(home, filepath.FromSlash(rel))
	if back, err := filepath.Rel(home, target); err != nil || strings.HasPrefix(back, "..") {
		return "", errors.New("invalid mrs path")
	}
	return dumpMrsDecoded(target, "")
}

func HandleMrsDump(file string) string {
	content, err := DumpMrsFile(file)
	if err != nil {
		return ""
	}
	return content
}

func CancelMrsLookup() bool {
	return HandleCancelMrsLookup()
}

func HandleCancelMrsLookup() bool {
	mrsCancelLock.Lock()
	defer mrsCancelLock.Unlock()
	if mrsLookupCancel != nil {
		mrsLookupCancel()
		mrsLookupCancel = nil
	}
	return true
}
