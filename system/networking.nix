{ settings, ... }: {
  networking = {
    hostName = settings.hostname;
    networkmanager.enable = true;
    firewall = rec {
      enable = true;
      allowedTCPPorts = [ 80 443 8081 9099 ];
      allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
  };

  services.tailscale.enable = true;
}
