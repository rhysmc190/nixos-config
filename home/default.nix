{ inputs, settings, ... }:
{
  config = {
    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs settings; };
      sharedModules = [
        inputs.nixvim.homeModules.nixvim
      ];
      users.${settings.username} = {
        imports = [
          ./packages.nix
          ./shell.nix
          ./git.nix
          ./tmux.nix
          ./terminal.nix
          ./vscode.nix
          ./gnome.nix
          ./neovim.nix
          ./gpg.nix
          ./virtualisation.nix
          ./claude.nix
        ];

        home = {
          username = settings.username;
          homeDirectory = "/home/${settings.username}";
          stateVersion = "23.11";
        };

        programs.home-manager.enable = true;
      };
    };
  };
}
