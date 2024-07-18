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
      cheese # webcam tool
      epiphany # web browser
      geary # email reader
      gnome-photos
      gnome-tour
      simple-scan # Document Scanner
      yelp # Help view
    ]) ++ (with pkgs.gnome; [
      gnome-music
      #gedit # text editor
      gnome-characters
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      gnome-contacts
      gnome-initial-setup
      gnome-weather
    ]);
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [
      gnome-tweaks
    ];
  };
}

