{ settings, pkgs, ... }:
{
  users.users.${settings.username}.extraGroups = [
    "docker"
    "libvirtd"
  ];

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false; # start on first use via socket activation
    };
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };

}
