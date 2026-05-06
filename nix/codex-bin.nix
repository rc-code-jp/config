{ fetchurl, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "codex";
  version = "0.128.0";

  src = fetchurl {
    url = "https://github.com/openai/codex/releases/download/rust-v0.128.0/codex-aarch64-apple-darwin.tar.gz";
    hash = "sha256-8GggLoqJjCQMjAaEAbzNMLp7VvYfX/zRSD1UXUeq89U=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    install -m 0755 codex-aarch64-apple-darwin "$out/bin/codex"

    runHook postInstall
  '';
}
