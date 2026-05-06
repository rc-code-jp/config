# Nix 設定

このディレクトリは macOS 用の `nix-darwin` と `home-manager` 設定です。

## 方針

- Homebrew を前提にしない。
- Apple ID、Xcode、SSH 鍵、Keychain、アクセシビリティ権限は自動化対象外として手順に残す。

## 先に管理するもの

- `jq`
- `git`
- `mise`
- `pocogit`
- `pocoshelf`
- `ripgrep`
- `vim`
- zsh / vim / mise / Ghostty / VS Code / Zed / Codex / Claude の設定ファイル
- `~/.codex/AGENTS.md`
- Ghostty 用の `~/bin` スクリプト

## 後で追加するもの

- `codex`: nixpkgs のパッケージ名と実行ファイル名を確認してから追加する。
- `opencode`: nixpkgs のパッケージ名と実行ファイル名を確認してから追加する。
- `fastlane` / `cocoapods`: iOS 開発環境の復元方針を確認してから追加する。
- `node` / `pnpm` / `rust` / `flutter`: 当面は `mise` 管理を優先し、Nix へ寄せるかは別途判断する。

## 初回セットアップ

新しい Mac で Nix インストール後に `nix-darwin` を初めて適用する場合、Nix インストーラが作成した `/etc/bashrc` と `/etc/zshrc` を退避する必要があります。
これは `nix-darwin` が `/etc` 配下の既存ファイルを誤って上書きしないための安全確認です。

```bash
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
```

退避後は `nix-darwin` がシェル初期化ファイルを管理します。
この作業は初回適用時だけ必要です。

`darwin-rebuild` がまだ `PATH` にない初回環境では、以下のように `nix run` 経由で適用します。

```bash
sudo nix run github:nix-darwin/nix-darwin/master#darwin-rebuild -- switch --flake .#macbook-pro
```

適用後は `darwin-rebuild` が使えるようになるため、以降は通常の更新コマンドを使います。

```bash
sudo darwin-rebuild switch --flake .#macbook-pro
```

## Claude statusline

`ai-config/claude/statusline-command.sh` は JSON を読むために `jq` が必要です。
`nix/darwin.nix` の `environment.systemPackages` に `jq` を含めています。

`ai-config/claude/_settings.json` は以下を参照します。

```json
"command": "bash ~/.claude/statusline-command.sh"
```

`bash` 経由で実行するため実行権限は必須ではありませんが、他の用途でも直接実行できるように `home-manager` で実行権限を付けています。

## 確認コマンド

`darwin-rebuild` 導入後に、設定を適用する前に確認する場合は以下を順に実行します。

```bash
nix flake check
darwin-rebuild check --flake .#macbook-pro
darwin-rebuild build --flake .#macbook-pro
```

適用するときは、ビルド確認後に以下を実行します。

```bash
sudo darwin-rebuild switch --flake .#macbook-pro
```

`flake.lock` の依存関係を更新する場合は、適用前に以下を実行します。

```bash
nix flake update
```
