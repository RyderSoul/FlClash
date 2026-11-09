package core

import (
	"sync"
	"testing"

	C "github.com/metacubex/mihomo/constant"
	"github.com/metacubex/mihomo/tunnel/statistic"
)

type nodeTrafficTracker struct {
	statistic.Tracker
	id   string
	info statistic.TrackerInfo
}

func (t *nodeTrafficTracker) ID() string                   { return t.id }
func (t *nodeTrafficTracker) Info() *statistic.TrackerInfo { return &t.info }

func nodeTracker(id, node, provider string, up, down int64) *nodeTrafficTracker {
	tracker := &nodeTrafficTracker{id: id, info: statistic.TrackerInfo{
		Chain: C.Chain{node, "Smart group"}, ProviderChain: C.Chain{provider},
	}}
	tracker.info.UploadTotal.Store(up)
	tracker.info.DownloadTotal.Store(down)
	return tracker
}

func TestNodeTrafficSurvivesDroppedReportsAndClosedConnections(t *testing.T) {
	w := requestTrafficWatch{requests: map[string]*watchedRequest{}}
	a := nodeTracker("a", "Tokyo", "subscription", 4, 8)
	b := nodeTracker("b", "Tokyo", "subscription", 2, 5)
	w.add(a)
	w.add(b)
	w.collect(func(string) bool { return true }, func([]RequestTraffic) bool { return false })
	a.info.UploadTotal.Add(6)
	b.info.DownloadTotal.Add(5)
	w.collect(func(string) bool { return false }, func([]RequestTraffic) bool { return false })
	w.collect(func(string) bool { return false }, func([]RequestTraffic) bool { return true })
	for range 2 {
		got := w.nodeTraffic()
		if len(got) != 1 || got[0].Name != "Tokyo" || got[0].Provider != "subscription" || got[0].Up != 12 || got[0].Down != 18 {
			t.Fatalf("accounted twice or lost closed traffic: %+v", got)
		}
	}
	if len(w.requests) != 0 {
		t.Fatal("closed trackers retained")
	}
}

func TestNodeTrafficSeparatesProvidersAndSortsByTotal(t *testing.T) {
	w := requestTrafficWatch{requests: map[string]*watchedRequest{}}
	w.add(nodeTracker("a", "Tokyo", "one", 5, 10))
	w.add(nodeTracker("b", "Tokyo", "two", 5, 20))
	w.add(nodeTracker("c", "Berlin", "one", 0, 0))
	got := w.nodeTraffic()
	if len(got) != 2 || got[0].Provider != "two" || got[1].Provider != "one" {
		t.Fatalf("ranking: %+v", got)
	}
}

func TestNodeTrafficResetKeepsOnlyNewBytesOfOpenConnections(t *testing.T) {
	w := requestTrafficWatch{requests: map[string]*watchedRequest{}}
	a := nodeTracker("a", "Tokyo", "one", 12, 30)
	w.add(a)
	w.resetNodeTraffic()
	if len(w.nodeTraffic()) != 0 {
		t.Fatal("old session still visible")
	}
	a.info.UploadTotal.Add(3)
	a.info.DownloadTotal.Add(7)
	got := w.nodeTraffic()
	if len(got) != 1 || got[0].Up != 3 || got[0].Down != 7 {
		t.Fatalf("reset rebased incorrectly: %+v", got)
	}
}

func TestNodeTrafficExcludesDirectRoutes(t *testing.T) {
	previous := statistic.IsDirect
	statistic.IsDirect = func(name string) bool { return name == "local" }
	defer func() { statistic.IsDirect = previous }()
	w := requestTrafficWatch{requests: map[string]*watchedRequest{}}
	w.add(nodeTracker("a", "local", "", 10, 20))
	w.add(nodeTracker("b", "", "", 10, 20))
	if got := w.nodeTraffic(); len(got) != 0 {
		t.Fatalf("direct traffic counted: %+v", got)
	}
}

func TestNodeTrafficConcurrentSnapshotsAndCollection(t *testing.T) {
	w := requestTrafficWatch{requests: map[string]*watchedRequest{}}
	a := nodeTracker("a", "Tokyo", "one", 0, 0)
	w.add(a)
	var workers sync.WaitGroup
	for range 3 {
		workers.Go(func() {
			for range 100 {
				a.info.UploadTotal.Add(1)
				w.nodeTraffic()
				w.collect(func(string) bool { return true }, func([]RequestTraffic) bool { return true })
			}
		})
	}
	workers.Wait()
	if got := w.nodeTraffic(); len(got) != 1 || got[0].Up != 300 {
		t.Fatalf("concurrent accounting: %+v", got)
	}
}
