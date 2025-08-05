{ pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "libsoup-2.74.3" ];
  };

  fonts = {
    enableDefaultPackages = true;

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [
          "Open Sans"
          "Ubuntu"
        ];
        serif = [ "Ubuntu" ];
      };
    };

    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.ubuntu
      open-sans
      nerd-fonts.space-mono
      nerd-fonts.fira-code
      google-fonts
    ];
  };
}
