{ pkgs, ... }:
let
  ghosttyStartScript = pkgs.writeShellScript "ghostty-hyprland-start" ''
    export GPG_TTY=$(tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
    exec tmux new-session -A
  '';
  powerMenu = pkgs.writeShellScript "power-menu" ''
    choice=$(printf "Lock\nLogout\nSuspend\nReboot\nShutdown" | rofi -dmenu -display-drun "" -theme ~/.config/rofi/tokyo-night.rasi -p "Power")
    case "$choice" in
      Lock) hyprlock ;;
      Logout) hyprctl dispatch exit ;;
      Suspend) systemctl suspend ;;
      Reboot) systemctl reboot ;;
      Shutdown) systemctl poweroff ;;
    esac
  '';
  unlockKeyring = pkgs.writeShellScript "unlock-gnome-keyring" ''
    PW="$XDG_RUNTIME_DIR/.gk-login"
    if [ -f "$PW" ]; then
      gnome-keyring-daemon --start --components=secrets
      gnome-keyring-daemon --unlock < "$PW"
      rm -f "$PW"
    fi
  '';
  setWallpaperScript = pkgs.writeShellScript "set-wallpaper" ''
    WP="$1"
    hyprctl hyprpaper preload "$WP"
    hyprctl hyprpaper wallpaper ",$WP"
    hyprctl hyprpaper unload all
  '';
  systemMenu = pkgs.writeShellScript "system-menu" ''
    wifi=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2)
    wifi="''${wifi:-Disconnected}"

    bt=$(bluetoothctl info 2>/dev/null | grep "Name:" | cut -d' ' -f2-)
    bt="''${bt:-No device}"

    vol=$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{printf "%.0f%%", $2*100}')
    vol="''${vol:-unknown}"

    bri=$(${pkgs.brightnessctl}/bin/brightnessctl info 2>/dev/null | grep -oP '\d+%')
    bri="''${bri:-unknown}"

    vpn_status="Off"
    if tailscale status 2>/dev/null | head -1 | grep -qv "stopped"; then
      vpn_status="On"
    fi

    choice=$(printf "WiFi: $wifi\nBluetooth: $bt\nVolume: $vol\nBrightness: $bri\nVPN: $vpn_status\nLock\nPower" | rofi -dmenu -theme ~/.config/rofi/tokyo-night.rasi -p "System")

    case "$choice" in
      WiFi*) nm-connection-editor ;;
      Bluetooth*) blueman-manager ;;
      Volume*) pavucontrol ;;
      Brightness*)
        level=$(printf "100%%\n75%%\n50%%\n25%%\n10%%" | rofi -dmenu -theme ~/.config/rofi/tokyo-night.rasi -p "Brightness")
        [ -n "$level" ] && ${pkgs.brightnessctl}/bin/brightnessctl set "$level"
        ;;
      VPN*)
        if [ "$vpn_status" = "Off" ]; then
          pkexec tailscale up
        else
          pkexec tailscale down
        fi
        ;;
      Lock) hyprlock ;;
      Power*) ${powerMenu} ;;
    esac
  '';
  keybindViewer = pkgs.writeShellScript "keybind-viewer" ''
    hyprctl binds -j | ${pkgs.jq}/bin/jq -r '
      def decode_mod:
        . as $m |
        (if ($m / 64 | floor) % 2 == 1 then "Super+" else "" end) +
        (if ($m / 8 | floor) % 2 == 1 then "Alt+" else "" end) +
        (if ($m / 4 | floor) % 2 == 1 then "Ctrl+" else "" end) +
        (if ($m % 2) == 1 then "Shift+" else "" end);
      .[] |
      (.modmask | decode_mod) as $mods |
      ($mods + .key) as $combo |
      if .description != "" then
        $combo + " \u2192 " + .description
      elif .dispatcher == "exec" then
        ($combo + " \u2192 " + (.arg | split("/") | last | split(" ") | first))
      else
        $combo + " \u2192 " + .dispatcher + " " + .arg
      end
    ' | sort | rofi -dmenu -i -theme ~/.config/rofi/tokyo-night.rasi -p "Keybindings"
  '';
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitors: laptop + external Dell (verify DP name with `hyprctl monitors all`)
      monitor = [
        "eDP-1, 2256x1504@60, 1920x0, 1.57"
        "desc:Dell Inc. DELL P2719H 5R0DVS2, 1920x1080@60, 0x0, 1"
        ", preferred, auto, 1" # fallback for any other monitor
      ];

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = "rgb(7aa2f7) rgb(bb9af7) 45deg";
        "col.inactive_border" = "rgb(292e42)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 6;
          passes = 3;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      input = {
        kb_layout = "us";
        touchpad = {
          natural_scroll = true;
          "tap-to-click" = true;
          drag_lock = true;
          disable_while_typing = true;
        };
      };

      gesture = [
        "3, horizontal, workspace,"
      ];

      env = [
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_QPA_PLATFORMTHEME,adwaita"
        "QT_STYLE_OVERRIDE,adwaita-dark"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "GDK_BACKEND,wayland,x11,*"
      ];

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      exec-once = [
        "${unlockKeyring}"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store"
        "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store"
        "install -Dm755 ${setWallpaperScript} ~/.config/variety/scripts/set_wallpaper && variety"
        "ghostty -e ${ghosttyStartScript}"
      ];

      windowrule = [
        "float true, match:class ^(pavucontrol)$"
        "float true, match:class ^(blueman-manager)$"
        "float true, match:class ^(nm-connection-editor)$"
        "float true, match:title ^(Open File)$"
        "float true, match:title ^(Save File)$"
        "float true, match:title ^(Confirm)$"
        "opacity 0.9 0.85, match:class ^(com.mitchellh.ghostty)$"
        "no_blur true, match:class ^(com.mitchellh.ghostty)$"
        "monitor desc:Dell Inc. DELL P2719H 5R0DVS2, match:class ^(com.mitchellh.ghostty)$"
      ];

      "$mod" = "SUPER";

      bind = [
        # Window management
        "$mod, Q, killactive"
        "$mod, T, togglefloating"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        "$mod, F, fullscreen"

        # Launch
        "$mod, Return, exec, ghostty"
        "$mod, E, exec, thunar"
        "$mod, R, exec, rofi -show drun -display-drun \"\" -show-icons -theme ~/.config/rofi/tokyo-night.rasi"
        "$mod, space, exec, rofi -show drun -display-drun \"\" -show-icons -theme ~/.config/rofi/tokyo-night.rasi"

        # Focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Move window
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Scratchpad
        "$mod, grave, togglespecialworkspace, magic"
        "$mod SHIFT, grave, movetoworkspace, special:magic"

        # Screenshot
        "$mod, S, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy"
        "$mod SHIFT, S, exec, ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy"

        # Clipboard history
        "$mod SHIFT, V, exec, ${pkgs.cliphist}/bin/cliphist list | rofi -dmenu -theme ~/.config/rofi/tokyo-night.rasi | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"

        # Lock & power
        "$mod, L, exec, hyprlock"
        "$mod SHIFT, L, exec, ${powerMenu}"

        # Scroll through workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      # Binds with descriptions (visible in Super+K viewer)
      bindd = [
        # Clipboard (Omarchy-style: sendshortcut with Ctrl/Shift+Insert)
        "$mod, C, Copy, sendshortcut, CTRL, Insert,"
        "$mod, V, Paste, sendshortcut, SHIFT, Insert,"
        "$mod, X, Cut, sendshortcut, CTRL, X,"
        "$mod CTRL, V, Clipboard history, exec, ${pkgs.cliphist}/bin/cliphist list | rofi -dmenu -theme ~/.config/rofi/tokyo-night.rasi | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"

        # Notifications (mako)
        "$mod, N, Dismiss notification, exec, makoctl dismiss"
        "$mod SHIFT, N, Dismiss all notifications, exec, makoctl dismiss --all"

        # System
        "$mod ALT, space, System menu, exec, ${systemMenu}"
        "$mod, K, Keybinding viewer, exec, ${keybindViewer}"
      ];

      # Repeatable binds for volume/brightness
      bindel = [
        ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
      ];

      # Binds that work on lock screen
      bindl = [
        ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
        ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
      ];

      # Mouse binds
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  # Night light
  services.gammastep = {
    enable = true;
    latitude = -33.87;
    longitude = 151.21;
    temperature = {
      day = 6500;
      night = 4000;
    };
  };

  # Idle management
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  # Cursor
  home.pointerCursor = {
    name = "Simp1e-Tokyo-Night-Storm";
    package = pkgs.simp1e-cursors;
    size = 24;
    gtk.enable = true;
  };

  # Wallpaper — hyprpaper sets wallpapers, variety triggers changes via script
  services.hyprpaper = {
    enable = true;
    settings.splash = false;
  };

  xdg.configFile."rofi/tokyo-night.rasi".source = ../files/rofi-tokyo-night.rasi;

  # Lock screen
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 5;
        hide_cursor = true;
      };
      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];
      fingerprint = {
        enabled = true;
        ready_message = "(Scan fingerprint to unlock)";
        present_message = "Scanning...";
      };
      input-field = [
        {
          monitor = "";
          size = "200, 50";
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.3;
          outer_color = "rgb(7aa2f7)";
          inner_color = "rgb(1a1b26)";
          font_color = "rgb(a9b1d6)";
          fade_on_empty = true;
          placeholder_text = "";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
