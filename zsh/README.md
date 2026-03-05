# Zsh Config Installer

`zsh/install_zshrc.sh` updates `~/.zshrc` using the template block in
`zsh/zshrc.sh`.

## Behavior

- If `~/.zshrc` does not exist, it is created from the template block.
- If `# Config-Start` and `# Config-End` exist, the block is replaced.
- If the block is missing, it is appended to the end of `~/.zshrc`.

## Usage

```bash
curl -fsSL https://raw.githubusercontent.com/rc-code-jp/config/main/zsh/install_zshrc.sh | bash
source ~/.zshrc
```

インストール時にAIツール（claudecode / codex / opencode / none）を選択するメニューが表示されます。

### 有効なAIツール

| 値 | 説明 |
|---|---|
| `claudecode` | Claude Code (`C="claude"`, `CC="claude --resume"`) |
| `codex` | Codex CLI (`C="codex"`, `CC="codex resume"`) |
| `opencode` | OpenCode (`C="opencode"`, `CC="opencode_resume"` + 関数) |
| `none` | AIエイリアスなし |

## GitHub SSH Setup

`zsh/github_setup.sh` は、Mac から GitHub に SSH 接続する初期設定をまとめて行います。

### できること

- `~/.ssh` の作成と権限設定
- `id_ed25519_github` 鍵の生成（既存なら再利用）
- `~/.ssh/config` の `Host github.com` 設定を追記/更新
- 鍵を `ssh-agent` と macOS Keychain に追加
- GitHub に手動登録するため、公開鍵を表示

### 使い方

```bash
bash zsh/github_setup.sh
```

鍵名を変更したい場合:

```bash
bash zsh/github_setup.sh id_ed25519_github_work
```

ローカルに clone していない環境では、GitHub Raw から直接実行できます:

```bash
curl -fsSL https://raw.githubusercontent.com/rc-code-jp/config/main/zsh/github_setup.sh | bash
```

内容を確認してから実行したい場合:

```bash
curl -fsSL -o /tmp/github_setup.sh https://raw.githubusercontent.com/rc-code-jp/config/main/zsh/github_setup.sh
less /tmp/github_setup.sh
bash /tmp/github_setup.sh
```

### GitHub 側での手動作業

1. GitHub > Settings > SSH and GPG keys > New SSH key
2. スクリプトが表示した公開鍵を貼り付けて保存
3. 接続確認: `ssh -T git@github.com`
