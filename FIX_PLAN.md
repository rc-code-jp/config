# 設定管理改善計画

このファイルは作業用の計画メモです。移行作業が完了したら削除します。

## 目的

- dotfiles は chezmoi で管理する。
- アプリや CLI ツールは nix / nix-darwin で管理する。
- Homebrew が必要なツールは nix-darwin の Homebrew 管理経由に寄せる。
- 現在 README や個別スクリプトに散らばっているセットアップ手順を、宣言的な管理へ移す。

## 現状

- 設定ファイルは用途別ディレクトリに配置されている。
  - `ai-config/`
  - `ghostty/`
  - `mise/`
  - `vim/`
  - `vscode/`
  - `zed/`
  - `zsh/`
- 各 README には `curl` で設定ファイルを直接配置する手順がある。
- `zsh/zshrc.sh` は `# Config-Start` / `# Config-End` のブロックを `zsh/install_zshrc.sh` で部分更新している。
- `README.md` には nix へ移行したいツールとして以下が記載されている。
  - `mise`
  - `fastlane`
  - `cocoapods`
  - `codex`
  - `opencode`
  - `pocoshelf`
  - `pocogit`
- 現時点では `flake.nix`、`home.nix`、`darwin-configuration.nix`、`Brewfile`、chezmoi 用ファイルは存在しない。

## 管理方針

### chezmoi で管理するもの

- ホームディレクトリ配下へ配置する設定ファイル。
- アプリの設定ファイル。
- シェル設定の実体ファイル。
- AI ツールのグローバル設定。

基本は symlink ではなく、chezmoi による実ファイル生成で管理する。

### nix / nix-darwin で管理するもの

- CLI ツール。
- macOS アプリ。
- Homebrew tap / brew / cask。
- nix flakes による再現可能なパッケージ定義。

### mise の扱い

- `mise` 自体は nix でインストールする。
- Node / pnpm / Flutter / Rust などの言語ランタイム管理は、既存どおり mise に残す。
- `mise/config.toml` は chezmoi で管理する。

## 推奨ディレクトリ構成

```text
/Users/rc/work/config
├── flake.nix
├── flake.lock
├── nix/
│   ├── darwin.nix
│   ├── packages.nix
│   └── homebrew.nix
├── home/
│   ├── dot_config/
│   │   ├── mise/
│   │   │   └── config.toml
│   │   ├── zed/
│   │   │   └── settings.json
│   │   └── zsh/
│   │       └── config.zsh
│   ├── dot_codex/
│   │   ├── AGENTS.md
│   │   └── config.toml
│   ├── dot_claude/
│   │   ├── settings.json
│   │   └── statusline-command.sh
│   └── dot_vimrc
├── ghostty/
├── vscode/
├── README.md
└── FIX_PLAN.md
```

`ghostty` や `vscode` は配置先にスペースを含む macOS 固有パスがあるため、chezmoi での表現方法を確認してから移す。

## zshrc の管理方針

現在の `zshrc` は `# Config-Start` から `# Config-End` までのコメントブロックを部分更新対象にしている。

chezmoi 移行後も、この部分更新方式を維持する。

- chezmoi 管理下に `zshrc` の管理ブロック本体を置く。
- `run_onchange_` スクリプトで `~/.zshrc` の `# Config-Start` / `# Config-End` ブロックだけを差し替える。
- `~/.zshrc` のブロック外にあるユーザー固有設定は変更しない。
- 将来的に必要になれば `source ~/.config/zsh/config.zsh` 方式へ移行できるようにする。

この方式にすると、現在の運用に近いまま chezmoi へ移行できる。

## TOML ファイルの管理方針

- `mise/config.toml` や `codex/config.toml` は、原則として chezmoi でファイル全体を管理する。
- ローカル差分が必要な値は chezmoi template と data で切り替える。
- 既存ファイルの一部だけを更新する必要がある場合は、`run_onchange_` スクリプトと TOML パーサーを使う。
- ただし、部分更新は複雑になりやすいため、まずは全体管理または設定分割を優先する。

## Step 1: 現状整理

- 現在の設定ファイルを chezmoi の配置名へ対応づける。
- 既存 README にある `curl` 手順を洗い出す。
- nix 管理へ移す CLI / アプリを確定する。
- macOS 固有パスを使う設定ファイルの配置方法を確認する。

## Step 2: chezmoi 管理へ移す

- `home/` 配下に chezmoi 管理用ファイルを作る。
- `zsh/zshrc.sh` の実体を `home/dot_config/zsh/config.zsh` へ移す。
- `mise/_config.toml` を `home/dot_config/mise/config.toml` へ移す。
- `ai-config/codex/config.toml` を `home/dot_codex/config.toml` へ移す。
- `ai-config/codex/AGENTS.md` を `home/dot_codex/AGENTS.md` へ移す。
- `ai-config/claude/_settings.json` を `home/dot_claude/settings.json` へ移す。
- `ai-config/claude/statusline-command.sh` を `home/dot_claude/statusline-command.sh` へ移す。
- `vim/vimrc.txt` を `home/dot_vimrc` へ移す。
- Zed / VS Code / Ghostty の設定は chezmoi の配置名を確認してから移す。

## Step 3: zshrc の部分更新を chezmoi 化する

- `# Config-Start` から `# Config-End` までを管理ブロックとして扱う。
- chezmoi の `run_onchange_` スクリプトで `~/.zshrc` の管理ブロックだけを差し替える。
- `~/.zshrc` に管理ブロックがない場合は末尾に追加する。
- `~/.zshrc` が存在しない場合は管理ブロックのみで新規作成する。
- ブロック外のユーザー固有設定は変更しない。

## Step 4: nix / nix-darwin 管理を追加する

- `flake.nix` を追加する。
- nix-darwin 用の `nix/darwin.nix` を追加する。
- 共通パッケージを `nix/packages.nix` に分離する。
- Homebrew 管理が必要なものだけ `nix/homebrew.nix` に分離する。

### nix で管理する候補

- `mise`
- `fastlane`
- `cocoapods`
- `codex`
- `opencode`
- `pocoshelf`
- `pocogit`

実際に nixpkgs に存在するかは実装時に確認する。

### Homebrew 経由で管理する候補

- `codex`

`codex` はユーザー希望に合わせて、nix-darwin の Homebrew 管理経由を優先候補にする。

## Step 5: README を更新する

- README を新しい運用手順に更新する。
- 旧 curl 手順は削除または「旧手順」として整理する。
- 管理対象と手動管理として残すものを明記する。

## Step 6: 検証する

- `chezmoi diff` で差分を確認する。
- `nix flake check` を実行する。
- macOS 環境で `darwin-rebuild build --flake` を実行する。
- 問題なければ `darwin-rebuild switch --flake` と `chezmoi apply` の運用手順を README に反映する。

## Step 7: 移行後の整理

- 旧インストールスクリプトを残すか削除するか判断する。
- 旧ディレクトリ構成を残すか、chezmoi / nix 構成へ集約するか判断する。
- 移行完了後に `FIX_PLAN.md` を削除する。

## README に書く内容

- このリポジトリの目的。
- 初回セットアップ手順。
- 日常の更新手順。
- chezmoi の使い方。
- nix-darwin の使い方。
- 管理対象の一覧。
- 手動管理として残すもの。

## 注意点

- 既存の `curl` 前提の運用を一度に消さず、移行完了まで参照できる状態にする。
- `~/.zshrc` 全体を chezmoi 管理にするとローカル設定を巻き込みやすいため、`# Config-Start` / `# Config-End` ブロックの部分更新を採用する。
- `codex` の提供元は nixpkgs と Homebrew の両方を確認し、最終的には Homebrew 経由の nix-darwin 管理を優先する。
- `pocoshelf` と `pocogit` は nix 対応済みのため、Homebrew tap は使わない。
- `ghostty`、VS Code、Zed は macOS 固有パスがあるため、chezmoi の配置名を慎重に決める。
- secrets や個人情報を含む値は chezmoi template / ignored file / 外部 secret 管理の利用を検討する。

## 完了条件

- dotfiles が chezmoi で再現できる。
- CLI / アプリのインストールが nix-darwin で再現できる。
- `codex` が nix-darwin 管理下の Homebrew 経由で扱われている。
- `pocoshelf` と `pocogit` が nix 経由で扱われている。
- README から新しいセットアップ手順を辿れる。
- 旧インストール手順への依存がなくなっている。
- `FIX_PLAN.md` が削除されている。
