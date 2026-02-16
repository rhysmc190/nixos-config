{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    xkb = {
      layout = "au";
      variant = "";
    };
    desktopManager.xterm.enable = false;
    excludePackages = [ pkgs.xterm ];
  };

  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  programs.dconf.enable = true;

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  environment.gnome.excludePackages = with pkgs; [
    atomix
    cheese
    epiphany
    geary
    gnome-characters
    gnome-contacts
    gnome-initial-setup
    gnome-music
    gnome-photos
    gnome-tour
    hitori
    iagno
    simple-scan
    tali
    yelp
  ];

}
