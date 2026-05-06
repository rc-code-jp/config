# config

macOS の設定ファイルと開発ツールを管理するリポジトリです。

- dotfiles とアプリ設定は chezmoi で管理します。
- CLI ツールと Homebrew 管理は nix-darwin で管理します。
- `codex` CLI と GUI アプリは nix-darwin の Homebrew 管理経由で扱います。
- `pocoshelf` と `pocogit` は各リポジトリの nix flake package から導入します。
- Homebrew 本体は nix-darwin では導入しないため、初回のみ手動でインストールします。

## 構成

```text
.
├── .chezmoiroot
├── flake.nix
├── flake.lock
├── home/
│   ├── .chezmoitemplates/
│   ├── bin/
│   ├── dot_claude/
│   ├── dot_codex/
│   ├── dot_config/
│   ├── dot_vimrc
│   ├── Library/
│   └── run_onchange_update-zshrc.sh.tmpl
├── nix/
│   ├── darwin.nix
│   ├── homebrew.nix
│   └── packages.nix
└── scripts/
    └── github_setup.sh
```

`.chezmoiroot` により、chezmoi の source root は `home/` です。

## 初回セットアップ

このリポジトリを任意の場所に clone します。

```bash
git clone git@github.com:rc-code-jp/config.git ~/work/config
cd ~/work/config
```

Homebrew 本体が未導入の場合は、初回のみ手動でインストールします。

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew --version
```

Homebrew 本体の導入後、nix-darwin の設定を確認します。

```bash
nix flake check
darwin-rebuild build --flake .#macbook-pro
```

問題なければ反映します。

```bash
darwin-rebuild switch --flake .#macbook-pro
```

chezmoi の差分を確認します。

```bash
nix run nixpkgs#chezmoi -- --source "$PWD" diff
```

問題なければ反映します。

```bash
nix run nixpkgs#chezmoi -- --source "$PWD" apply
```

`darwin-rebuild switch` 後は `chezmoi` が system package として入るため、以後は次のように実行できます。

```bash
chezmoi --source "$PWD" diff
chezmoi --source "$PWD" apply
```

## 日常の更新

nix / Homebrew 管理のツールを更新します。

```bash
nix flake update
darwin-rebuild build --flake .#macbook-pro
darwin-rebuild switch --flake .#macbook-pro
```

dotfiles を更新します。

```bash
chezmoi --source "$PWD" diff
chezmoi --source "$PWD" apply
```

## 管理対象

### chezmoi

- `~/.codex/config.toml`
- `~/.codex/AGENTS.md`
- `~/.claude/settings.json`
- `~/.claude/statusline-command.sh`
- `~/.config/mise/config.toml`
- `~/.config/zed/settings.json`
- `~/.vimrc`
- `~/Library/Application Support/Code/User/settings.json`
- `~/Library/Application Support/com.mitchellh.ghostty/config`
- `~/bin/go_panel_right`
- `~/bin/sw`
- `~/bin/sww`
- `~/bin/ew`
- `~/.zshrc` の `# Config-Start` から `# Config-End` まで

`~/.zshrc` はファイル全体を管理しません。`run_onchange_update-zshrc.sh.tmpl` が管理ブロックだけを差し替え、ブロック外のユーザー固有設定は残します。

### nix-darwin

- `chezmoi`
- `git`
- `jq`
- `mise`
- `fastlane`
- `cocoapods`
- `opencode`
- `pocoshelf`
- `pocogit`

### Homebrew

nix-darwin の `homebrew` module で管理します。
Homebrew 本体だけは管理対象外のため、初回のみ手動でインストールします。

- `codex`
- `brave-browser`
- `ghostty`
- `google-chrome`
- `visual-studio-code`
- `zed`

## 手動管理として残すもの

- `scripts/github_setup.sh`: GitHub SSH 初期設定用です。秘密鍵は nix / chezmoi で管理せず、初回のみ手動実行します。
- `claude`: 設定ファイルのみ chezmoi で管理します。CLI 本体はこのリポジトリでは管理しません。
- `termcat`: `~/bin/sww` から呼び出される任意ツールです。現時点では nixpkgs に存在せず、`rc-code-jp/termcat` に flake もないため、このリポジトリでは管理しません。

## GitHub SSH 初期設定

必要な場合だけ、初回に一度実行します。

```bash
bash scripts/github_setup.sh
```

このスクリプトは `~/.ssh` の作成、GitHub 用 SSH 鍵の生成、ssh-agent / macOS Keychain への登録、公開鍵の表示を行います。
