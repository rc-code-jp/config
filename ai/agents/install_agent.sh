#!/bin/bash
# Sub Agents インストールスクリプト
# 使い方: bash install.sh <ai-type> <agent-name>
# ai-type: codex | claude | opencode

set -e

BASE_URL="https://raw.githubusercontent.com/rc-code-jp/config/main/ai/agents"

# 引数チェック
if [ $# -lt 2 ]; then
  echo "使い方: bash install.sh <ai-type> <agent-name>"
  echo ""
  echo "ai-type:"
  echo "  codex    - OpenAI Codex CLI"
  echo "  claude   - Claude Code (Anthropic)"
  echo "  opencode - OpenCode"
  echo ""
  echo "agent-name:"
  echo "  ios-expert - iOS開発エキスパート"
  echo ""
  echo "例:"
  echo "  bash install.sh opencode ios-expert"
  echo "  bash install.sh codex ios-expert"
  echo "  bash install.sh claude ios-expert"
  exit 1
fi

AI_TYPE="$1"
AGENT_NAME="$2"

# AIタイプに応じたディレクトリを設定
case "$AI_TYPE" in
  codex)
    INSTALL_DIR="./.codex/agents"
    ;;
  claude)
    INSTALL_DIR="./.claude/agents"
    ;;
  opencode)
    INSTALL_DIR="./.opencode/agents"
    ;;
  *)
    echo "エラー: 不明なAIタイプ '$AI_TYPE'"
    echo "利用可能なタイプ: codex, claude, opencode"
    exit 1
    ;;
esac

# ディレクトリ作成
mkdir -p "$INSTALL_DIR"

# ダウンロード
DOWNLOAD_URL="${BASE_URL}/${AGENT_NAME}.md"
DEST_FILE="${INSTALL_DIR}/${AGENT_NAME}.md"

echo "インストール中..."
echo "  AIタイプ: $AI_TYPE"
echo "  エージェント: $AGENT_NAME"
echo "  保存先: $DEST_FILE"

if curl -fL -o "$DEST_FILE" "$DOWNLOAD_URL"; then
  echo ""
  echo "✓ インストール完了: $DEST_FILE"
else
  echo ""
  echo "✗ エラー: ダウンロードに失敗しました"
  echo "  エージェント名を確認してください: $AGENT_NAME"
  exit 1
fi
