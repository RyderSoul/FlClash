package core

import (
	"encoding/json"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"testing"
	"time"

	"github.com/metacubex/mihomo/config"
)

func mergeProxy(name string, server string) map[string]any {
	return map[string]any{"name": name, "type": "ss", "server": server, "port": 443, "cipher": "aes-128-gcm", "password": "pw"}
}

func mergeGroup(name string, proxies ...string) map[string]any {
	list := make([]any, 0, len(proxies))
	for _, proxy := range proxies {
		list = append(list, proxy)
	}
	return map[string]any{"name": name, "type": "select", "proxies": list}
}

func mergeConfig(proxies []map[string]any, groups ...map[string]any) map[string]any {
	proxyList := make([]any, 0, len(proxies))
	for _, proxy := range proxies {
		proxyList = append(proxyList, proxy)
	}
	groupList := make([]any, 0, len(groups))
	for _, group := range groups {
		groupList = append(groupList, group)
	}
	return map[string]any{"proxies": proxyList, "proxy-groups": groupList, "rules": []any{"MATCH,默认代理"}}
}

func mergedNames(merged map[string]any) []string {
	var names []string
	for _, proxy := range mapItems(merged["proxies"]) {
		names = append(names, stringValue(proxy["name"]))
	}
	return names
}

func mergedGroups(merged map[string]any) map[string][]string {
	result := map[string][]string{}
	for _, group := range mapItems(merged["proxy-groups"]) {
		var refs []string
		for _, item := range listValue(group["proxies"]) {
			refs = append(refs, item.(string))
		}
		result[stringValue(group["name"])] = refs
	}
	return result
}

func mergedGroupOrder(merged map[string]any) []string {
	var names []string
	for _, group := range mapItems(merged["proxy-groups"]) {
		names = append(names, stringValue(group["name"]))
	}
	return names
}

func TestMergeDeduplicatesByContentAndPreservesSmartGroups(t *testing.T) {
	shared := mergeProxy("共用", "shared.example.com")
	smartGroup := map[string]any{
		"name":        "智能优选",
		"type":        "smart",
		"uselightgbm": false,
		"proxies":     []any{"共用", "HK 01"},
	}
	merged, report := mergeProfileConfigs([]mergeInput{
		{config: mergeConfig([]map[string]any{shared, mergeProxy("HK 01", "hk.a.com")}, mergeGroup("默认代理", "共用", "HK 01"), smartGroup), prefix: "A"},
		{config: mergeConfig([]map[string]any{mergeProxy("同款", "shared.example.com"), mergeProxy("JP 01", "jp.b.com")}, mergeGroup("默认代理", "同款", "JP 01"), map[string]any{"name": "智能优选", "type": "smart", "proxies": []any{"JP 01"}}), prefix: "B"},
	})
	if got, want := mergedNames(merged), []string{"[ A ] - 共用", "[ A ] - HK 01", "[ B ] - JP 01"}; !reflect.DeepEqual(got, want) {
		t.Fatalf("names = %v, want %v", got, want)
	}
	if got, want := mergedGroups(merged)["默认代理"], []string{"[ A ] - 共用", "[ A ] - HK 01", "[ B ] - JP 01"}; !reflect.DeepEqual(got, want) {
		t.Fatalf("group = %v, want %v", got, want)
	}
	if got, want := mergedGroups(merged)["智能优选"], []string{"[ A ] - 共用", "[ A ] - HK 01", "[ B ] - JP 01"}; !reflect.DeepEqual(got, want) {
		t.Fatalf("smart group = %v, want %v", got, want)
	}
	smartDef := mapItems(merged["proxy-groups"])[1]
	if smartDef["type"] != "smart" || smartDef["uselightgbm"] != false {
		t.Fatalf("smart group attributes lost: %v", smartDef)
	}
	if report.Proxies != 3 || report.Duplicates != 1 || report.Groups != 2 {
		t.Fatalf("report = %+v", report)
	}
}

func TestMergePrefixCollisionsAndSanitize(t *testing.T) {
	merged, _ := mergeProfileConfigs([]mergeInput{
		{config: mergeConfig([]map[string]any{mergeProxy("HK, 01", "a.com")}), prefix: "云"},
		{config: mergeConfig([]map[string]any{mergeProxy("HK, 01", "b.com")}), prefix: "云"},
		{config: mergeConfig([]map[string]any{mergeProxy("DIRECT", "c.com")}), prefix: ""},
		{config: mergeConfig([]map[string]any{mergeProxy("line\none", "d.com")}), prefix: ""},
	})
	want := []string{"[ 云 ] - HK， 01", "[ 云 ] - HK， 01-2", "DIRECT-2", "line one"}
	if got := mergedNames(merged); !reflect.DeepEqual(got, want) {
		t.Fatalf("names = %v, want %v", got, want)
	}
}

func TestMergeRewritesDialerProxyAndRestoresGroupOrder(t *testing.T) {
	relay := mergeProxy("中转", "relay.com")
	landing := mergeProxy("落地", "land.com")
	landing["dialer-proxy"] = "中转"
	merged, _ := mergeProfileConfigs([]mergeInput{
		{config: mergeConfig([]map[string]any{relay, landing}, mergeGroup("默认代理", "手动选择"), mergeGroup("手动选择", "中转"), mergeGroup("香港", "落地")), prefix: "A"},
		{config: mergeConfig([]map[string]any{mergeProxy("JP", "jp.com")}, mergeGroup("默认代理", "手动选择"), mergeGroup("低倍率", "JP"), mergeGroup("手动选择", "JP")), prefix: "B"},
	})
	if got := mapItems(merged["proxies"])[1]["dialer-proxy"]; got != "[ A ] - 中转" {
		t.Fatalf("dialer-proxy = %v", got)
	}
	wantOrder := []string{"默认代理", "低倍率", "手动选择", "香港"}
	if got := mergedGroupOrder(merged); !reflect.DeepEqual(got, wantOrder) {
		t.Fatalf("order = %v, want %v", got, wantOrder)
	}
}

func TestMergeNameserverPolicyAndHosts(t *testing.T) {
	first := mergeConfig([]map[string]any{mergeProxy("A1", "n1.a.com"), mergeProxy("A2", "n2.a.com"), mergeProxy("S1", "x.shared.net")})
	first["dns"] = map[string]any{
		"enable":                         true,
		"proxy-server-nameserver-policy": map[string]any{"+.a.com": []any{"1.1.1.1"}, "+.shared.net": []any{"9.9.9.9"}, "geosite:cn": "system"},
		"fake-ip-filter":                 []any{"rule-set:private", "+.a.com"},
	}
	first["hosts"] = map[string]any{"a.com": "1.1.1.1"}
	second := mergeConfig([]map[string]any{mergeProxy("B1", "n3.a.com"), mergeProxy("S2", "y.shared.net")})
	second["dns"] = map[string]any{
		"enable":                         false,
		"proxy-server-nameserver-policy": map[string]any{"+.a.com": []any{"1.1.1.1"}, "+.shared.net": []any{"8.8.8.8"}},
		"fake-ip-filter":                 []any{"rule-set:private", "+.shared.net"},
	}
	second["hosts"] = map[string]any{"a.com": "2.2.2.2", "b.com": "3.3.3.3"}
	merged, _ := mergeProfileConfigs([]mergeInput{{config: first, prefix: "A"}, {config: second, prefix: "B"}})
	dns := mapValue(merged["dns"])
	want := map[string]any{
		"+.a.com":      []any{"1.1.1.1"},
		"x.shared.net": []any{"9.9.9.9"},
		"y.shared.net": []any{"8.8.8.8"},
		"geosite:cn":   "system",
	}
	if got := dns["proxy-server-nameserver-policy"]; !reflect.DeepEqual(got, want) {
		t.Fatalf("policy = %v, want %v", got, want)
	}
	if got := mapValue(merged["hosts"]); !reflect.DeepEqual(got, map[string]any{"a.com": "1.1.1.1", "b.com": "3.3.3.3"}) {
		t.Fatalf("hosts = %v", got)
	}
}

func TestHandleMergeProfilesWritesValidYamlAndPreservesOnFailure(t *testing.T) {
	dir := t.TempDir()
	write := func(name string, value map[string]any) string {
		data, err := json.Marshal(value)
		if err != nil {
			t.Fatal(err)
		}
		path := filepath.Join(dir, name)
		if err := os.WriteFile(path, data, 0o600); err != nil {
			t.Fatal(err)
		}
		return path
	}
	first := write("a.json", mergeConfig([]map[string]any{mergeProxy("🇭🇰 HK", "hk.a.com")}, mergeGroup("默认代理", "🇭🇰 HK", "DIRECT")))
	second := write("b.json", mergeConfig([]map[string]any{mergeProxy("🇯🇵 JP", "jp.b.com")}, mergeGroup("默认代理", "🇯🇵 JP", "DIRECT")))
	output := filepath.Join(dir, "bundle.yaml")
	report, err := handleMergeProfiles(MergeProfilesParams{
		Output:  output,
		Members: []MergeMemberParams{{Prefix: "A", Path: first}, {Prefix: "B", Path: second}},
	})
	if err != nil {
		t.Fatal(err)
	}
	if report.Proxies != 2 || report.Groups != 1 {
		t.Fatalf("report = %+v", report)
	}
	data, err := os.ReadFile(output)
	if err != nil {
		t.Fatal(err)
	}
	text := string(data)
	if !strings.HasPrefix(text, "proxies:\n") || !strings.Contains(text, "  - name: \"[ A ] - 🇭🇰 HK\"\n    type: ss\n    server: hk.a.com\n    port: 443\n") {
		t.Fatalf("unexpected yaml:\n%s", text)
	}
	if _, err := config.Parse(data); err != nil {
		t.Fatal(err)
	}
	stamp := time.Now().Add(-time.Hour).Truncate(time.Second)
	if err := os.Chtimes(output, stamp, stamp); err != nil {
		t.Fatal(err)
	}
	if _, err := handleMergeProfiles(MergeProfilesParams{
		Output:  output,
		Members: []MergeMemberParams{{Prefix: "A", Path: first}, {Prefix: "B", Path: second}},
	}); err != nil {
		t.Fatal(err)
	}
	if info, err := os.Stat(output); err != nil || !info.ModTime().Equal(stamp) {
		t.Fatal("an unchanged merge result must not rewrite the profile")
	}
	if err := os.WriteFile(first, []byte(`{"proxies":[{"name":"bad","type":"ss"}]}`), 0o600); err != nil {
		t.Fatal(err)
	}
	if _, err := handleMergeProfiles(MergeProfilesParams{
		Output:  output,
		Members: []MergeMemberParams{{Prefix: "A", Path: first}},
	}); err == nil {
		t.Fatal("an invalid merge result must be rejected")
	}
	if kept, _ := os.ReadFile(output); string(kept) != text {
		t.Fatal("a rejected merge must keep the previous profile")
	}
	if _, err := handleMergeProfiles(MergeProfilesParams{Output: output}); err == nil {
		t.Fatal("expected an error without members")
	}
}
