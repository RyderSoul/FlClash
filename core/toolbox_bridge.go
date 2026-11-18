package core

import (
	"core/toolbox"

	"github.com/metacubex/mihomo/config"
)

func init() {
	toolbox.Setup(toolbox.Host{
		Notify: func(kind string, data any) {
			sendMessage(MessageType(kind), data)
		},
		State:   toolboxState,
		AgeLock: &ageMu,
	})
}

func toolboxState() (bool, *config.Config, *config.RawConfig) {
	configMu.Lock()
	cfg := currentConfig
	raw := currentRawConfig
	configMu.Unlock()
	return isRunning.Load(), cfg, raw
}

func handleToolboxMrsDump(params toolbox.MrsDumpParams) (string, error) {
	return toolbox.DumpMrsFile(params.File)
}
