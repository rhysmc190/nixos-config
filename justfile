# rebuild and switch to new configuration
rebuild:
    nh os switch .

# update all flake inputs
update:
    nix flake update

# format nix files
fmt:
    nix fmt

# enter dev shell with formatter and LSP
dev:
    nix develop

# check and apply firmware updates
firmware:
    fwupdmgr refresh; fwupdmgr get-updates; fwupdmgr update
