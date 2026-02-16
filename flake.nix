{
  description = "NixOS config for Framework 13 laptop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      settings = {
        username = "rhys";
        hostname = "fwk-nixos";
      };
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          nixfmt-tree
          nil
          statix
          deadnix
        ];
      };

      checks.${system} = {
        system = self.nixosConfigurations.${settings.hostname}.config.system.build.toplevel;
      };

      nixosConfigurations.${settings.hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs settings; };
        modules = [
          inputs.nixos-hardware.nixosModules.framework-13-7040-amd
          ./hardware-configuration.nix
          ./system
          home-manager.nixosModules.home-manager
          ./home
          {
            nixpkgs.overlays = [
              (final: _prev: {
                zenBrowserTwilight = inputs.zen-browser.packages.${final.stdenv.hostPlatform.system}.twilight;
              })
            ];
          }
        ];
      };
    };
}
