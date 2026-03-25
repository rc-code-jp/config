# Ghostty

## file

```bash
curl -L -o "$HOME/Library/Application Support/com.mitchellh.ghostty/config" \
  https://raw.githubusercontent.com/rc-code-jp/config/main/ghostty/config.txt
```

## install

```bash
mkdir -p "$HOME/bin"
curl -L -o "$HOME/bin/uuu" \
  https://raw.githubusercontent.com/rc-code-jp/config/main/ghostty/uuu
chmod +x "$HOME/bin/uuu"
curl -L -o "$HOME/bin/qqq" \
  https://raw.githubusercontent.com/rc-code-jp/config/main/ghostty/qqq
chmod +x "$HOME/bin/qqq"
grep -qF 'export PATH="$HOME/bin:$PATH"' ~/.zshrc || echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```
