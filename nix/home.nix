{
  username,
  ...
}:

{
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  home.file = {
    ".zshrc".source = ../zsh/zshrc.sh;
    ".vimrc".source = ../vim/vimrc.txt;

    ".config/mise/config.toml".source = ../mise/_config.toml;
    ".config/zed/settings.json".source = ../zed/_settings.jsonc;

    "Library/Application Support/Code/User/settings.json".source = ../vscode/_settings.jsonc;
    "Library/Application Support/com.mitchellh.ghostty/config".source = ../ghostty/config.txt;

    ".codex/config.toml".source = ../ai-config/codex/config.toml;
    ".codex/AGENTS.md".source = ../ai-config/codex/AGENTS.md;
    ".claude/settings.json".source = ../ai-config/claude/_settings.json;
    ".claude/statusline-command.sh" = {
      source = ../ai-config/claude/statusline-command.sh;
      executable = true;
    };

    "bin/go_panel_right" = {
      source = ../ghostty/go_panel_right;
      executable = true;
    };
    "bin/sw" = {
      source = ../ghostty/sw;
      executable = true;
    };
    "bin/sww" = {
      source = ../ghostty/sww;
      executable = true;
    };
    "bin/ew" = {
      source = ../ghostty/ew;
      executable = true;
    };
  };

  # home-manager の互換性用バージョン。新規導入時点の値として固定する。
  home.stateVersion = "24.11";
}
