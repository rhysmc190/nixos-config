{
  description = "NixOS setup for fwk 13 laptop w/ gnome desktop and home-manager";

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
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
  	nixosModules = {
  		gnome = import ./modules/gnome.nix;
  		declarativeHome = import ./modules/declarativeHome.nix;
  	};

    nixosConfigurations.fwk-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = with self.nixosModules; [
      	#({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; })
        ./configuration.nix
        ./virt.nix
        home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = [
            (final: prev: {
              zenBrowserTwilight = inputs.zen-browser.packages.${final.stdenv.hostPlatform.system}.twilight;
            })
          ];
        }
        gnome
        declarativeHome
      ];
    };
  };
}
