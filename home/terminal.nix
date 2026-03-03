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
      keybind = [
        "ctrl+enter=toggle_window_decorations"
        "ctrl+shift+enter=toggle_fullscreen"
      ];
    };
  };
}
