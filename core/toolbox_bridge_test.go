package core

import (
	"core/toolbox"
	"encoding/json"
	"testing"
)

func invokeToolboxTestRPC[R any](t *testing.T, method CoreMethod, args any) R {
	t.Helper()
	var rawArgs json.RawMessage
	if args != nil {
		data, err := json.Marshal(args)
		if err != nil {
			t.Fatal(err)
		}
		rawArgs = data
	}
	raw := handleMethodCall(&MethodCall{Method: method, Arguments: rawArgs})
	var env struct {
		Result R            `json:"result"`
		Error  *MethodError `json:"error"`
	}
	if err := json.Unmarshal(raw, &env); err != nil {
		t.Fatalf("%s decode failed: %v\nraw=%s", method, err, raw)
	}
	if env.Error != nil {
		t.Fatalf("%s returned error: %+v", method, env.Error)
	}
	return env.Result
}

func TestToolboxBridgeAgeAndCancelRPC(t *testing.T) {
	pair := invokeToolboxTestRPC[toolbox.AgeKeyPair](t, toolboxAgeKeygenMethod, toolbox.AgeKeygenParams{Hybrid: false})
	if pair.PublicKey == "" || pair.SecretKey == "" {
		t.Fatalf("empty key pair: %+v", pair)
	}

	encrypted := invokeToolboxTestRPC[toolbox.AgeCryptResult](t, toolboxAgeCryptMethod, toolbox.AgeCryptParams{
		Mode: "encrypt",
		Data: "flclash-toolbox",
		Keys: []string{pair.PublicKey},
	})
	if encrypted.Error != "" || encrypted.Data == "" {
		t.Fatalf("encrypt failed: %+v", encrypted)
	}

	decrypted := invokeToolboxTestRPC[toolbox.AgeCryptResult](t, toolboxAgeCryptMethod, toolbox.AgeCryptParams{
		Mode: "decrypt",
		Data: encrypted.Data,
		Keys: []string{pair.SecretKey},
	})
	if decrypted.Error != "" || decrypted.Data != "flclash-toolbox" {
		t.Fatalf("decrypt failed: %+v", decrypted)
	}

	trace := invokeToolboxTestRPC[toolbox.RouteTraceResult](t, toolboxRouteTraceMethod, toolbox.RouteTraceParams{
		Target: "example.com",
	})
	if trace.Error != "stopped" {
		t.Fatalf("expected stopped route trace when idle, got %+v", trace)
	}

	dnsRes := invokeToolboxTestRPC[toolbox.DnsQueryResult](t, toolboxDnsQueryMethod, toolbox.DnsQueryParams{
		Domain: "example.com",
		Mode:   "follow",
	})
	if dnsRes.Error != "stopped" {
		t.Fatalf("expected stopped dns query when idle, got %+v", dnsRes)
	}

	for _, cancelMethod := range []CoreMethod{
		toolboxSpeedTestCancelMethod,
		toolboxStunCancelMethod,
		toolboxPingCancelMethod,
		toolboxMrsCancelMethod,
	} {
		if ok := invokeToolboxTestRPC[bool](t, cancelMethod, nil); !ok {
			t.Fatalf("%s returned false", cancelMethod)
		}
	}
}
