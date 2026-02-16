# NixOS Config

NixOS configuration for Framework 13 laptop with GNOME desktop.

## Commands

- Rebuild: `sudo nixos-rebuild switch --flake .#fwk-nixos`
- Update flake inputs: `nix flake update`
- Format: `nix fmt`
- Dev shell (formatter + LSP): `nix develop`

## Structure

- `system/` — NixOS system-level modules
- `home/` — Home-manager user-level modules
- `files/` — Static files linked into the home directory
- `hardware-configuration.nix` — Auto-generated, don't edit manually

## Conventions

- 2-space indentation, no tabs
- One concern per file
- User-facing packages go in `home/packages.nix`, system infrastructure in respective system modules
- Shared settings (username, hostname) are defined in `flake.nix` and passed via `specialArgs`
