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
    nodejs_20
    nodePackages.eas-cli
    python3
    supabase-cli
    watchman
    # also consider: httpie/curlie (friendlier HTTP clients for API testing)
    # also consider: devenv/devbox (per-project services on top of direnv)

    # cli tools
    btop
    duf
    dust
    eza
    fd
    jq
    nix-output-monitor
    pass
    ripgrep
    tldr
    tokei
    yazi
  ];
}
