# NixOS Config

NixOS configuration for Framework 13 laptop with GNOME desktop.

## Commands

- Rebuild: `just rebuild`
- Update flake inputs: `just update`
- Format: `just fmt`
- Dev shell (formatter + LSP + linters): `just dev`
- Firmware updates: `just firmware`
- List all recipes: `just --list`

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
