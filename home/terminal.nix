{ pkgs, ... }:
let
  ghosttyStartScript = pkgs.writeShellScript "ghostty-tmux-start" ''
    # Move cursor to external monitor so Ghostty opens there (GNOME opens
    # windows on the monitor with the cursor). Coordinates target the center
    # of the Dell DP-5 at logical position x=1503, 1920x1080.
    ${pkgs.ydotool}/bin/ydotool mousemove --absolute -- 2463 540

    exec ghostty -e bash -c 'export GPG_TTY=$(tty); gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1; echo | gpg --sign >/dev/null 2>&1; exec tmux new-session -A'
  '';
in
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
  # Wrapper script moves cursor to external monitor before launching Ghostty.
  xdg.configFile."autostart/ghostty-tmux.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Ghostty Tmux
    Exec=${ghosttyStartScript}
    X-GNOME-Autostart-enabled=true
    X-GNOME-Autostart-Delay=0
  '';
}
