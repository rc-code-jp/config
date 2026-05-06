# config

私の設定ファイル集

## セットアップ

macOS の設定は `nix-darwin` と `home-manager` で管理します。
詳細は `nix/README.md` を参照してください。

## 設定の反映

通常はリポジトリ直下で以下を実行します。

```bash
sudo darwin-rebuild switch --flake .#macbook-pro
```

`darwin-rebuild: command not found` になる初回環境では、代わりに以下を実行します。

```bash
sudo nix run github:nix-darwin/nix-darwin/master#darwin-rebuild -- switch --flake .#macbook-pro
```

`flake.lock` の依存関係も更新する場合は、先に以下を実行します。

```bash
nix flake update
```

## 含まれる設定

- ai - AI関連の設定
- ghostty - Ghosttyターミナルの設定
- mise - miseの設定
- vscode - VS Codeの設定
- zed - Zedエディタの設定
- zsh - Zshの設定
