{ config, pkgs, ... }:
{
  users.users.rhys.extraGroups = [ "libvirtd" ];
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    spice
    spice-gtk
    spice-protocol
    virtio-win
    virt-manager
    virt-viewer
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