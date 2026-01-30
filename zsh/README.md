# Zsh Config Installer

`zsh/install_zshrc.sh` updates `~/.zshrc` using the template block in
`zsh/zshrc.sh`.

## Behavior

- If `~/.zshrc` does not exist, it is created from the template block.
- If `# Config-Start` and `# Config-End` exist, the block is replaced.
- If the block is missing, it is appended to the end of `~/.zshrc`.

## Usage

### リモートインストール（リポジトリのクローン不要）

```bash
curl -fsSL https://raw.githubusercontent.com/rc-code-jp/config/main/zsh/install_zshrc.sh | bash
```

インストール時にAIツール（claudecode / codex / opencode / none）を選択するメニューが表示されます。

### AIツールを引数で指定

```bash
# 引数で指定
curl -fsSL https://raw.githubusercontent.com/rc-code-jp/config/main/zsh/install_zshrc.sh | bash -s -- opencode

# プロセス置換
bash <(curl -fsSL https://raw.githubusercontent.com/rc-code-jp/config/main/zsh/install_zshrc.sh) opencode
```

### AIツールを環境変数で指定

```bash
curl -fsSL https://raw.githubusercontent.com/rc-code-jp/config/main/zsh/install_zshrc.sh | AI_TOOL=opencode bash
```

### 有効なAIツール値

| 値 | 説明 |
|---|---|
| `claudecode` | Claude Code (`C="claude"`, `CC="claude --resume"`) |
| `codex` | Codex CLI (`C="codex"`, `CC="codex resume"`) |
| `opencode` | OpenCode (`C="opencode"`, `CC="opencode_resume"` + 関数) |
| `none` | AIエイリアスなし |

## 便利なプラグイン

gitコマンドを置換してくれる

https://github.com/zimfw/zimfw
