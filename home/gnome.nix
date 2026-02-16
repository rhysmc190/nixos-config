{ pkgs, ... }:
{
  home.packages =
    with pkgs.gnomeExtensions;
    [
      battery-health-charging
      bluetooth-battery-meter
      blur-my-shell
      dash-to-panel
      gsconnect
      media-controls
      tray-icons-reloaded
      user-themes
      vitals
    ]
    ++ [
      pkgs.palenight-theme
    ];

  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  services.mpris-proxy.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      show-battery-percentage = true;
      enable-hot-corners = false;
      edge-tiling = true;
      clock-format = "12h";
      clock-show-weekday = true;
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "com.mitchellh.ghostty.desktop"
      ];
      disable-user-extensions = false;
      enabled-extensions = [
        "Battery-Health-Charging@maniacx.github.com"
        "Bluetooth-Battery-Meter@maniacx.github.com"
        "blur-my-shell@aunetx"
        "dash-to-panel@jderose9.github.com"
        "gsconnect@andyholmes.github.io"
        "mediacontrols@cliffniff.github.com"
        "trayIconsReloaded@selfmade.pl"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "Vitals@CoreCoding.com"
      ];
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "palenight";
    };
    "org/gnome/shell/extensions/dash-to-panel" = {
      intellihide = true;
      intellihide-hide-from-windows = true;
      intellihide-behaviour = "FOCUSED_WINDOWS";
      intellihide-show-in-fullscreen = true;
    };
    "org/gnome/extensions/mediacontrols" = {
      label-width = 0;
    };
    "org/gnome/shell/extensions/Bluetooth-Battery-Meter" = {
      on-hover-delay = 500;
      level-indicator-type = 1;
    };
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
      dynamic-workspaces = false;
      workspaces-only-on-primary = false;
    };
    "org/gtk/settings/file-chooser" = {
      clock-format = "12h";
    };
    "org/gnome/desktop/wm/keybindings" = {
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      switch-to-workspace-1 = [ "<Alt><Super>1" ];
      switch-to-workspace-2 = [ "<Alt><Super>2" ];
      switch-to-workspace-3 = [ "<Alt><Super>3" ];
      switch-to-workspace-4 = [ "<Alt><Super>4" ];
    };
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 4;
    };
  };
}
