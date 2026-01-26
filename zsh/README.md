# Zsh Config Installer

`zsh/install_zshrc.sh` updates `~/.zshrc` using the template block in
`zsh/zshrc.sh`.

## Behavior

- If `~/.zshrc` does not exist, it is created from the template block.
- If `# Config-Start` and `# Config-End` exist, the block is replaced.
- If the block is missing, it is appended to the end of `~/.zshrc`.

## Usage

### リモートインストール（リポジトリのクローン不要）

GitHubから直接インストールできます：

```bash
curl -fsSL https://raw.githubusercontent.com/rc-code-jp/config/main/zsh/install_zshrc.sh | bash
```

環境変数でカスタマイズする場合：

```bash
curl -fsSL https://raw.githubusercontent.com/rc-code-jp/config/main/zsh/install_zshrc.sh | \
  GITHUB_USER=your-username GITHUB_REPO=your-repo GITHUB_BRANCH=your-branch bash
```

### ローカルインストール

リポジトリをクローンした後：

```bash
git clone https://github.com/rc-code-jp/config.git
cd config/zsh
```

```bash
bash zsh/install_zshrc.sh
```

After running, reload your shell:

```bash
source ~/.zshrc
```

## 便利なプラグイン

gitコマンドを置換してくれる

https://github.com/zimfw/zimfw
