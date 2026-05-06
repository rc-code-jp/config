{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    brews = [
      "codex"
    ];

    casks = [
      "brave-browser"
      "ghostty"
      "google-chrome"
      "visual-studio-code"
      "zed"
    ];
  };
}
