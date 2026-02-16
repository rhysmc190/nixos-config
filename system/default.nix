{ settings, pkgs, ... }: {
  imports = [
    ./boot.nix
    ./networking.nix
    ./locale.nix
    ./gnome.nix
    ./audio.nix
    ./bluetooth.nix
    ./power.nix
    ./printing.nix
    ./fingerprint.nix
    ./virtualisation.nix
    ./ollama.nix
    ./steam.nix
    ./nix.nix
  ];

  programs.zsh.enable = true;

  users.users.${settings.username} = {
    isNormalUser = true;
    description = settings.username;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "30s";
  };

  system.stateVersion = "23.11";
}
