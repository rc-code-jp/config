#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if command -v chezmoi >/dev/null 2>&1; then
  CHEZMOI_BIN="$(command -v chezmoi)"
elif [[ -x /run/current-system/sw/bin/chezmoi ]]; then
  CHEZMOI_BIN="/run/current-system/sw/bin/chezmoi"
else
  echo "エラー: chezmoi が見つかりません。先に darwin-rebuild switch を実行してください。" >&2
  exit 1
fi

"$CHEZMOI_BIN" --source "$PWD" apply

echo "chezmoi の全管理設定を反映しました。"
