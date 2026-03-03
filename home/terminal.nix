{ pkgs, ... }:
let
  ghosttyStartScript = pkgs.writeShellScript "ghostty-tmux-start" ''
    # Move Ghostty to second monitor after it opens
    (
      sleep 1.5
      ${pkgs.glib}/bin/gdbus call --session \
        -d org.gnome.Shell -o /org/gnome/Shell \
        -m org.gnome.Shell.Eval \
        "let w = global.get_window_actors().find(a => a.meta_window.get_wm_class() === 'com.mitchellh.ghostty'); if (w) w.meta_window.move_to_monitor(1);" \
        >/dev/null 2>&1
    ) &

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
  # Wrapper script moves window to second monitor via GNOME Shell eval.
  # Delay gives GNOME extensions time to load and hide the Activities overview.
  xdg.configFile."autostart/ghostty-tmux.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Ghostty Tmux
    Exec=${ghosttyStartScript}
    X-GNOME-Autostart-enabled=true
    X-GNOME-Autostart-Delay=1
  '';
}
