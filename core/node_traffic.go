package core

import (
	"sort"

	"github.com/metacubex/mihomo/tunnel/statistic"
)

type nodeTrafficKey struct {
	name     string
	provider string
}

type NodeTraffic struct {
	Name     string `json:"name"`
	Provider string `json:"provider"`
	Up       int64  `json:"up"`
	Down     int64  `json:"down"`
}

func trafficNode(info *statistic.TrackerInfo) nodeTrafficKey {
	name := info.Chain.Last()
	if name == "" || statistic.IsDirect(name) {
		return nodeTrafficKey{}
	}
	return nodeTrafficKey{name: name, provider: info.ProviderChain.Last()}
}

// Delivery can retry or stop with the Flutter engine; accounting never depends on it.
func (w *requestTrafficWatch) accountNode(request *watchedRequest) {
	if request.node.name == "" {
		return
	}
	info := request.tracker.Info()
	up, down := info.UploadTotal.Load(), info.DownloadTotal.Load()
	if w.nodes == nil {
		w.nodes = make(map[nodeTrafficKey]Traffic)
	}
	total := w.nodes[request.node]
	total.Up += max(0, up-request.accountedUp)
	total.Down += max(0, down-request.accountedDown)
	w.nodes[request.node] = total
	request.accountedUp, request.accountedDown = up, down
}

func (w *requestTrafficWatch) nodeTraffic() []NodeTraffic {
	w.mu.Lock()
	for _, request := range w.requests {
		w.accountNode(request)
	}
	result := make([]NodeTraffic, 0, len(w.nodes))
	for node, total := range w.nodes {
		if total.Up+total.Down > 0 {
			result = append(result, NodeTraffic{
				Name: node.name, Provider: node.provider, Up: total.Up, Down: total.Down,
			})
		}
	}
	w.mu.Unlock()
	sort.Slice(result, func(i, j int) bool {
		a, b := result[i], result[j]
		if a.Up+a.Down != b.Up+b.Down {
			return a.Up+a.Down > b.Up+b.Down
		}
		if a.Name != b.Name {
			return a.Name < b.Name
		}
		return a.Provider < b.Provider
	})
	return result
}

func (w *requestTrafficWatch) resetNodeTraffic() {
	w.mu.Lock()
	defer w.mu.Unlock()
	clear(w.nodes)
	for _, request := range w.requests {
		info := request.tracker.Info()
		request.accountedUp = info.UploadTotal.Load()
		request.accountedDown = info.DownloadTotal.Load()
	}
}

func handleGetNodeTraffic() []NodeTraffic {
	return currentRequestTraffic.nodeTraffic()
}
