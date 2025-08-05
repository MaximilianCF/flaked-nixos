{
  services = {
    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        autoLogin = {
          enable = true;
          user = "max";
        };
      };
      desktopManager.gnome.enable = true;
    };

    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    pulseaudio.enable = false;
  };

  security.rtkit.enable = true;
}
