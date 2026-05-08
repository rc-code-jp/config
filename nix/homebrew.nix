{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };

    brews = [ ];

    casks = [
      "brave-browser"
      "codex" # Codex CLI
      "codex-app" # Codex デスクトップアプリ
      "ghostty"
      "google-chrome"
      "visual-studio-code"
      "zed"
    ];
  };
}
