package core

import (
	"encoding/base64"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"reflect"
	"sync/atomic"
	"testing"
)

func expandProfile(t *testing.T, content string, options expandOptions) []string {
	t.Helper()
	rawCfg, err := unmarshalRawConfig([]byte(content))
	if err != nil {
		t.Fatal(err)
	}
	if err := expandProxyProviders(rawCfg, options); err != nil {
		t.Fatal(err)
	}
	if rawCfg.ProxyProvider != nil {
		t.Fatal("proxy-providers should be removed")
	}
	var names []string
	for _, proxy := range rawCfg.Proxy {
		names = append(names, proxy["name"].(string))
	}
	return names
}

func TestExpandInlineProviderAppliesFilters(t *testing.T) {
	names := expandProfile(t, `
proxies:
  - {name: HK 01, type: ss, server: a.com, port: 1, cipher: aes-128-gcm, password: p}
proxy-providers:
  inline:
    type: inline
    filter: HK|JP
    exclude-filter: 过期
    exclude-type: vmess
    override:
      additional-prefix: "[P] "
      proxy-name:
        - pattern: "HK"
          target: "香港"
    payload:
      - {name: HK 01, type: ss, server: b.com, port: 2, cipher: aes-128-gcm, password: p}
      - {name: JP 01, type: vmess, server: c.com, port: 3, uuid: 8e8a7c5f-3b6c-4c8f-9a51-8f0b5f4c2c11, cipher: auto}
      - {name: JP 02, type: ss, server: d.com, port: 4, cipher: aes-128-gcm, password: p}
      - {name: HK 过期, type: ss, server: e.com, port: 5, cipher: aes-128-gcm, password: p}
`, expandOptions{})
	want := []string{"HK 01", "[P] 香港 01", "[P] JP 02"}
	if !reflect.DeepEqual(names, want) {
		t.Fatalf("names = %v, want %v", names, want)
	}
}

func TestExpandRenamesDuplicateNamesAndMaterializesGroups(t *testing.T) {
	rawCfg, err := unmarshalRawConfig([]byte(`
proxies:
  - {name: HK, type: ss, server: a.com, port: 1, cipher: aes-128-gcm, password: p}
proxy-groups:
  - {name: JP, type: select, proxies: [HK]}
  - {name: Auto, type: smart, use: [one], filter: JP}
proxy-providers:
  one:
    type: inline
    payload:
      - {name: HK, type: ss, server: b.com, port: 2, cipher: aes-128-gcm, password: p}
      - {name: JP, type: ss, server: c.com, port: 3, cipher: aes-128-gcm, password: p}
`))
	if err != nil {
		t.Fatal(err)
	}
	if err := expandProxyProviders(rawCfg, expandOptions{}); err != nil {
		t.Fatal(err)
	}
	var names []string
	for _, proxy := range rawCfg.Proxy {
		names = append(names, proxy["name"].(string))
	}
	if want := []string{"HK", "HK 2", "JP 2"}; !reflect.DeepEqual(names, want) {
		t.Fatalf("names = %v, want %v", names, want)
	}
	auto := rawCfg.ProxyGroup[1]
	if _, hasUse := auto["use"]; hasUse {
		t.Fatal("use should be removed after materialization")
	}
	if got := auto["proxies"]; !reflect.DeepEqual(got, []any{"JP 2"}) {
		t.Fatalf("auto proxies = %v, want [JP 2]", got)
	}
}

func TestExpandHttpProviderReadsCache(t *testing.T) {
	dir := t.TempDir()
	url := "http://127.0.0.1:1/sub"
	cache := providerCacheFilePath(dir, "proxies", "sub@"+url)
	if err := os.MkdirAll(filepath.Dir(cache), 0o755); err != nil {
		t.Fatal(err)
	}
	links := "ss://" + base64.RawURLEncoding.EncodeToString([]byte("aes-128-gcm:pass")) + "@1.2.3.4:8388#Cached"
	if err := os.WriteFile(cache, []byte(base64.StdEncoding.EncodeToString([]byte(links))), 0o600); err != nil {
		t.Fatal(err)
	}
	content := `
proxy-providers:
  sub:
    type: http
    url: ` + url + `
    dialer-proxy: relay
`

	rawCfg, err := unmarshalRawConfig([]byte(content))
	if err != nil {
		t.Fatal(err)
	}
	if err := expandProxyProviders(rawCfg, expandOptions{ProvidersPath: dir}); err != nil {
		t.Fatal(err)
	}
	if len(rawCfg.Proxy) != 1 || rawCfg.Proxy[0]["name"] != "Cached" || rawCfg.Proxy[0]["dialer-proxy"] != "relay" {
		t.Fatalf("proxies = %v", rawCfg.Proxy)
	}
	rawRefresh, err := unmarshalRawConfig([]byte(content))
	if err != nil {
		t.Fatal(err)
	}
	if err := expandProxyProviders(rawRefresh, expandOptions{ProvidersPath: dir, Refresh: true}); err != nil {
		t.Fatalf("refresh should fall back to the cache: %v", err)
	}
}

func TestExpandHttpProviderFallsBackToPayload(t *testing.T) {
	names := expandProfile(t, `
proxy-providers:
  sub:
    type: http
    url: http://127.0.0.1:1/missing
    payload:
      - {name: Seed, type: ss, server: a.com, port: 1, cipher: aes-128-gcm, password: p}
`, expandOptions{ProvidersPath: t.TempDir()})
	if !reflect.DeepEqual(names, []string{"Seed"}) {
		t.Fatalf("names = %v", names)
	}
}

func TestExpandHttpProviderHonorsInterval(t *testing.T) {
	var hits atomic.Int32
	links := "ss://" + base64.RawURLEncoding.EncodeToString([]byte("aes-128-gcm:pass")) + "@1.2.3.4:8388#Fresh"
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		hits.Add(1)
		_, _ = w.Write([]byte(links))
	}))
	defer server.Close()
	dir := t.TempDir()
	content := `
proxy-providers:
  sub:
    type: http
    url: ` + server.URL + `
    interval: 3600
`

	expand := func() {
		t.Helper()
		if names := expandProfile(t, content, expandOptions{ProvidersPath: dir}); !reflect.DeepEqual(names, []string{"Fresh"}) {
			t.Fatalf("names = %v", names)
		}
	}
	expand()
	cache := providerCacheFilePath(dir, "proxies", "sub@"+server.URL)
	if _, err := os.Stat(cache); err != nil {
		t.Fatalf("download should be cached: %v", err)
	}
	expand()
	if got := hits.Load(); got != 1 {
		t.Fatalf("hits = %d, want 1", got)
	}
}
