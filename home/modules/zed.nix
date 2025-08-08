{ pkgs, ... }:

{

  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    extensions = [
      "swift"
      "nix"
      "xy-zed"
    ];
    extraPackages = [
      pkgs.nixd
    ];
  };

}
