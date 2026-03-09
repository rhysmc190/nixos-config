{ pkgs, ... }:
{
  xdg.desktopEntries.google-chrome-incognito = {
    name = "Google Chrome (Incognito)";
    exec = "${pkgs.google-chrome}/bin/google-chrome-stable --incognito %U";
    icon = "google-chrome";
    comment = "Access the Internet in Incognito mode";
    categories = [ "Network" "WebBrowser" ];
  };

  home.packages = with pkgs; [
    # desktop
    gnome-tweaks
    variety
    wl-clipboard

    # hyprland ecosystem
    rofi
    grim
    slurp
    brightnessctl
    playerctl
    cliphist
    blueman
    pavucontrol
    networkmanagerapplet
    polkit_gnome

    # browsers
    firefox
    google-chrome
    zenBrowserTwilight

    # apps
    caprine-bin
    libreoffice-fresh
    obsidian
    xournalpp
    spotify

    # development
    claude-code
    just
    nh
    nodejs_20
    nodePackages.eas-cli
    python3
    supabase-cli
    watchman

    # cli tools
    comma
    btop
    duf
    dust
    eza
    fd
    jq
    pass
    procs
    ripgrep
    tldr
    tokei
    yazi
  ];
}
