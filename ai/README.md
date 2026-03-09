# AI関連

## AGENTS.md

```bash
mkdir -p .agents
touch .agents/,gitkeep

curl -L -o AGENTS.md \
  https://raw.githubusercontent.com/rc-code-jp/config/main/ai/AGENTS.md

ln -s AGENTS.md CLAUDE.md
ln -s .agents .claude
```

## codex

### Global config

```bash
curl -L -o ~/.codex/config.toml \
  https://raw.githubusercontent.com/rc-code-jp/config/main/ai/codex/config.toml
```

## opencode

### Global config

```bash
curl -L -o ~/.config/opencode/opencode.json \
  https://raw.githubusercontent.com/rc-code-jp/config/main/ai/opencode/_opencode.json
```

## codex

## Local gitignroe

```bash
curl -L -o .codex/.gitignore \
  https://raw.githubusercontent.com/rc-code-jp/config/main/ai/codex.gitignore
```
