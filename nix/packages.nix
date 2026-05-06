{
  pkgs,
  inputs,
  system,
}:

with pkgs;
[
  chezmoi
  mise
  fastlane
  cocoapods
  opencode
  inputs.pocoshelf.packages.${system}.pocoshelf
  inputs.pocogit.packages.${system}.pocogit
]
