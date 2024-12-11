{ config, pkgs, ... }:
{
  users.users.rhys.extraGroups = [ "libvirtd" ];
  environment.systemPackages = with pkgs; [
    spice
    spice-gtk
    spice-protocol
    virt-manager
    virt-viewer
    win-virtio
    win-spice
    gnome.adwaita-icon-theme
  ];
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagent.enable = true;
}