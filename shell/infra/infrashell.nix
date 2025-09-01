{
  description = "DevShell para infraestrutura declarativa com Terraform e Colmena";

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
          name = "infra-dev-shell";
          buildInputs = with pkgs; [
            git
            terraform
            opentofu
            colmena
            sops
            age
            jq
            yq
          ];
          shellHook = ''
            echo "🔧 Shell de infraestrutura ativado. Ready to terraform apply!"
          '';
        };
      }
    );
}
