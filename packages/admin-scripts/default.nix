# Helpful bash scripts useful for onboarding systems.
{ pkgs, stdenv, lib, ... }:
pkgs.stdenv.mkDerivation {
  name = "admin-scripts";
  src = ./.;

  installPhase = ''
    mkdir -p $out/bin
    for script in *.sh; do
      cp "$script" "$out/bin/''${script%.sh}"  # Remove .sh extension during copy
      chmod +x "$out/bin/''${script%.sh}"
    done
  '';
}