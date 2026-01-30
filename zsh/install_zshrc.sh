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

# AIツール選択関数
select_ai_tool() {
  # 環境変数 AI_TOOL が設定されていればそれを使用
  if [ -n "${AI_TOOL:-}" ]; then
    case "${AI_TOOL}" in
      claudecode|codex|opencode|none)
        SELECTED_AI_TOOL="${AI_TOOL}"
        echo "AIツール (環境変数から): ${SELECTED_AI_TOOL}"
        return 0
        ;;
      *)
        echo "Error: AI_TOOL の値が無効です: ${AI_TOOL}" >&2
        echo "有効な値: claudecode, codex, opencode, none" >&2
        exit 1
        ;;
    esac
  fi

  # /dev/tty が利用可能か確認
  if [ ! -e /dev/tty ]; then
    echo "Error: インタラクティブ選択ができません。" >&2
    echo "環境変数 AI_TOOL を設定してください。" >&2
    echo "例: AI_TOOL=opencode curl -fsSL ... | bash" >&2
    echo "有効な値: claudecode, codex, opencode, none" >&2
    exit 1
  fi

  echo ""
  echo "AIツールを選択してください:"
  echo "  1) claudecode"
  echo "  2) codex"
  echo "  3) opencode"
  echo "  4) none"
  
  while true; do
    printf "#? "
    read -r choice < /dev/tty
    case "${choice}" in
      1)
        SELECTED_AI_TOOL="claudecode"
        break
        ;;
      2)
        SELECTED_AI_TOOL="codex"
        break
        ;;
      3)
        SELECTED_AI_TOOL="opencode"
        break
        ;;
      4)
        SELECTED_AI_TOOL="none"
        break
        ;;
      *)
        echo "無効な選択です。1-4の番号を入力してください。"
        ;;
    esac
  done
  echo "選択: ${SELECTED_AI_TOOL}"
}

# 選択されたAIツール以外のブロックを除去する関数
filter_ai_blocks() {
  local input_file="$1"
  local selected="$2"
  local tmp_filtered
  tmp_filtered="$(mktemp)"

  if [ "${selected}" = "none" ]; then
    # none選択時は全AIブロックを除去
    awk '
      /^# AI-claudecode-Start/ { skip=1; next }
      /^# AI-claudecode-End/   { skip=0; next }
      /^# AI-codex-Start/      { skip=1; next }
      /^# AI-codex-End/        { skip=0; next }
      /^# AI-opencode-Start/   { skip=1; next }
      /^# AI-opencode-End/     { skip=0; next }
      !skip { print }
    ' "${input_file}" > "${tmp_filtered}"
  else
    # 選択されたツール以外のブロックを除去（マーカーも除去）
    awk -v selected="${selected}" '
      /^# AI-claudecode-Start/ { if (selected != "claudecode") skip=1; next }
      /^# AI-claudecode-End/   { skip=0; next }
      /^# AI-codex-Start/      { if (selected != "codex") skip=1; next }
      /^# AI-codex-End/        { skip=0; next }
      /^# AI-opencode-Start/   { if (selected != "opencode") skip=1; next }
      /^# AI-opencode-End/     { skip=0; next }
      !skip { print }
    ' "${input_file}" > "${tmp_filtered}"
  fi

  mv "${tmp_filtered}" "${input_file}"
}

# AIツール選択
select_ai_tool

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

# 選択されたAIツールに応じてフィルタリング
filter_ai_blocks "${tmp_template}" "${SELECTED_AI_TOOL}"

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

# 推奨アクション
echo "Reload config: source ~/.zshrc"

# 更新内容を確認する
echo "Check the file: open ~/.zshrc"
