{ pkgs, lib, ... }:
{
  home.activation.reloadTmux = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if command -v tmux &>/dev/null && tmux list-sessions &>/dev/null 2>&1; then
      tmux source-file ~/.config/tmux/tmux.conf 2>/dev/null || true
    fi
  '';

  programs.tmux = {
    enable = true;
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    terminal = "tmux-256color";
    extraConfig = ''
      set -g renumber-windows on
      set -ag terminal-overrides ",ghostty:RGB"
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
    '';
    plugins = with pkgs.tmuxPlugins; [
      yank
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-capture-pane-contents 'on'";
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10'
        '';
      }
      {
        plugin = tokyo-night-tmux;
        extraConfig = "set -g @tokyo-night-tmux_theme storm";
      }
    ];
  };
}
