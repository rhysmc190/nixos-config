{ pkgs, ... }:
{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
    defaultCacheTtl = 28800;
    maxCacheTtl = 28800;
  };

  # Keygrips for pam-gnupg to unlock at login
  home.file.".pam-gnupg".text = ''
    122409B95A5697F79F4E91B8D85990AE32AAE623
    20C7FEB62D5A257FCE989C83BEDC6E20BA391C5C
  '';
}
