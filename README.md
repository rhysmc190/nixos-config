# NixOS config

### Setup on new system
1. clone to ~/nixos-config
1. `sudo mv /etc/nixos /etc/nixos.bak`
1. `sudo ln -s ~/nixos-config /etc/nixos`
1. update hardware config from /etc/nixos.bak to ~/nixos-config if necessary
1. `sudo nixos-rebuild switch`

### System Update

`nix flake update`

`sudo nixos-rebuild switch`

### Troubleshooting

`error: ... ***-source/*.nix: file or directory does not exist`:
try `git add .`

`error: insufficient permission for adding an object to repository database .git/objects`:
try `sudo chmod -R 777 .git`

### Rollback

when rolling back to a certain build number from boot, run `sudo /run/booted-system/bin/switch-to-configuration boot` to make the current config the default one to boot into
