{ settings, ... }: {
  networking = {
    hostName = settings.hostname;
    networkmanager.enable = true;
    firewall = rec {
      enable = true;
      allowedTCPPorts = [
        80    # HTTP
        443   # HTTPS
        8081  # dev server
        9099  # Firebase emulator auth
      ];
      # GSConnect (KDE Connect for GNOME)
      allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
  };

  services.tailscale.enable = true;
}
