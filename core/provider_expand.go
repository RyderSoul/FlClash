package core

import (
	"context"
	"crypto/md5"
	"encoding/hex"
	"errors"
	"fmt"
	"io"
	"maps"
	"net/http"
	"os"
	"path/filepath"
	"sort"
	"strconv"
	"strings"
	"time"

	"github.com/dlclark/regexp2"
	"github.com/metacubex/mihomo/adapter/provider"
	"github.com/metacubex/mihomo/common/convert"
	"github.com/metacubex/mihomo/common/structure"
	"github.com/metacubex/mihomo/common/yaml"
	"github.com/metacubex/mihomo/component/age"
	mihomoHttp "github.com/metacubex/mihomo/component/http"
	"github.com/metacubex/mihomo/component/resource"
	"github.com/metacubex/mihomo/config"
	C "github.com/metacubex/mihomo/constant"
)

type expandOptions struct {
	ProvidersPath string
	AgeSecretKey  string
	Refresh       bool
}

type providerProxyName struct {
	Pattern *regexp2.Regexp `provider:"pattern"`
	Target  string          `provider:"target"`
}

type providerOverride struct {
	TFO              *bool                   `provider:"tfo,omitempty"`
	MPTcp            *bool                   `provider:"mptcp,omitempty"`
	UDP              *bool                   `provider:"udp,omitempty"`
	UDPOverTCP       *bool                   `provider:"udp-over-tcp,omitempty"`
	Up               *string                 `provider:"up,omitempty"`
	Down             *string                 `provider:"down,omitempty"`
	DialerProxy      *string                 `provider:"dialer-proxy,omitempty"`
	SkipCertVerify   *bool                   `provider:"skip-cert-verify,omitempty"`
	NameCertVerify   *string                 `provider:"name-cert-verify,omitempty"`
	Interface        *string                 `provider:"interface-name,omitempty"`
	RoutingMark      *int                    `provider:"routing-mark,omitempty"`
	IPVersion        *string                 `provider:"ip-version,omitempty"`
	AdditionalPrefix *string                 `provider:"additional-prefix,omitempty"`
	AdditionalSuffix *string                 `provider:"additional-suffix,omitempty"`
	ProxyName        []providerProxyName     `provider:"proxy-name,omitempty"`
	OverrideExpr     []provider.OverrideExpr `provider:"override-expr,omitempty"`
}

type expandProviderSchema struct {
	Type          string              `provider:"type"`
	Path          string              `provider:"path,omitempty"`
	URL           string              `provider:"url,omitempty"`
	Proxy         string              `provider:"proxy,omitempty"`
	Filter        string              `provider:"filter,omitempty"`
	ExcludeFilter string              `provider:"exclude-filter,omitempty"`
	ExcludeType   string              `provider:"exclude-type,omitempty"`
	DialerProxy   string              `provider:"dialer-proxy,omitempty"`
	SizeLimit     int64               `provider:"size-limit,omitempty"`
	Interval      int                 `provider:"interval,omitempty"`
	Payload       []map[string]any    `provider:"payload,omitempty"`
	AgeSecretKey  string              `provider:"age-secret-key,omitempty"`
	Override      providerOverride    `provider:"override,omitempty"`
	Header        map[string][]string `provider:"header,omitempty"`
}

func providerCacheFilePath(base, kind, key string) string {
	sum := md5.Sum([]byte(key))
	return filepath.Join(base, kind, hex.EncodeToString(sum[:]))
}

func (o *providerOverride) apply(mapping map[string]any) error {
	if o.TFO != nil {
		mapping["tfo"] = *o.TFO
	}
	if o.MPTcp != nil {
		mapping["mptcp"] = *o.MPTcp
	}
	if o.UDP != nil {
		mapping["udp"] = *o.UDP
	}
	if o.UDPOverTCP != nil {
		mapping["udp-over-tcp"] = *o.UDPOverTCP
	}
	if o.Up != nil {
		mapping["up"] = *o.Up
	}
	if o.Down != nil {
		mapping["down"] = *o.Down
	}
	if o.DialerProxy != nil {
		mapping["dialer-proxy"] = *o.DialerProxy
	}
	if o.SkipCertVerify != nil {
		mapping["skip-cert-verify"] = *o.SkipCertVerify
	}
	if o.NameCertVerify != nil {
		mapping["name-cert-verify"] = *o.NameCertVerify
	}
	if o.Interface != nil {
		mapping["interface-name"] = *o.Interface
	}
	if o.RoutingMark != nil {
		mapping["routing-mark"] = *o.RoutingMark
	}
	if o.IPVersion != nil {
		mapping["ip-version"] = *o.IPVersion
	}
	name, _ := mapping["name"].(string)
	for _, expr := range o.ProxyName {
		if expr.Pattern == nil {
			continue
		}
		replaced, err := expr.Pattern.Replace(name, expr.Target, 0, -1)
		if err != nil {
			return fmt.Errorf("proxy name replace error: %w", err)
		}
		name = replaced
	}
	if o.AdditionalPrefix != nil {
		name = *o.AdditionalPrefix + name
	}
	if o.AdditionalSuffix != nil {
		name += *o.AdditionalSuffix
	}
	mapping["name"] = name
	for idx, expr := range o.OverrideExpr {
		if err := expr.Apply(mapping); err != nil {
			return fmt.Errorf("override-expr[%d] %q: %w", idx, expr.String(), err)
		}
	}
	return nil
}

func expandProxyProviders(raw *config.RawConfig, options expandOptions) error {
	if len(raw.ProxyProvider) == 0 {
		return nil
	}
	names := make([]string, 0, len(raw.ProxyProvider))
	for name := range raw.ProxyProvider {
		names = append(names, name)
	}
	sort.Strings(names)
	used := make(map[string]bool, len(raw.Proxy)+len(raw.ProxyGroup))
	staticProxies := make([]map[string]any, 0, len(raw.Proxy))
	for _, item := range raw.Proxy {
		staticProxies = append(staticProxies, item)
		if name, ok := item["name"].(string); ok {
			used[name] = true
		}
	}
	for _, item := range raw.ProxyGroup {
		if name, ok := item["name"].(string); ok {
			used[name] = true
		}
	}
	expandedByProvider := make(map[string][]map[string]any, len(names))
	allExpanded := make([]map[string]any, 0)
	decoder := structure.NewDecoder(structure.Option{TagName: "provider", WeaklyTypedInput: true})
	for _, name := range names {
		mapping := raw.ProxyProvider[name]
		if mapping == nil {
			continue
		}
		schema := &expandProviderSchema{}
		if err := decoder.Decode(mapping, schema); err != nil {
			return fmt.Errorf("proxy provider %s: %w", name, err)
		}
		proxies, err := loadProviderProxies(name, schema, options)
		if err != nil {
			return fmt.Errorf("proxy provider %s: %w", name, err)
		}
		assigned := make([]map[string]any, 0, len(proxies))
		for _, proxy := range proxies {
			proxy["name"] = uniqueProxyName(proxy["name"].(string), used)
			raw.Proxy = append(raw.Proxy, proxy)
			assigned = append(assigned, proxy)
			allExpanded = append(allExpanded, proxy)
		}
		expandedByProvider[name] = assigned
	}
	if err := materializeGroupProviders(raw, staticProxies, allExpanded, expandedByProvider); err != nil {
		return err
	}
	raw.ProxyProvider = nil
	return nil
}

func materializeGroupProviders(
	raw *config.RawConfig,
	staticProxies []map[string]any,
	allExpanded []map[string]any,
	byProvider map[string][]map[string]any,
) error {
	for _, group := range raw.ProxyGroup {
		useNames := stringSliceValue(group["use"])
		includeAll := boolValue(group["include-all"])
		includeAllProxies := boolValue(group["include-all-proxies"])
		includeAllProviders := boolValue(group["include-all-providers"])
		if len(useNames) == 0 && !includeAll && !includeAllProxies && !includeAllProviders {
			continue
		}
		var candidates []map[string]any
		if includeAll || includeAllProxies {
			candidates = append(candidates, staticProxies...)
		}
		if includeAll || includeAllProviders {
			candidates = append(candidates, allExpanded...)
		} else {
			for _, providerName := range useNames {
				candidates = append(candidates, byProvider[providerName]...)
			}
		}
		filtered, err := selectGroupCandidates(candidates, group)
		if err != nil {
			return err
		}
		existing := listValue(group["proxies"])
		seen := make(map[string]bool, len(existing))
		for _, item := range existing {
			seen[fmt.Sprint(item)] = true
		}
		for _, name := range filtered {
			if !seen[name] {
				seen[name] = true
				existing = append(existing, name)
			}
		}
		if len(existing) == 0 {
			existing = []any{"DIRECT"}
		}
		group["proxies"] = existing
		delete(group, "use")
		delete(group, "include-all")
		delete(group, "include-all-proxies")
		delete(group, "include-all-providers")
		delete(group, "filter")
		delete(group, "exclude-filter")
		delete(group, "exclude-type")
	}
	return nil
}

func selectGroupCandidates(candidates []map[string]any, group map[string]any) ([]string, error) {
	excludeTypes := splitPipeTypes(stringValue(group["exclude-type"]))
	var excludeFilters []*regexp2.Regexp
	if excludeStr := stringValue(group["exclude-filter"]); excludeStr != "" {
		var err error
		excludeFilters, err = compileBacktickRegexes(excludeStr)
		if err != nil {
			return nil, fmt.Errorf("invalid group exclude-filter regex: %w", err)
		}
	}
	filterStr := stringValue(group["filter"])
	filters, err := compileBacktickRegexes(filterStr)
	if err != nil {
		return nil, fmt.Errorf("invalid group filter regex: %w", err)
	}
	var names []string
	seen := make(map[string]bool, len(candidates))
	for _, filter := range filters {
	next:
		for _, mapping := range candidates {
			if matchesExcludedType(mapping, excludeTypes) {
				continue
			}
			name, ok := mapping["name"].(string)
			if !ok {
				continue
			}
			for _, exclude := range excludeFilters {
				if matched, _ := exclude.MatchString(name); matched {
					continue next
				}
			}
			if filterStr != "" {
				if matched, _ := filter.MatchString(name); !matched {
					continue
				}
			}
			if !seen[name] {
				seen[name] = true
				names = append(names, name)
			}
		}
	}
	return names, nil
}

func uniqueProxyName(name string, used map[string]bool) string {
	candidate := name
	for index := 2; used[candidate]; index++ {
		candidate = name + " " + strconv.Itoa(index)
	}
	used[candidate] = true
	return candidate
}

func loadProviderProxies(providerName string, schema *expandProviderSchema, options expandOptions) ([]map[string]any, error) {
	var mappings []map[string]any
	switch schema.Type {
	case "inline":
		mappings = schema.Payload
	case "file", "http":
		buf, err := readProviderContent(providerName, schema, options)
		if err != nil {
			if len(schema.Payload) == 0 {
				return nil, err
			}
			mappings = schema.Payload
			break
		}
		ageSecretKey := schema.AgeSecretKey
		if ageSecretKey == "" {
			ageSecretKey = options.AgeSecretKey
		}
		mappings, err = parseProviderContent(buf, ageSecretKey)
		if err != nil {
			return nil, err
		}
	default:
		return nil, fmt.Errorf("unsupported vehicle type: %s", schema.Type)
	}
	return filterProviderProxies(mappings, schema)
}

func readProviderContent(providerName string, schema *expandProviderSchema, options expandOptions) ([]byte, error) {
	if schema.Type == "file" {
		path := C.Path.Resolve(schema.Path)
		if !C.Path.IsSafePath(path) {
			return nil, C.Path.ErrNotSafePath(path)
		}
		return os.ReadFile(path)
	}
	candidates := httpProviderCacheCandidates(options.ProvidersPath, providerName, schema.URL)
	if !options.Refresh {
		for _, cache := range candidates {
			if providerCacheFresh(cache, schema.Interval) {
				if buf, err := os.ReadFile(cache); err == nil && len(buf) > 0 {
					return buf, nil
				}
			}
		}
	}
	buf, err := downloadProviderContent(schema)
	if err == nil {
		if options.ProvidersPath != "" && len(candidates) > 0 {
			writeProviderCache(candidates[0], buf)
		}
		return buf, nil
	}
	for _, cache := range candidates {
		if cached, readErr := os.ReadFile(cache); readErr == nil && len(cached) > 0 {
			return cached, nil
		}
	}
	return nil, err
}

func httpProviderCacheCandidates(base, providerName, rawURL string) []string {
	if base == "" {
		return nil
	}
	candidates := make([]string, 0, 3)
	seen := map[string]bool{}
	add := func(key string) {
		if key == "" {
			return
		}
		path := providerCacheFilePath(base, "proxies", key)
		if !seen[path] {
			seen[path] = true
			candidates = append(candidates, path)
		}
	}
	if providerName != "" && rawURL != "" {
		add(providerName + "@" + rawURL)
	}
	add(rawURL)
	if providerName != "" {
		add("proxy-providers/" + providerName)
	}
	return candidates
}

func providerCacheFresh(path string, interval int) bool {
	info, err := os.Stat(path)
	if err != nil || info.Size() == 0 {
		return false
	}
	return interval <= 0 || time.Since(info.ModTime()) < time.Duration(interval)*time.Second
}

func writeProviderCache(path string, buf []byte) {
	if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
		return
	}
	temp := path + ".tmp"
	if err := os.WriteFile(temp, buf, 0o644); err != nil {
		return
	}
	if err := os.Rename(temp, path); err != nil {
		_ = os.Remove(temp)
		return
	}
	scheduleReclaimOwnership()
}

func downloadProviderContent(schema *expandProviderSchema) ([]byte, error) {
	ctx, cancel := context.WithTimeout(context.Background(), resource.DefaultHttpTimeout)
	defer cancel()
	resp, err := mihomoHttp.HttpRequest(ctx, schema.URL, http.MethodGet, schema.Header, nil, mihomoHttp.WithSpecialProxy(schema.Proxy))
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	if resp.StatusCode < 200 || resp.StatusCode > 299 {
		return nil, errors.New(resp.Status)
	}
	var reader io.Reader = resp.Body
	if schema.SizeLimit > 0 {
		reader = io.LimitReader(reader, schema.SizeLimit)
	}
	return io.ReadAll(reader)
}

func parseProviderContent(buf []byte, ageSecretKey string) ([]map[string]any, error) {
	var keys []string
	if ageSecretKey != "" {
		keys = append(keys, ageSecretKey)
	}
	ageMu.Lock()
	decrypted, err := age.DecryptBytes(buf, keys...)
	ageMu.Unlock()
	if err != nil {
		return nil, fmt.Errorf("decrypt config error: %w", err)
	}
	schema := struct {
		Proxies []map[string]any `yaml:"proxies"`
	}{}
	if err := yaml.Unmarshal(decrypted, &schema); err != nil || schema.Proxies == nil {
		proxies, convertErr := convert.ConvertsV2Ray(decrypted)
		if convertErr != nil {
			if err != nil {
				return nil, fmt.Errorf("%w, %w", err, convertErr)
			}
			return nil, errors.New("file must have a `proxies` field")
		}
		schema.Proxies = proxies
	}
	if schema.Proxies == nil {
		return nil, errors.New("file must have a `proxies` field")
	}
	return schema.Proxies, nil
}

func compileBacktickRegexes(pattern string) ([]*regexp2.Regexp, error) {
	parts := strings.Split(pattern, "`")
	regexes := make([]*regexp2.Regexp, 0, len(parts))
	for _, part := range parts {
		reg, err := regexp2.Compile(part, regexp2.None)
		if err != nil {
			return nil, err
		}
		regexes = append(regexes, reg)
	}
	return regexes, nil
}

func splitPipeTypes(value string) []string {
	if value == "" {
		return nil
	}
	return strings.Split(value, "|")
}

func matchesExcludedType(mapping map[string]any, excludeTypes []string) bool {
	if len(excludeTypes) == 0 {
		return false
	}
	kind, ok := mapping["type"].(string)
	if !ok {
		return true
	}
	for _, excludeType := range excludeTypes {
		if strings.EqualFold(kind, excludeType) {
			return true
		}
	}
	return false
}

func filterProviderProxies(mappings []map[string]any, schema *expandProviderSchema) ([]map[string]any, error) {
	excludeTypes := splitPipeTypes(schema.ExcludeType)
	var excludeFilters []*regexp2.Regexp
	if schema.ExcludeFilter != "" {
		var err error
		excludeFilters, err = compileBacktickRegexes(schema.ExcludeFilter)
		if err != nil {
			return nil, fmt.Errorf("invalid excludeFilter regex: %w", err)
		}
	}
	filters, err := compileBacktickRegexes(schema.Filter)
	if err != nil {
		return nil, fmt.Errorf("invalid filter regex: %w", err)
	}
	var result []map[string]any
	seen := map[string]bool{}
	for _, filter := range filters {
	next:
		for idx, mapping := range mappings {
			if matchesExcludedType(mapping, excludeTypes) {
				continue
			}
			name, ok := mapping["name"].(string)
			if !ok {
				continue
			}
			for _, exclude := range excludeFilters {
				if matched, _ := exclude.MatchString(name); matched {
					continue next
				}
			}
			if schema.Filter != "" {
				if matched, _ := filter.MatchString(name); !matched {
					continue
				}
			}
			if seen[name] {
				continue
			}
			proxy := make(map[string]any, len(mapping)+1)
			maps.Copy(proxy, mapping)
			if schema.DialerProxy != "" {
				proxy["dialer-proxy"] = schema.DialerProxy
			}
			if err := schema.Override.apply(proxy); err != nil {
				return nil, fmt.Errorf("proxy %d override error: %w", idx, err)
			}
			seen[name] = true
			result = append(result, proxy)
		}
	}
	if len(result) == 0 {
		if schema.Filter != "" {
			return nil, errors.New("doesn't match any proxy, please check your filter")
		}
		return nil, errors.New("file doesn't have any proxy")
	}
	return result, nil
}

func stringSliceValue(value any) []string {
	list, ok := value.([]any)
	if !ok {
		return nil
	}
	result := make([]string, 0, len(list))
	for _, item := range list {
		if text, ok := item.(string); ok && text != "" {
			result = append(result, text)
		}
	}
	return result
}

func boolValue(value any) bool {
	flag, _ := value.(bool)
	return flag
}
