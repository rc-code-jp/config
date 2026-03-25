# Ghostty

## file

```bash
curl -L -o "$HOME/Library/Application Support/com.mitchellh.ghostty/config" \
  https://raw.githubusercontent.com/rc-code-jp/config/main/ghostty/config.txt
```

## install

```bash
mkdir -p "$HOME/bin"
curl -L -o "$HOME/bin/uuu.applescript" \
  https://raw.githubusercontent.com/rc-code-jp/config/main/ghostty/uuu.applescript
chmod +x "$HOME/bin/uuu.applescript"
curl -L -o "$HOME/bin/qqq.applescript" \
  https://raw.githubusercontent.com/rc-code-jp/config/main/ghostty/qqq.applescript
chmod +x "$HOME/bin/qqq.applescript"
grep -qF 'export PATH="$HOME/bin:$PATH"' ~/.zshrc || echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```
