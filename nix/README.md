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

## Claude statusline

`ai-config/claude/statusline-command.sh` は JSON を読むために `jq` が必要です。
`nix/darwin.nix` の `environment.systemPackages` に `jq` を含めています。

`ai-config/claude/_settings.json` は以下を参照します。

```json
"command": "bash ~/.claude/statusline-command.sh"
```

`bash` 経由で実行するため実行権限は必須ではありませんが、他の用途でも直接実行できるように `home-manager` で実行権限を付けています。

## 確認コマンド

```bash
nix flake check
darwin-rebuild check --flake .#RyosukenoMacBook-Pro
darwin-rebuild build --flake .#RyosukenoMacBook-Pro
```

適用するときは、ビルド確認後に以下を実行します。

```bash
darwin-rebuild switch --flake .#RyosukenoMacBook-Pro
```
