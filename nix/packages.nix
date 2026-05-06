{
  pkgs,
  inputs,
  system,
}:

with pkgs;
[
  chezmoi
  git
  jq
  mise
  fastlane
  cocoapods
  opencode
  inputs.pocoshelf.packages.${system}.pocoshelf
  inputs.pocogit.packages.${system}.pocogit
]
