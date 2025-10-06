# checks/deadnix.nix
{
  pname,
  pkgs,
  flake,
}:

pkgs.runCommand "deadnix-check"
  {
    nativeBuildInputs = [ pkgs.deadnix ];
    meta.platforms = pkgs.lib.platforms.linux;
  }
  ''
    cd ${flake}
    ${pkgs.deadnix}/bin/deadnix --fail .
    touch $out
  ''
