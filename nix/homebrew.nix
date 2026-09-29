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
      # 手動導入した CLI やアプリは、このリポジトリの反映時に削除しない。
      cleanup = "none";
    };

    casks = [
      "codex" # Codex CLI
      "ghostty"
      "visual-studio-code"
      "zed"
    ];
  };
}
