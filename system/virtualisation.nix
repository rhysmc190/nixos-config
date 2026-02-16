{ settings, pkgs, ... }:
{
  users.users.${settings.username}.extraGroups = [
    "docker"
    "libvirtd"
  ];

  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };

  services.spice-vdagentd.enable = true;
}
