package core

import (
	"encoding/json"
	"os"
	"reflect"
	"testing"

	"github.com/metacubex/mihomo/adapter/outboundgroup"
	"github.com/metacubex/mihomo/config"
	"github.com/metacubex/mihomo/constant"
)

func TestCompiledProfileBindings(t *testing.T) {
	path := os.Getenv("FLSMART_BINDING_FIXTURE")
	if path == "" {
		t.Skip("run after the Flutter binding fixture export")
	}
	data, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	var fixture struct {
		Config json.RawMessage
		Groups map[string][]string
	}
	if err := json.Unmarshal(data, &fixture); err != nil {
		t.Fatal(err)
	}
	previous := constant.Path.HomeDir()
	constant.SetHomeDir(t.TempDir())
	t.Cleanup(func() { constant.SetHomeDir(previous) })
	parsed, err := config.Parse(fixture.Config)
	if err != nil {
		t.Fatal(err)
	}
	for _, pd := range parsed.Providers {
		if closer, ok := pd.(interface{ Close() error }); ok {
			t.Cleanup(func() { _ = closer.Close() })
		}
	}
	for name, want := range fixture.Groups {
		t.Run(name, func(t *testing.T) {
			proxy, exists := parsed.Proxies[name]
			if !exists {
				t.Fatalf("missing group %s", name)
			}
			group, ok := proxy.Adapter().(outboundgroup.ProxyGroup)
			if !ok {
				t.Fatalf("%s is not a group", name)
			}
			var got []string
			for _, member := range group.Proxies() {
				got = append(got, member.Name())
			}
			if !reflect.DeepEqual(got, want) {
				t.Fatalf("members = %v, want %v", got, want)
			}
		})
	}
}
