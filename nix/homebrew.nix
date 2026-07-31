{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };

    casks = [
      "codex" # Codex CLI
      "ghostty"
      "visual-studio-code"
      "zed"
    ];
  };
}
