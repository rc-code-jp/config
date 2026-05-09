#!/usr/bin/env bash
set -euo pipefail

# Bootstrap helper: per-host local.nix を生成する。
# - flake.nix が参照する username / hostname / system を実機から取得
# - local.nix は .gitignore 対象なので、各 Mac で初回のみ実行する

cd "$(dirname "$0")/.."

OUT="local.nix"

USERNAME="$(id -un)"
HOSTNAME_LOCAL="$(scutil --get LocalHostName)"
ARCH="$(uname -m)"
case "$ARCH" in
  arm64)  SYSTEM="aarch64-darwin" ;;
  x86_64) SYSTEM="x86_64-darwin" ;;
  *)
    echo "[bootstrap-local] unknown arch: $ARCH" >&2
    exit 1
    ;;
esac

if [[ -f "$OUT" ]]; then
  echo "[bootstrap-local] $OUT は既に存在します。上書きしますか? [y/N]"
  read -r answer
  case "$answer" in
    [yY]|[yY][eE][sS]) ;;
    *)
      echo "[bootstrap-local] 中止しました。"
      exit 0
      ;;
  esac
fi

cat > "$OUT" <<EOF
{
  username = "${USERNAME}";
  hostname = "${HOSTNAME_LOCAL}";
  system   = "${SYSTEM}";
}
EOF

echo "[bootstrap-local] $OUT を生成しました:"
cat "$OUT"
echo
echo "次に実行:"
echo "  darwin-rebuild switch --flake .#${HOSTNAME_LOCAL}"
