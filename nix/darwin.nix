{
  pkgs,
  inputs,
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
    inputs.pocogit.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.pocoshelf.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # nix-darwin の互換性用バージョン。新規導入時点の値として固定する。
  system.stateVersion = 5;
}
