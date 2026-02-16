{ settings, pkgs, ... }:
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
    ./ollama.nix
    ./steam.nix
    ./nix.nix
    ./fonts.nix
    ./maintenance.nix
    ./sudo.nix
  ];

  programs.zsh.enable = true;

  users.users.${settings.username} = {
    isNormalUser = true;
    description = settings.username;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "30s";
  };

  system.stateVersion = "23.11";
}
