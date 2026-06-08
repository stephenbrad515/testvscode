# Test runner for NixOS code reviewer
{ pkgs ? import <nixpkgs> {} }:

pkgs.runCommand "nix-code-reviewer-tests" {
  nativeBuildInputs = [ pkgs.nixfmt-classic ];
} ''
  mkdir -p $out/tests
  cp examples/*.nix $out/tests/
  cp nix-review.nix $out/tests/
  echo "Tests copied to $out/tests"
''
