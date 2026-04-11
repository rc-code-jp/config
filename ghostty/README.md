# Ghostty

## file

```bash
curl -L -o "$HOME/Library/Application Support/com.mitchellh.ghostty/config" \
  https://raw.githubusercontent.com/rc-code-jp/config/main/ghostty/config.txt
```

## install

```bash
mkdir -p "$HOME/bin"
grep -qF 'export PATH="$HOME/bin:$PATH"' ~/.zshrc || echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

```bash
curl -L -o "$HOME/bin/dev" \
  https://raw.githubusercontent.com/rc-code-jp/config/main/ghostty/dev
chmod +x "$HOME/bin/dev"

curl -L -o "$HOME/bin/sw" \
  https://raw.githubusercontent.com/rc-code-jp/config/main/ghostty/sw
chmod +x "$HOME/bin/sw"

curl -L -o "$HOME/bin/ew" \
  https://raw.githubusercontent.com/rc-code-jp/config/main/ghostty/ew
chmod +x "$HOME/bin/ew"
```
