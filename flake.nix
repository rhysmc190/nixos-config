{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
			url = "github:nix-community/home-manager";
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
      modules = with self.nixosModules; [
      	#({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; })
        ./configuration.nix
        home-manager.nixosModules.home-manager
        gnome
        declarativeHome
      ];
    };
  };
}
