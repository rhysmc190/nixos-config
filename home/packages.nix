{ pkgs, ... }: {
  home.packages = with pkgs; [
    bat
    caprine-bin
    claude-code
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
    spotify
    supabase-cli
    tree
    variety
    watchman
    zenBrowserTwilight
  ];
}
