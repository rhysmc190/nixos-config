{ pkgs, ... }:
let
  claudeIcon = pkgs.fetchurl {
    url = "https://claude.ai/apple-touch-icon.png";
    hash = "sha256-3MWCcZIHUEQa/UICaARa3bWT7gHmi04FoT9++s5+ZdM=";
  };
  spacemailIcon = pkgs.fetchurl {
    url = "https://spaceship-cdn.com/static/spacemail/favicon/apple-touch-icon.png";
    hash = "sha256-UFVqXaNbYPUcUkz7qWQJbZvUmChvcZ0vAVrAGawpn9s=";
  };
in
{
  xdg.desktopEntries.google-chrome-incognito = {
    name = "Google Chrome (Incognito)";
    exec = "${pkgs.google-chrome}/bin/google-chrome-stable --incognito %U";
    icon = "google-chrome";
    comment = "Access the Internet in Incognito mode";
    categories = [
      "Network"
      "WebBrowser"
    ];
  };

  xdg.desktopEntries.claude = {
    name = "Claude";
    exec = "${pkgs.google-chrome}/bin/google-chrome-stable --app=https://claude.ai";
    icon = "${claudeIcon}";
    comment = "Claude web app";
    categories = [ "Network" ];
  };

  xdg.desktopEntries.whatsapp = {
    name = "WhatsApp";
    exec = "${pkgs.google-chrome}/bin/google-chrome-stable --app=https://web.whatsapp.com";
    icon = "whatsapp";
    comment = "WhatsApp Web app";
    categories = [
      "Network"
      "Chat"
    ];
  };

  xdg.desktopEntries.gmail = {
    name = "Gmail";
    exec = "${pkgs.google-chrome}/bin/google-chrome-stable --app=https://mail.google.com";
    icon = "gmail";
    comment = "Gmail web app";
    categories = [ "Network" "Email" ];
  };

  xdg.desktopEntries.protonmail = {
    name = "ProtonMail";
    exec = "${pkgs.google-chrome}/bin/google-chrome-stable --app=https://mail.proton.me";
    icon = "proton-mail";
    comment = "ProtonMail web app";
    categories = [ "Network" "Email" ];
  };

  xdg.desktopEntries.spacemail = {
    name = "Spacemail";
    exec = "${pkgs.google-chrome}/bin/google-chrome-stable --app=https://spacemail.com/mail";
    icon = "${spacemailIcon}";
    comment = "Spacemail web app";
    categories = [ "Network" "Email" ];
  };

  xdg.desktopEntries.github = {
    name = "GitHub";
    exec = "${pkgs.google-chrome}/bin/google-chrome-stable --app=https://github.com";
    icon = "github";
    comment = "GitHub web app";
    categories = [ "Network" "Development" ];
  };

  xdg.desktopEntries.mail = {
    name = "Mail";
    exec = "${pkgs.google-chrome}/bin/google-chrome-stable --new-window https://mail.google.com https://mail.proton.me https://spacemail.com/mail";
    icon = "internet-mail";
    comment = "All mail clients";
    categories = [ "Network" "Email" ];
  };

  home.packages = with pkgs; [
    # desktop
    thunar
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
    eas-cli
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
