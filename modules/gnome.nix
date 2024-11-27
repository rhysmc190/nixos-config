{ pkgs, ... }: {
  config = {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager = {
        gnome.enable = true;
        xterm.enable = false;
      };
      excludePackages = [ pkgs.xterm ];
    };
    environment.gnome.excludePackages = (with pkgs; [
      atomix # puzzle game
      cheese # webcam tool
      epiphany # web browser
      geary # email reader
      gnome-characters
      gnome-contacts
      gnome-initial-setup
      gnome-music
      gnome-photos
      gnome-tour
      hitori # sudoku game
      iagno # go game
      simple-scan # Document Scanner
      tali # poker game
      yelp # Help view
    ]) ++ (with pkgs.gnome; [
      #gedit # text editor
    ]);
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [
      gnome-tweaks
    ];
  };
}

