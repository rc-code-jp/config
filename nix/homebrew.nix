{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
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
