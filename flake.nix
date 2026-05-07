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
      local =
        if builtins.pathExists ./local.nix then
          import ./local.nix
        else
          throw ''
            local.nix が見つかりません。先に次を実行してください:
              ./scripts/bootstrap-local.sh
          '';
      system = local.system or "aarch64-darwin";
      inherit (local) username hostname;
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
