# Sub Agents

AIエージェント用のサブエージェント設定ファイルです。

## 利用可能なエージェント

| エージェント名 | 説明 |
|---------------|------|
| ios-expert | iOS開発エキスパート |

## インストール

```bash
# 使い方: bash <(curl -sL URL) <ai-type> <agent-name>
# ai-type: codex | claude | opencode

# 例: OpenCodeにios-expertをインストール
bash <(curl -sL https://raw.githubusercontent.com/rc-code-jp/config/main/ai/agents/install_agent.sh) opencode ios-expert

# 例: Codexにios-expertをインストール
bash <(curl -sL https://raw.githubusercontent.com/rc-code-jp/config/main/ai/agents/install_agent.sh) codex ios-expert

# 例: Claude Codeにios-expertをインストール
bash <(curl -sL https://raw.githubusercontent.com/rc-code-jp/config/main/ai/agents/install_agent.sh) claude ios-expert
```

## インストール先ディレクトリ

| AIタイプ | ディレクトリ |
|---------|-------------|
| codex | `.codex/agents/` |
| claude | `.claude/agents/` |
| opencode | `.opencode/agents/` |

※ ディレクトリが存在しない場合は自動的に作成されます。
