{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };

    taps = [ "anomalyco/tap" ];

    brews = [ "opencode" ];

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
