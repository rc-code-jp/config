{
  description = "rc の macOS 設定管理";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    pocoshelf.url = "github:rc-code-jp/pocoshelf";
    pocogit.url = "github:rc-code-jp/pocogit";
  };

  outputs =
    inputs@{ nix-darwin, nixpkgs, ... }:
    let
      system = "aarch64-darwin";
      username = "rc";
      hostname = "macbook-pro";
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {
          inherit
            inputs
            system
            username
            hostname
            ;
        };
        modules = [
          ./nix/darwin.nix
        ];
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
    };
}
