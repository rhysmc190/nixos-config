{ pkgs, ... }: {
  home.packages = with pkgs; [
    bat
    caprine-bin
    claude-code
    eza
    fd
    firefox
    google-chrome
    htop
    jq
    libreoffice
    nodejs_20
    nodePackages.eas-cli
    obsidian
    pass
    python3
    ripgrep
    spotify
    supabase-cli
    tree
    variety
    watchman
    wl-clipboard
    zenBrowserTwilight
  ];
}
