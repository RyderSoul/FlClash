#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
core="$root/core"
revision=024245dc72bc92f48237f865119afe0cd53ac9e6
patch="$core/patches/smart.patch"
fingerprint="$(shasum -a 256 "$patch" | cut -d ' ' -f 1)"
destination="$core/.smart-mihomo"

if [[ "$(git -C "$core/Clash.Meta" rev-parse HEAD)" != "$revision" ]]; then
  echo 'The FlClash core changed; rebase the full Alpha integration before building.' >&2
  exit 1
fi
if [[ -f "$destination/.smart-fingerprint" ]] &&
    [[ "$(cat "$destination/.smart-fingerprint")" == "$fingerprint" ]]; then
  exit 0
fi

stage="$(mktemp -d "$core/.smart-mihomo.XXXXXX")"
trap 'rm -rf "$stage"' EXIT
git -C "$core/Clash.Meta" archive "$revision" | tar -xf - -C "$stage"
git -C "$stage" init -q
git -C "$stage" apply --check "$patch"
git -C "$stage" apply "$patch"
printf '%s\n' "$fingerprint" > "$stage/.smart-fingerprint"
rm -rf "$destination"
mv "$stage" "$destination"
echo 'Prepared the complete pinned Alpha core with FlClash platform patches.'
