# Ghostty

## file

```bash
curl -L -o "$HOME/Library/Application Support/com.mitchellh.ghostty/config" \
  https://raw.githubusercontent.com/rc-code-jp/config/main/ghostty/config.txt
```

## script

```bash
mkdir -p "$HOME/bin"
curl -L -o "$HOME/bin/ghostty-work.applescript" \
  https://raw.githubusercontent.com/rc-code-jp/config/main/ghostty/ghostty-work.applescript
chmod +x "$HOME/bin/ghostty-work.applescript"
grep -qF "alias work=" ~/.zshrc || echo "alias work='ghostty-work.applescript'" >> ~/.zshrc
source ~/.zshrc
```
