{
  description = "rc-code-jp の macOS 設定";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pocogit = {
      url = "github:rc-code-jp/pocogit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pocoshelf = {
      url = "github:rc-code-jp/pocoshelf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nix-darwin,
      home-manager,
      ...
    }:
    let
      system = "aarch64-darwin";
      username = "rc";
      hostname = "RyosukenoMacBook-Pro";
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;

        specialArgs = {
          inherit inputs username hostname;
        };

        modules = [
          ./nix/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              inherit inputs username hostname;
            };
            home-manager.users.${username} = import ./nix/home.nix;
          }
        ];
      };
    };
}
