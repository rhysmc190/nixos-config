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
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    settings = {
      username = "rhys";
      hostname = "fwk-nixos";
    };
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    formatter.${system} = pkgs.nixfmt;

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        nixfmt
        nil
      ];
    };

    nixosConfigurations.${settings.hostname} = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs settings; };
      modules = [
        ./hardware-configuration.nix
        ./system
        home-manager.nixosModules.home-manager
        ./home
        {
          nixpkgs.overlays = [
            (final: prev: {
              zenBrowserTwilight = inputs.zen-browser.packages.${final.stdenv.hostPlatform.system}.twilight;
            })
          ];
        }
      ];
    };
  };
}
