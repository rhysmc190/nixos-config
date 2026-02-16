{ pkgs, settings, ... }:
let
  bhcResources = "${pkgs.gnomeExtensions.battery-health-charging}/share/gnome-shell/extensions/Battery-Health-Charging@maniacx.github.com/resources";
in
{
  # Battery Health Charging extension requires its helper script and a polkit rule
  system.activationScripts.batteryHealthCharging.text = ''
    mkdir -p /usr/local/bin
    install -m 0755 ${bhcResources}/batteryhealthchargingctl /usr/local/bin/batteryhealthchargingctl-${settings.username}
  '';

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id === "org.freedesktop.policykit.exec" &&
            action.lookup("program") === "/usr/local/bin/batteryhealthchargingctl-${settings.username}" &&
            subject.user === "${settings.username}")
        {
            return polkit.Result.YES;
        }
    });
  '';

  services.xserver = {
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
