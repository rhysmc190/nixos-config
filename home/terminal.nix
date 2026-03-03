{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    enableZshIntegration = true;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      theme = "TokyoNight Storm";
      background-opacity = "0.9";
      background-blur = "true";
      window-decoration = "false";
      keybind = [
        "ctrl+enter=toggle_window_decorations"
        "ctrl+shift+enter=toggle_fullscreen"
      ];
    };
  };

  # Autostart Ghostty with tmux on login.
  # GPG sign triggers pinentry-curses to cache the passphrase before tmux
  # attaches, so direnv+pass in restored panes don't all prompt separately.
  xdg.configFile."autostart/ghostty-tmux.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Ghostty Tmux
    Exec=ghostty -e bash -c 'echo | gpg --sign >/dev/null 2>&1; exec tmux new-session -A'
    X-GNOME-Autostart-enabled=true
  '';
}
