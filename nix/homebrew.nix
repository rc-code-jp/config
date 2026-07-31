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
      "codex" # Codex CLI
      "ghostty"
      "visual-studio-code"
      "zed"
    ];
  };
}
