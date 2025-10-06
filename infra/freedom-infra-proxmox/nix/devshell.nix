{
  pkgs,
  inputs,
  system,
  ...
}:

pkgs.mkShell {
  # Add build dependencies
  packages = [
    pkgs.opentofu
    pkgs.jq
    inputs.nix-anywhere.packages.${system}.default
  ];
}
