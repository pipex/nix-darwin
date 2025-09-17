# https://github.com/pipex/nixpkgs/blob/macbook/balena-cli.nix
{
  pkgs ? import <nixpkgs> {},
  version,
  hash,
}:
pkgs.stdenv.mkDerivation {
  name = "balena-cli";

  src = pkgs.fetchurl {
    url = "https://github.com/balena-io/balena-cli/releases/download/v${version}/balena-cli-v${version}-macOS-arm64-standalone.tar.gz";
    sha256 = "${hash}";
  };

  unpackPhase = ''
    tar -xzf $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv balena $out/balena-cli
    chmod +x $out/balena-cli/bin/balena
    ln -s $out/balena-cli/bin/balena $out/bin/balena
  '';
}
