# NixOS config

### Setup on new system
1. clone to ~/nixos-config
1. `sudo mv /etc/nixos /etc/nixos.bak`
1. `sudo ln -s ~/nixos-config /etc/nixos`
1. update hardware config from /etc/nixos.bak to ~/nixos-config if necessary
1. `sudo nixos-rebuild switch`
