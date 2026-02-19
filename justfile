# rebuild and switch to new configuration
rebuild:
    sudo -v
    nh os switch .

# update all flake inputs and rebuild
update:
    sudo -v
    nix flake update
    nh os switch .

# format nix files
fmt:
    nix fmt

# enter dev shell with formatter and LSP
dev:
    nix develop

# check and apply firmware updates
firmware:
    fwupdmgr refresh; fwupdmgr get-updates; fwupdmgr update
