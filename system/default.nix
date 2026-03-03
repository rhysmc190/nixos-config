{ settings, pkgs, lib, ... }:
{
  imports = [
    ./boot.nix
    ./framework.nix
    ./networking.nix
    ./locale.nix
    ./gnome.nix
    ./audio.nix
    ./bluetooth.nix
    ./power.nix
    ./printing.nix
    ./virtualisation.nix
    ./steam.nix
    ./nix.nix
    ./fonts.nix
    ./maintenance.nix
    ./sudo.nix
  ];

  programs.zsh.enable = true;

  programs.ydotool.enable = true;

  users.users.${settings.username} = {
    isNormalUser = true;
    description = settings.username;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "ydotool"
    ];
  };

  # Disable services that aren't needed and slow down boot
  systemd.services = {
    ModemManager.enable = false; # no cellular modem
    NetworkManager-wait-online.enable = false; # not needed on desktop
    wpa_supplicant.enable = true; # NetworkManager handles WiFi directly
    libvirtd.wantedBy = lib.mkForce [ ]; # socket-activate instead of starting at boot
    libvirt-guests.wantedBy = lib.mkForce [ ];
  };

  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "30s";
  };

  system.stateVersion = "23.11";
}
