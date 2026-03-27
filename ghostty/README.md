# Ghostty

## file

```bash
curl -L -o "$HOME/Library/Application Support/com.mitchellh.ghostty/config" \
  https://raw.githubusercontent.com/rc-code-jp/config/main/ghostty/config.txt
```

## install

```bash
mkdir -p "$HOME/bin"
curl -L -o "$HOME/bin/sw" \
  https://raw.githubusercontent.com/rc-code-jp/config/main/ghostty/sw
chmod +x "$HOME/bin/sw"
curl -L -o "$HOME/bin/ew" \
  https://raw.githubusercontent.com/rc-code-jp/config/main/ghostty/ew
chmod +x "$HOME/bin/ew"
grep -qF 'export PATH="$HOME/bin:$PATH"' ~/.zshrc || echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```
