## 設定ファイルの管理

このリポジトリの設定ファイルは以下の2種類に分かれている。

### chezmoi管理（dotfiles・アプリ設定）

`home/` 以下のファイルは chezmoi によって管理されている。
`~/.config/` や `~/.zshrc` などへの変更を反映する場合は、必ず `chezmoi apply` コマンドを使用すること。
直接ファイルを書き換えてはならない。

### nix-darwin管理（システム設定・パッケージ・Homebrew）

`nix/` 以下のファイルや `flake.nix` は nix-darwin によって管理されている。
反映する場合は `darwin-rebuild switch --flake .#"$(scutil --get LocalHostName)"` を使用すること。