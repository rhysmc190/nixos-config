hostname := "fwk-nixos"

# rebuild and switch to new configuration
rebuild:
    sudo nixos-rebuild switch --flake .#{{hostname}} |& nom

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
    fwupdmgr refresh && fwupdmgr get-updates && fwupdmgr update
