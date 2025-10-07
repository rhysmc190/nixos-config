{ config, pkgs, ... }:
{
  users.users.rhys.extraGroups = [ "libvirtd" ];
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    spice
    spice-gtk
    spice-protocol
    virt-manager
    virt-viewer
    win-virtio
    win-spice
  ];
  virtualisation = {
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