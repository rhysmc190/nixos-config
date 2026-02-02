{ inputs, ... }: {
  config = {
		home-manager.backupFileExtension = "backup";
		home-manager.useGlobalPkgs = true;
		home-manager.useUserPackages = true;
		home-manager.extraSpecialArgs = { inherit inputs; };
		home-manager.sharedModules = [
			inputs.nixvim.homeModules.nixvim
		];
		home-manager.users.rhys = { imports = [ ./home.nix ./neovim.nix ]; };
  };
}
