{ pkgs, lib, ... }:
let
  tmux-agent-indicator = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "agent-indicator";
    version = "unstable-2025-05-30";
    rtpFilePath = "agent-indicator.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "accessd";
      repo = "tmux-agent-indicator";
      rev = "4d303bf0a75e970c49613b97d646ee3c23eb52cd";
      hash = "sha256-XHV4PEWnzwUkDTgDsSJJu5rrcz/4O6YFCJH4ekl4dCQ=";
    };
    postPatch = ''
      substituteInPlace scripts/agent-state.sh scripts/pane-focus-in.sh \
        --replace-fail '| rg "' '| ${pkgs.ripgrep}/bin/rg "'
    '';
  };
in
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
      set -ag terminal-overrides ",xterm-ghostty:RGB"
      set -s extended-keys always
      set -as terminal-features 'xterm-ghostty:extkeys'
      set -s extended-keys-format csi-u
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
    '';
    plugins = with pkgs.tmuxPlugins; [
      yank
      tmux-thumbs
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-processes '"claude->TERM_PROGRAM=ghostty claude --dangerously-skip-permissions --continue" nvim'
        '';
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
      {
        plugin = tmux-agent-indicator;
        extraConfig = ''
          set -g @agent-indicator-border-enabled 'off'
          set -g @agent-indicator-background-enabled 'off'
          set -g @agent-indicator-needs-input-window-title-bg '#e0af68'
          set -g @agent-indicator-needs-input-window-title-fg '#24283b'
          set -g @agent-indicator-done-window-title-bg '#73daca'
          set -g @agent-indicator-done-window-title-fg '#24283b'
          set -g @agent-indicator-indicator-enabled 'on'
          set -g @agent-indicator-notification-enabled 'on'
          set -g @agent-indicator-animation-enabled 'off'
          set -ga status-right ' #{agent_indicator}'
        '';
      }
    ];
  };
}
