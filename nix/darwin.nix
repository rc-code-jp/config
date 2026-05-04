{
  pkgs,
  username,
  hostname,
  ...
}:

{
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config.allowUnfree = true;

  networking.hostName = hostname;
  system.primaryUser = username;

  users.users.${username}.home = "/Users/${username}";

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    git
    jq
    mise
    ripgrep
    vim
  ];

  # 自作TUIは各本体リポジトリで Nix 対応してから flake input として追加する。
  # TODO: pocoshelf を追加する。
  # TODO: pocogit を追加する。

  # nix-darwin の互換性用バージョン。新規導入時点の値として固定する。
  system.stateVersion = 5;
}
