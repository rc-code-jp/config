# AI設定ファイル

このディレクトリには、AIツール向けの設定ファイルを配置しています。

## フォルダ構成

- `codex/config.toml`: Codex のグローバル設定ファイル
- `codex.gitignore`: Codex のローカル `.codex/.gitignore` 用テンプレート

## Codex

### グローバル設定

```bash
curl -L -o ~/.codex/config.toml \
  https://raw.githubusercontent.com/rc-code-jp/ai-ops/main/config/codex/config.toml
```

## Claude

### グローバル設定

```bash
mkdir -p ~/.claude
curl -L -o ~/.claude/settings.json \
  https://raw.githubusercontent.com/rc-code-jp/ai-ops/main/config/claude/_settings.json
```
