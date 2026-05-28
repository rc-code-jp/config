{
  pkgs,
  username,
  hostname,
  ...
}:

{
  imports = [
    ./homebrew.nix
    ./system-defaults.nix
    ./keyboard.nix
    ./file-associations.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  networking.hostName = hostname;

  users.users.${username}.home = "/Users/${username}";

  system.primaryUser = username;

  environment.systemPackages = import ./packages.nix {
    inherit pkgs;
  };

  programs.zsh.enable = true;

  system.stateVersion = 6;
}
