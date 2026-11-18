package toolbox

import (
	"bytes"
	"context"
	"crypto/md5"
	"encoding/json"
	"fmt"
	"net"
	"os"
	"path/filepath"
	"runtime/debug"
	"strings"
	"testing"
	"time"

	"github.com/metacubex/mihomo/adapter"
	"github.com/metacubex/mihomo/adapter/outbound"
	"github.com/metacubex/mihomo/component/age"
	"github.com/metacubex/mihomo/component/fakeip"
	"github.com/metacubex/mihomo/component/resolver"
	"github.com/metacubex/mihomo/component/trie"
	"github.com/metacubex/mihomo/config"
	"github.com/metacubex/mihomo/constant"
	P "github.com/metacubex/mihomo/constant/provider"
	"github.com/metacubex/mihomo/rules"
	"github.com/metacubex/mihomo/rules/provider"
	"github.com/metacubex/mihomo/tunnel"
	D "github.com/miekg/dns"
)

func useToolboxTunnel(t *testing.T, ruleLines [][3]string) {
	t.Helper()
	tunnel.UpdateProxies(map[string]constant.Proxy{
		"DIRECT": adapter.NewProxy(outbound.NewDirect()),
		"Node":   adapter.NewProxy(outbound.NewDirect()),
	}, nil)
	parsed := make([]constant.Rule, 0, len(ruleLines))
	for _, line := range ruleLines {
		rule, err := rules.ParseRule(line[0], line[1], line[2], nil, nil)
		if err != nil {
			t.Fatal(err)
		}
		parsed = append(parsed, rule)
	}
	tunnel.UpdateRules(parsed, nil, nil)
	tunnel.OnRunning()
	t.Cleanup(func() {
		tunnel.UpdateRules(nil, nil, nil)
		tunnel.OnSuspend()
	})
}

func TestParseRouteTarget(t *testing.T) {
	cases := map[string]string{
		"https://www.Example.com/path?q=1": "www.example.com",
		"example.com:8443":                 "example.com",
		"example.com.":                     "example.com",
	}
	for input, want := range cases {
		host, _, ok := parseRouteTarget(input)
		if !ok || host != want {
			t.Fatalf("%s => %q %v", input, host, ok)
		}
	}
	if _, ip, ok := parseRouteTarget("[2001:db8::1]:443"); !ok || ip.String() != "2001:db8::1" {
		t.Fatalf("ipv6 parse failed %v", ip)
	}
	if _, _, ok := parseRouteTarget("bad host"); ok {
		t.Fatal("expected invalid")
	}
}

func TestRouteTraceMatchesRules(t *testing.T) {
	useToolboxTunnel(t, [][3]string{
		{"DOMAIN-SUFFIX", "google.com", "Node"},
		{"IP-CIDR", "10.0.0.0/8", "Node"},
		{"MATCH", "", "DIRECT"},
	})
	result := runRouteTrace(context.Background(), RouteTraceParams{Target: "https://mail.google.com/x"})
	if result.Error != "" || result.Matched == nil || result.Matched.Index != 0 || result.Checked != 1 {
		t.Fatalf("domain trace wrong %+v", result)
	}
	if len(result.Chains) == 0 || result.Matched.Adapter != "Node" {
		t.Fatalf("chain wrong %+v", result.Chains)
	}
	result = runRouteTrace(context.Background(), RouteTraceParams{Target: "10.1.2.3", Network: "udp", Port: 53})
	if result.Matched == nil || result.Matched.Index != 1 || result.Network != "udp" || result.DstIP != "10.1.2.3" {
		t.Fatalf("ip trace wrong %+v", result)
	}
	result = runRouteTrace(context.Background(), RouteTraceParams{Target: "1.1.1.1"})
	if result.Matched == nil || result.Matched.Type != "Match" || len(result.Steps) != 3 {
		t.Fatalf("final trace wrong %+v", result)
	}
}

func newFakeDNSServer(t *testing.T) string {
	t.Helper()
	conn, err := net.ListenPacket("udp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	server := &D.Server{PacketConn: conn, Handler: D.HandlerFunc(func(w D.ResponseWriter, req *D.Msg) {
		reply := &D.Msg{}
		reply.SetReply(req)
		question := req.Question[0]
		switch question.Qtype {
		case D.TypeA:
			reply.Answer = append(reply.Answer, &D.A{Hdr: D.RR_Header{Name: question.Name, Rrtype: D.TypeA, Class: D.ClassINET, Ttl: 60}, A: net.IPv4(1, 2, 3, 4)})
		case D.TypeTXT:
			reply.Answer = append(reply.Answer, &D.TXT{Hdr: D.RR_Header{Name: question.Name, Rrtype: D.TypeTXT, Class: D.ClassINET, Ttl: 30}, Txt: []string{"hello"}})
		}
		_ = w.WriteMsg(reply)
	})}
	go func() { _ = server.ActivateAndServe() }()
	t.Cleanup(func() { _ = server.Shutdown() })
	return conn.LocalAddr().String()
}

func TestDnsQueryCustomServer(t *testing.T) {
	server := newFakeDNSServer(t)
	result := runDnsQuery(context.Background(), DnsQueryParams{Domain: "Example.com.", Type: "A", Mode: dnsQueryModeCustom, Server: server}, false, nil)
	if result.Error != "" || len(result.Answers) != 1 || result.Answers[0].Data != "1.2.3.4" || result.Answers[0].TTL != 60 {
		t.Fatalf("A query wrong %+v", result)
	}
	result = runDnsQuery(context.Background(), DnsQueryParams{Domain: "example.com", Type: "txt", Mode: dnsQueryModeCustom, Server: "udp://" + server}, false, nil)
	if result.Error != "" || result.Type != "TXT" || len(result.Answers) != 1 || result.Answers[0].Data != "hello" {
		t.Fatalf("TXT query wrong %+v", result)
	}
	if result := runDnsQuery(context.Background(), DnsQueryParams{Domain: "example.com", Mode: dnsQueryModeFollow}, false, nil); result.Error != dnsQueryErrorStopped {
		t.Fatalf("expected stopped %+v", result)
	}
	if result := runDnsQuery(context.Background(), DnsQueryParams{Domain: "example.com", Mode: dnsQueryModeCustom, Server: "ftp://x"}, false, nil); result.Error != dnsQueryErrorServer {
		t.Fatalf("expected server error %+v", result)
	}
}

type suffixMatcher string

func (m suffixMatcher) MatchDomain(domain string) bool {
	return domain == string(m) || strings.HasSuffix(domain, "."+string(m))
}

func TestDnsQueryOutbound(t *testing.T) {
	useToolboxTunnel(t, [][3]string{
		{"DOMAIN-SUFFIX", "google.com", "Block"},
		{"MATCH", "", "DIRECT"},
	})
	tunnel.UpdateProxies(map[string]constant.Proxy{
		"DIRECT": adapter.NewProxy(outbound.NewDirect()),
		"Block":  adapter.NewProxy(outbound.NewReject()),
	}, nil)
	if name, kind := dnsQueryOutbound(context.Background(), "mail.google.com"); name != "REJECT" || kind != "Reject" {
		t.Fatalf("proxy outbound wrong %s %s", name, kind)
	}
	if name, kind := dnsQueryOutbound(context.Background(), "weixin.qq.com"); name != "DIRECT" || kind != "Direct" {
		t.Fatalf("direct outbound wrong %s %s", name, kind)
	}
}

func TestDnsQueryRoute(t *testing.T) {
	skipper := &fakeip.Skipper{Host: []constant.DomainMatcher{suffixMatcher("lan.example")}, Mode: constant.FilterBlackList}
	cfg := &config.DNS{Enable: true, EnhancedMode: constant.DNSFakeIP, FakeIPSkipper: skipper}
	if route, _ := dnsQueryRoute(cfg, "www.example.com"); route != dnsRouteFakeIP {
		t.Fatalf("blacklist miss should be fake-ip, got %s", route)
	}
	if route, _ := dnsQueryRoute(cfg, "nas.lan.example"); route != dnsRouteRealIP {
		t.Fatalf("blacklist hit should be real-ip, got %s", route)
	}
	skipper.Mode = constant.FilterWhiteList
	if route, _ := dnsQueryRoute(cfg, "www.example.com"); route != dnsRouteRealIP {
		t.Fatalf("whitelist miss should be real-ip, got %s", route)
	}
	if route, _ := dnsQueryRoute(cfg, "nas.lan.example"); route != dnsRouteFakeIP {
		t.Fatalf("whitelist hit should be fake-ip, got %s", route)
	}
	cfg.EnhancedMode = constant.DNSMapping
	if route, _ := dnsQueryRoute(cfg, "www.example.com"); route != dnsRouteMapping {
		t.Fatalf("redir-host should be mapping, got %s", route)
	}
	cfg.EnhancedMode = constant.DNSNormal
	if route, _ := dnsQueryRoute(cfg, "www.example.com"); route != dnsRouteNormal {
		t.Fatalf("normal mode wrong, got %s", route)
	}
	if route, _ := dnsQueryRoute(&config.DNS{}, "www.example.com"); route != "" {
		t.Fatalf("disabled dns should be empty, got %s", route)
	}

	tree := trie.New[resolver.HostValue]()
	value, err := resolver.NewHostValue([]string{"10.0.0.8"})
	if err != nil {
		t.Fatal(err)
	}
	_ = tree.Insert("router.example", value)
	previous := resolver.DefaultHosts
	resolver.DefaultHosts = resolver.NewHosts(tree)
	t.Cleanup(func() { resolver.DefaultHosts = previous })
	cfg = &config.DNS{Enable: true, UseHosts: true, EnhancedMode: constant.DNSFakeIP, FakeIPSkipper: &fakeip.Skipper{}}
	if route, ips := dnsQueryRoute(cfg, "router.example"); route != dnsRouteHosts || len(ips) != 1 || ips[0] != "10.0.0.8" {
		t.Fatalf("hosts route wrong %s %v", route, ips)
	}
}

func writeTestMrs(t *testing.T, dir, file string, behavior P.RuleBehavior, payload string) {
	t.Helper()
	buf := &bytes.Buffer{}
	if err := provider.ConvertToMrs([]byte(payload), behavior, P.TextRule, buf); err != nil {
		t.Fatal(err)
	}
	target := filepath.Join(dir, filepath.FromSlash(file))
	if err := os.MkdirAll(filepath.Dir(target), 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(target, buf.Bytes(), 0o644); err != nil {
		t.Fatal(err)
	}
}

func TestMrsLookupMatchesSets(t *testing.T) {
	dir := t.TempDir()
	writeTestMrs(t, dir, "geo/geosite/google.mrs", P.Domain, "+.google.com\n")
	writeTestMrs(t, dir, "geo/geosite/category-ads.mrs", P.Domain, "ads.example.com\n")
	writeTestMrs(t, dir, "geo/geoip/private.mrs", P.IPCIDR, "10.0.0.0/8\n")
	files, err := listMrsFiles(dir)
	if err != nil || len(files) != 3 {
		t.Fatalf("list failed %v %+v", err, files)
	}
	result := lookupMrs(context.Background(), files, "mail.google.com", true)
	if result.Error != "" || len(result.Matches) != 1 || result.Matches[0].Name != "google" || result.Matches[0].Kind != mrsKindGeosite {
		t.Fatalf("domain lookup wrong %+v", result)
	}
	result = lookupMrs(context.Background(), files, "10.2.3.4", true)
	if len(result.Matches) != 1 || result.Matches[0].Kind != mrsKindGeoip || result.Matches[0].File != "geo/geoip/private.mrs" {
		t.Fatalf("ip lookup wrong %+v", result)
	}
	result = lookupMrs(context.Background(), files, "mail.google.com", false)
	if len(result.IPs) != 0 || len(result.Matches) != 1 || result.Matches[0].Kind != mrsKindGeosite {
		t.Fatalf("domain only lookup wrong %+v", result)
	}
}

func TestMrsDumpRules(t *testing.T) {
	dir := t.TempDir()
	writeTestMrs(t, dir, "geo/geosite/google.mrs", P.Domain, "+.google.com\nmail.example.com\n")
	writeTestMrs(t, dir, "geo/geoip/private.mrs", P.IPCIDR, "10.0.0.0/8\n")
	content, err := dumpMrs(dir, "geo/geosite/google.mrs")
	if err != nil || !strings.Contains(content, "+.google.com\n") || !strings.Contains(content, "mail.example.com\n") {
		t.Fatalf("unexpected geosite dump: %q %v", content, err)
	}
	content, err = dumpMrs(dir, "geo/geoip/private.mrs")
	if err != nil || content != "10.0.0.0/8\n" {
		t.Fatalf("unexpected geoip dump: %q %v", content, err)
	}
	for _, file := range []string{"../google.mrs", "/etc/passwd.mrs", "geo/geosite/google.txt", "geo/geosite/missing.mrs"} {
		if _, err := dumpMrs(dir, file); err == nil {
			t.Fatalf("expected error for %s", file)
		}
	}
}

func TestMrsLookupStopsWhenCancelled(t *testing.T) {
	dir := t.TempDir()
	for i := range 40 {
		writeTestMrs(t, dir, fmt.Sprintf("geo/geosite/set%02d.mrs", i), P.Domain, "+.google.com\n")
	}
	files, err := listMrsFiles(dir)
	if err != nil {
		t.Fatal(err)
	}
	ctx, cancel := context.WithCancel(context.Background())
	cancel()
	result := lookupMrs(ctx, files, "mail.google.com", false)
	if len(result.Matches) > mrsScanWorkers {
		t.Fatalf("cancelled lookup kept scanning %d sets", len(result.Matches))
	}
	if !HandleCancelMrsLookup() {
		t.Fatal("cancel without lookup should succeed")
	}
}

func TestMrsExtractCleansUpOnFailure(t *testing.T) {
	root := t.TempDir()
	bundle := filepath.Join(root, "broken.7z")
	if err := os.WriteFile(bundle, []byte("not a 7z archive"), 0o644); err != nil {
		t.Fatal(err)
	}
	dir := filepath.Join(root, "mrs")
	if err := os.MkdirAll(dir+".tmp", 0o755); err != nil {
		t.Fatal(err)
	}
	if err := extractMrsBundle(bundle, dir, "v1"); err == nil {
		t.Fatal("broken bundle should fail")
	}
	if _, err := os.Stat(dir); !os.IsNotExist(err) {
		t.Fatalf("target dir should not exist: %v", err)
	}
}

func TestMrsRealBundle(t *testing.T) {
	bundle := os.Getenv("BETTBOX_BUNDLE_MRS")
	if bundle == "" {
		t.Skip("BETTBOX_BUNDLE_MRS not set")
	}
	dir := filepath.Join(t.TempDir(), "mrs")
	start := time.Now()
	if err := extractMrsBundle(bundle, dir, "real"); err != nil {
		t.Fatal(err)
	}
	extracted := time.Since(start)
	files, err := listMrsFiles(dir)
	if err != nil {
		t.Fatal(err)
	}
	baseline := collectSpeedTestResources()
	start = time.Now()
	result := lookupMrs(context.Background(), files, "www.google.com", true)
	elapsed := time.Since(start)
	debug.FreeOSMemory()
	after := collectSpeedTestResources()
	t.Logf("extract=%s files=%d lookup=%s matches=%d heap after %+.1fMB", extracted, len(files), elapsed, len(result.Matches), mb(after.heapInuse)-mb(baseline.heapInuse))
	for _, match := range result.Matches {
		t.Logf("  %s %s", match.Kind, match.Name)
	}
	if len(result.Matches) == 0 {
		t.Fatal("expected google matches")
	}
}

func TestMrsCachedProvidersFallback(t *testing.T) {
	home := t.TempDir()
	previousHome := constant.Path.HomeDir()
	constant.SetHomeDir(home)
	t.Cleanup(func() { constant.SetHomeDir(previousHome) })

	previousEnv := env
	Setup(Host{
		State: func() (bool, *config.Config, *config.RawConfig) {
			return false, nil, &config.RawConfig{
				RuleProvider: map[string]map[string]any{
					"google-domain": {"url": "https://example.com/google.mrs", "type": "http", "format": "mrs"},
				},
			}
		},
	})
	t.Cleanup(func() { Setup(previousEnv) })

	digest := fmt.Sprintf("%x", md5.Sum([]byte("google-domain@https://example.com/google.mrs")))
	writeTestMrs(t, home, filepath.ToSlash(filepath.Join("profiles", "providers", "1", "rules", digest)), P.Domain, "+.google.com\n")
	writeTestMrs(t, home, "ruleset/private.mrs", P.IPCIDR, "10.0.0.0/8\n")

	prep := PrepareMrs()
	if prep.Error != "" || prep.Version != "cached" || prep.Geosite != 1 || prep.Geoip != 1 {
		t.Fatalf("unexpected cached prepare: %+v", prep)
	}
	res := LookupMrs(MrsLookupParams{Target: "mail.google.com", Resolve: false})
	if res.Error != "" || len(res.Matches) != 1 || res.Matches[0].Name != "google-domain" || !res.Matches[0].Referenced {
		t.Fatalf("unexpected cached lookup: %+v", res)
	}
	dumped, err := DumpMrsFile(res.Matches[0].File)
	if err != nil || !strings.Contains(dumped, "+.google.com\n") {
		t.Fatalf("cached dump failed: %v %q", err, dumped)
	}
	ipRes := LookupMrs(MrsLookupParams{Target: "10.1.2.3", Resolve: false})
	if ipRes.Error != "" || len(ipRes.Matches) != 1 || ipRes.Matches[0].Name != "private" {
		t.Fatalf("unexpected cached ip lookup: %+v", ipRes)
	}
}

func TestAgeKeygenAndCryptRoundTrip(t *testing.T) {
	for _, hybrid := range []bool{false, true} {
		pair, err := GenerateAgeKeyPair(AgeKeygenParams{Hybrid: hybrid})
		if err != nil || pair.PublicKey == "" || pair.SecretKey == "" {
			t.Fatalf("keygen(%v) failed: %+v err=%v", hybrid, pair, err)
		}
		enc := CryptAge(AgeCryptParams{Mode: "encrypt", Data: "hello", Keys: []string{pair.PublicKey}})
		if enc.Error != "" || enc.Data == "" {
			t.Fatalf("encrypt failed %+v", enc)
		}
		dec := CryptAge(AgeCryptParams{Mode: "decrypt", Data: enc.Data, Keys: []string{pair.SecretKey}})
		if dec.Error != "" || dec.Data != "hello" {
			t.Fatalf("decrypt failed %+v", dec)
		}
	}
}

func TestAgeCryptRoundTrip(t *testing.T) {
	for name, generate := range map[string]func() (string, string, error){
		"x25519":         age.GenX25519KeyPair,
		"mlkem768x25519": age.GenHybridKeyPair,
	} {
		t.Run(name, func(t *testing.T) {
			secret, public, err := generate()
			if err != nil {
				t.Fatal(err)
			}
			params, _ := json.Marshal(AgeCryptParams{Mode: "encrypt", Data: "hello", Keys: []string{public}})
			var encrypted AgeCryptResult
			_ = json.Unmarshal([]byte(HandleAgeCrypt(string(params))), &encrypted)
			if encrypted.Error != "" || encrypted.Data == "" {
				t.Fatalf("encrypt failed %+v", encrypted)
			}
			params, _ = json.Marshal(AgeCryptParams{Mode: "decrypt", Data: encrypted.Data, Keys: []string{secret}})
			var decrypted AgeCryptResult
			_ = json.Unmarshal([]byte(HandleAgeCrypt(string(params))), &decrypted)
			if decrypted.Error != "" || decrypted.Data != "hello" {
				t.Fatalf("decrypt failed %+v", decrypted)
			}
			params, _ = json.Marshal(AgeCryptParams{Mode: "decrypt", Data: "plain", Keys: []string{secret}})
			_ = json.Unmarshal([]byte(HandleAgeCrypt(string(params))), &decrypted)
			if decrypted.Error == "" {
				t.Fatal("expected error for plain text")
			}
		})
	}
}
