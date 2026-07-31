{ config, ... }:

{
  environment.systemPath = [
    "${config.homebrew.prefix}/bin"
    "${config.homebrew.prefix}/sbin"
  ];

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
