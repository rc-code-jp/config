# config

macOS の設定ファイルと開発ツールを管理するリポジトリです。

- dotfiles とアプリ設定は chezmoi で管理します。
- CLI ツールと Homebrew 管理は nix-darwin で管理します。
- `codex` CLI は nix-darwin の Homebrew 管理経由で扱います。
- Homebrew 本体は nix-darwin では導入しないため、初回のみ手動でインストールします。

## 構成

```text
.
├── .chezmoiroot
├── flake.nix
├── flake.lock
├── home/
│   ├── .chezmoitemplates/
│   ├── dot_claude/
│   ├── dot_codex/
│   ├── dot_config/
│   ├── dot_vimrc
│   ├── Library/
│   └── modify_dot_zshrc.tmpl
├── docs/
│   └── unmanaged-macos-settings.md
├── nix/
│   ├── darwin.nix
│   ├── homebrew.nix
│   ├── keyboard.nix
│   ├── packages.nix
│   └── system-defaults.nix
└── scripts/
    ├── apply-managed-configs.sh
    ├── bootstrap-local.sh
    └── github_setup.sh
```

`.chezmoiroot` により、chezmoi の source root は `home/` です。

## 初回セットアップ

次の前提を満たしていることを確認します。

- Nix がインストール済みで、`nix --version` が成功する
- GitHub SSH 接続が設定済みである

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

`eval` は初回セットアップを実行している現在のシェル用です。
永続的な Homebrew の `bin` / `sbin` は、後続の nix-darwin 設定で
`environment.systemPath` に追加します。

マシンごとのユーザー名・ホスト名・アーキテクチャは `local.nix` に切り出しています。`local.nix` は `.gitignore` 対象で、各 Mac で初回のみ生成します。

```bash
./scripts/bootstrap-local.sh
```

`id -un` / `scutil --get LocalHostName` / `uname -m` から自動的に値を取得し、`local.nix` を作成します。

Homebrew 本体と `local.nix` の準備ができたら、nix-darwin の設定を確認します。
`local.nix` は Git 管理外のため、Flake は `path:` 形式で評価します。

```bash
nix --extra-experimental-features "nix-command flakes" flake check "path:$PWD"
nix --extra-experimental-features "nix-command flakes" \
  run nix-darwin/master#darwin-rebuild -- \
  build --flake "path:$PWD#$(scutil --get LocalHostName)"
```

問題なければ反映します。

```bash
sudo -H nix --extra-experimental-features "nix-command flakes" \
  run nix-darwin/master#darwin-rebuild -- \
  switch --flake "path:$PWD#$(scutil --get LocalHostName)"
```

nix-darwin の反映後、chezmoi の全管理設定を反映します。
この順序により、chezmoi と Homebrew 管理の CLI を先に利用可能にしてから
dotfiles とアプリ設定を配置します。

```bash
chezmoi --source "$PWD" diff
./scripts/apply-managed-configs.sh
exec zsh -l
```

## 日常の更新

nix / Homebrew 管理のツールを更新します。

```bash
nix flake update
darwin-rebuild build --flake "path:$PWD#$(scutil --get LocalHostName)"
sudo -H darwin-rebuild switch --flake "path:$PWD#$(scutil --get LocalHostName)"
```

chezmoi の全管理設定を更新します。

```bash
chezmoi --source "$PWD" diff
./scripts/apply-managed-configs.sh
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
- `~/.zshrc` の `# chezmoi: zshrc begin` から `# chezmoi: zshrc end` まで

`~/.zshrc` は chezmoi の `modify_` により管理ブロックだけを差し替え、ブロック外のユーザー固有設定は残します。

### nix-darwin

- `chezmoi`
- `git`
- `jq`
- `mise`
- `fastlane`
- `cocoapods`

### macOS システム設定

`nix/system-defaults.nix` と `nix/keyboard.nix` で、`darwin-rebuild switch` 時に `defaults write` 相当を宣言的に流します。

- `system-defaults.nix`: Dock / Finder / メニューバー時計 / スクリーンショット / トラックパッド / `NSGlobalDomain` のキーリピート・拡張子表示など
- `keyboard.nix`: CapsLock → Ctrl の remap、`AppleSymbolicHotKeys` (Spotlight / Mission Control / 入力ソース切替など) と `NSUserKeyEquivalents` (アプリメニュー項目のキーバインド)
- `audio-input.nix`: `local.nix` の `enableSwitchAudio = true;` で、マイク入力を常に内蔵マイクへ固定する launchd agent を有効化します。デフォルトは無効です。

`AppleSymbolicHotKeys` は cfprefsd のキャッシュ都合で `darwin-rebuild switch` 直後に反映されない場合があります。反映状況は `defaults read com.apple.symbolichotkeys` で確認し、必要に応じてログアウト/再起動してください。

### Homebrew

nix-darwin の `homebrew` module で管理します。
Homebrew 本体だけは管理対象外のため、初回のみ手動でインストールします。

- `codex` (CLI)
- `ghostty`
- `visual-studio-code`
- `zed`

## 手動管理として残すもの

- `scripts/bootstrap-local.sh`: 各マシンのユーザー名 / ホスト名 / アーキテクチャから `local.nix` を生成します。`local.nix` は `.gitignore` 対象で、共有しません。
- `scripts/github_setup.sh`: 必要な場合だけ使う GitHub SSH 設定用の補助スクリプトです。
- `docs/unmanaged-macos-settings.md`: macOS の「システム設定」には存在するが、nix-darwin では無理に管理しない項目の記録です。
- `claude`: 設定ファイルのみ chezmoi で管理します。CLI 本体はこのリポジトリでは管理しません。
- Google Chrome / Brave / Codex デスクトップアプリ: このリポジトリでは管理せず、手動でインストールします。

## GitHub SSH 設定（任意）

```bash
bash scripts/github_setup.sh
```
