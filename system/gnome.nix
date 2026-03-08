{ pkgs, ... }:
{
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  # Forward login password to gpg-agent so GPG key is unlocked at login
  # gdm-password substacks to login, so gnupg must be enabled on login
  security.pam.services.login.gnupg.enable = true;

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
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-connections
    gnome-contacts
    gnome-initial-setup
    gnome-logs
    gnome-maps
    gnome-music
    gnome-photos
    gnome-tour
    gnome-weather
    hitori
    iagno
    simple-scan
    snapshot
    tali
    yelp
  ];

}
