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
│   ├── dot_gemini/
│   ├── dot_vimrc
│   ├── Library/
│   ├── modify_dot_gitconfig
│   └── modify_dot_zshrc.tmpl
├── nix/
│   ├── audio-input.nix
│   ├── darwin.nix
│   ├── file-associations.nix
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
nix flake update --flake "path:$PWD"
darwin-rebuild build --flake "path:$PWD#$(scutil --get LocalHostName)"
sudo -H darwin-rebuild switch --flake "path:$PWD#$(scutil --get LocalHostName)"
```

chezmoi の全管理設定を更新します。

```bash
chezmoi --source "$PWD" diff
./scripts/apply-managed-configs.sh
```

mise 管理のランタイムは、設定の反映とは別にインストール・更新します。
Node.js は 24 系、Python は 3.12.14、Flutter は 3.47 系を使用します。

```bash
mise install
mise upgrade node
```

Flutter は公式アーカイブから取得します。実機で追加した取得設定も
`home/dot_config/mise/config.toml` に含め、再反映時に失われないようにしています。

## 管理対象

### chezmoi

- `~/.codex/config.toml`
- `~/.codex/AGENTS.md`
- `~/.codex/rules/default.rules`
- `~/.claude/settings.json`
- `~/.claude/statusline-command.sh`
- `~/.config/mise/config.toml`
- `~/.config/zed/settings.json`
- `~/.gemini/antigravity-cli/settings.json`
- `~/.gemini/antigravity-cli/keybindings.json`
- `~/.gitconfig` の `init.defaultBranch`
- `~/.vimrc`
- `~/Library/Application Support/Code/User/settings.json`
- `~/Library/Application Support/com.mitchellh.ghostty/config`
- `~/.zshrc` の `# chezmoi: zshrc begin` から `# chezmoi: zshrc end` まで

`~/.zshrc` は chezmoi の `modify_` により管理ブロックだけを差し替え、ブロック外のユーザー固有設定は残します。初回は既存内容の末尾に管理ブロックを追加します。マーカーが不足・重複・逆順の場合は、反映を中止します。

`~/.gitconfig` も `modify_` により `init.defaultBranch = main` だけを更新します。`user.name`、`user.email`、include などの個人設定は保持します。名前とメールアドレスは各マシンで `git config --global` を使って設定してください。

`~/.codex/config.toml` も `modify_` により管理します。固定する設定は `home/.chezmoitemplates/codex-config-managed.toml` に定義し、プラグイン、MCP、信頼済みプロジェクトなど、Codex アプリが追加した設定は保持します。`hooks.json` が存在しない場合は、対応する古いフック信頼情報も削除します。

Codex の既定モデルは `gpt-6-astra`、サブエージェント用は `gpt-6-sol` です。利用可能なモデルはアカウント・クライアントに依存します。

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
- `file-associations.nix`: Markdown / JSON / TOML の既定アプリを設定します。
- 起動音は `system.startup.chime = false;` で無効にします。

`AppleSymbolicHotKeys` は cfprefsd のキャッシュ都合で `darwin-rebuild switch` 直後に反映されない場合があります。反映状況は `defaults read com.apple.symbolichotkeys` で確認し、必要に応じてログアウト/再起動してください。

### Homebrew

nix-darwin の `homebrew` module で管理します。
Homebrew 本体だけは管理対象外のため、初回のみ手動でインストールします。
反映時に管理対象を更新しますが、手動導入済みのツールは自動アンインストールしません。

- `codex` (CLI)
- `ghostty`
- `visual-studio-code`
- `zed`

## 手動管理として残すもの

- `scripts/bootstrap-local.sh`: 各マシンのユーザー名 / ホスト名 / アーキテクチャから `local.nix` を生成します。`local.nix` は `.gitignore` 対象で、共有しません。
- `scripts/github_setup.sh`: 必要な場合だけ使う GitHub SSH 設定用の補助スクリプトです。
- `nix/` に宣言していない macOS 設定は「システム設定」で手動管理します。
- `claude`: 設定ファイルのみ chezmoi で管理します。CLI 本体はこのリポジトリでは管理しません。
- Google Chrome / Brave / Codex デスクトップアプリ: このリポジトリでは管理せず、手動でインストールします。

## GitHub SSH 設定（任意）

```bash
bash scripts/github_setup.sh
```

## 設定反映処理の検証

chezmoi、Git、zsh、jq、Python 3 を利用できる環境で実行します。
一時ディレクトリを使い、実際のホームディレクトリの設定は変更しません。

```bash
python3 -m unittest discover -s tests -v
```
