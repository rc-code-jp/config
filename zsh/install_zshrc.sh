#!/usr/bin/env bash
set -euo pipefail

# GitHubのRawファイルURL
TEMPLATE_URL="https://raw.githubusercontent.com/rc-code-jp/config/main/zsh/zshrc.sh"

# キャッシュ回避
if [ -n "${CACHE_BUST:-}" ]; then
  TEMPLATE_URL="${TEMPLATE_URL}?t=$(date +%s)"
fi

zshrc_path="${HOME}/.zshrc"
start_marker='^# Config-Start'
end_marker='^# Config-End'

tmp_template="$(mktemp)"
tmp_out=""

cleanup() {
  if [ -n "${tmp_out}" ]; then
    rm -f "${tmp_out}"
  fi
  rm -f "${tmp_template}"
}
trap cleanup EXIT

# スクリプトがローカルで実行されているか、curlパイプで実行されているかを判定
# ${BASH_SOURCE[0]:-} uses parameter expansion to handle unbound variable when using set -u
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]:-}" ]; then
  # ローカル実行
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  template_source="${script_dir}/zshrc.sh"
  
  if [ -f "${template_source}" ]; then
    echo "Using local template: ${template_source}"
    awk -v start="${start_marker}" -v end="${end_marker}" '
      $0 ~ start { in_block = 1 }
      in_block { print }
      $0 ~ end { in_block = 0 }
    ' "${template_source}" > "${tmp_template}"
  else
    echo "Error: Local template not found: ${template_source}" >&2
    exit 1
  fi
else
  # curlパイプ実行（リモート）
  echo "Downloading template from ${TEMPLATE_URL}..."
  if command -v curl &> /dev/null; then
    curl -fsSL "${TEMPLATE_URL}" -o "${tmp_template}"
  elif command -v wget &> /dev/null; then
    wget -q -O "${tmp_template}" "${TEMPLATE_URL}"
  else
    echo "Error: curl or wget is required to download the template" >&2
    exit 1
  fi
  
  # ダウンロードしたファイルから Config-Start と Config-End の間を抽出
  tmp_extracted="$(mktemp)"
  awk -v start="${start_marker}" -v end="${end_marker}" '
    $0 ~ start { in_block = 1 }
    in_block { print }
    $0 ~ end { in_block = 0 }
  ' "${tmp_template}" > "${tmp_extracted}"
  mv "${tmp_extracted}" "${tmp_template}"
fi

if [ ! -s "${tmp_template}" ]; then
  echo "Template block not found" >&2
  exit 1
fi

if [ ! -f "${zshrc_path}" ]; then
  cat "${tmp_template}" > "${zshrc_path}"
  echo "Created ${zshrc_path} with template block."
  exit 0
fi

if grep -qE "${start_marker}" "${zshrc_path}" && grep -qE "${end_marker}" "${zshrc_path}"; then
  tmp_out="$(mktemp)"
  awk -v start="${start_marker}" -v end="${end_marker}" -v tpl="${tmp_template}" '
    BEGIN {
      while ((getline line < tpl) > 0) {
        template = template line ORS
      }
      close(tpl)
    }
    $0 ~ start {
      printf "%s", template
      in_block = 1
      next
    }
    in_block {
      if ($0 ~ end) {
        in_block = 0
      }
      next
    }
    { print }
  ' "${zshrc_path}" > "${tmp_out}"
  mv "${tmp_out}" "${zshrc_path}"
  echo "Replaced Config block in ${zshrc_path}."
else
  if [ -s "${zshrc_path}" ]; then
    if [ "$(tail -c 1 "${zshrc_path}")" != $'\n' ]; then
      printf '\n' >> "${zshrc_path}"
    fi
    printf '\n' >> "${zshrc_path}"
  fi
  cat "${tmp_template}" >> "${zshrc_path}"
  echo "Appended template block to ${zshrc_path}."
fi

echo "Run: source ~/.zshrc"
