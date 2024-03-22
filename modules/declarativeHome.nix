{ ... }: {
  config = {
		home-manager.useGlobalPkgs = true;
		home-manager.useUserPackages = true;
		home-manager.users.rhys = import ./home.nix;
  };
}
