package toolbox

import (
	"encoding/json"
	"errors"
	"strings"

	"github.com/metacubex/mihomo/component/age"
)

var errAgeNotEncrypted = errors.New("not age encrypted")

type AgeKeygenParams struct {
	Hybrid bool `json:"hybrid"`
}

type AgeKeyPair struct {
	PublicKey string `json:"public-key"`
	SecretKey string `json:"secret-key"`
}

type AgeCryptParams struct {
	Mode string   `json:"mode"`
	Data string   `json:"data"`
	Keys []string `json:"keys"`
}

type AgeCryptResult struct {
	Data  string `json:"data"`
	Error string `json:"error"`
}

func GenerateAgeKeyPair(params AgeKeygenParams) (*AgeKeyPair, error) {
	ageLock().Lock()
	defer ageLock().Unlock()
	var (
		secret string
		public string
		err    error
	)
	if params.Hybrid {
		secret, public, err = age.GenHybridKeyPair()
	} else {
		secret, public, err = age.GenX25519KeyPair()
	}
	if err != nil {
		return nil, err
	}
	return &AgeKeyPair{PublicKey: public, SecretKey: secret}, nil
}

func CryptAge(params AgeCryptParams) AgeCryptResult {
	keys := make([]string, 0, len(params.Keys))
	for _, key := range params.Keys {
		if key = strings.TrimSpace(key); key != "" {
			keys = append(keys, key)
		}
	}
	result := AgeCryptResult{}
	var (
		data []byte
		err  error
	)
	if params.Mode == "encrypt" {
		data, err = age.EncryptBytes([]byte(params.Data), keys...)
	} else if !strings.HasPrefix(strings.TrimSpace(params.Data), age.FileHeader) {
		err = errAgeNotEncrypted
	} else {
		ageLock().Lock()
		data, err = age.DecryptBytes([]byte(strings.TrimSpace(params.Data)), keys...)
		ageLock().Unlock()
	}
	if err != nil {
		result.Error = err.Error()
	} else {
		result.Data = string(data)
	}
	if len(params.Data) > 1<<20 {
		releaseToolMemory()
	}
	return result
}

func HandleAgeCrypt(paramsString string) string {
	params := AgeCryptParams{}
	_ = json.Unmarshal([]byte(paramsString), &params)
	encoded, _ := json.Marshal(CryptAge(params))
	return string(encoded)
}
