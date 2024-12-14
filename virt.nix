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
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
}