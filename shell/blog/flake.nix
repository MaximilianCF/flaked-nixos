{
  description = "DevShell para o blog em Astro (Nix)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "blog-dev-shell";
          buildInputs = with pkgs; [
            nodejs_latest
            nodePackages.npm
            git
          ];
          shellHook = ''
            echo "🚀 Blog shell ativo — rode: npm install && npm run dev"
          '';
        };
      }
    );
}
