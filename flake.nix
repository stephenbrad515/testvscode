{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.default = pkgs.writeShellApplication {
        name = "nix-review";
        runtimeInputs = [];
        program = ''
          #!/usr/bin/env bash
          echo "NixOS Code Reviewer"
          echo "Run: nix-review analyze <file>"
          echo "Run: nix-review lint <directory>"
          echo "Run: nix-review check <file>"
        '';
      };

      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.nixfmt-classic
          pkgs.jq
          pkgs.vim
          pkgs.git
        ];
      };
    };
}