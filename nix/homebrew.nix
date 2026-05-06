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
      "ghostty"
      "visual-studio-code"
      "zed"
    ];
  };
}
