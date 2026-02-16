{ pkgs, ... }:
{
  home.packages = with pkgs; [
    spice
    spice-gtk
    spice-protocol
    virt-manager
    virt-viewer
    virtio-win
    win-spice
  ];
}
