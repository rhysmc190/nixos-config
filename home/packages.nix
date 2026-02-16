{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # desktop
    adwaita-icon-theme
    gnome-tweaks
    variety
    wl-clipboard

    # browsers
    firefox
    google-chrome
    zenBrowserTwilight

    # apps
    caprine-bin
    libreoffice
    obsidian
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
