{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # desktop
    adwaita-icon-theme
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
