{ pkgs, ... }:
let
  ghosttyStartScript = pkgs.writeShellScript "ghostty-hyprland-start" ''
    export GPG_TTY=$(tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
    echo | gpg --sign >/dev/null 2>&1
    exec tmux new-session -A
  '';
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitors: laptop + external Dell (verify DP name with `hyprctl monitors all`)
      monitor = [
        "eDP-1, 2256x1504@60, 0x0, 1.5"
        "DP-5, 1920x1080@60, 1504x0, 1"
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

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      exec-once = [
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store"
        "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store"
        "variety"
        "ghostty -e ${ghosttyStartScript}"
      ];

      windowrule = [
        "float, class:^(pavucontrol)$"
        "float, class:^(blueman-manager)$"
        "float, class:^(nm-connection-editor)$"
        "float, title:^(Open File)$"
        "float, title:^(Save File)$"
        "float, title:^(Confirm)$"
        "opacity 0.9 0.85, class:^(com.mitchellh.ghostty)$"
      ];

      "$mod" = "SUPER";

      bind = [
        # Window management
        "$mod, Q, killactive"
        "$mod, V, togglefloating"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        "$mod, F, fullscreen"

        # Launch
        "$mod, Return, exec, ghostty"
        "$mod, E, exec, nautilus"
        "$mod, R, exec, wofi --show drun"

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
        "$mod SHIFT, V, exec, ${pkgs.cliphist}/bin/cliphist list | wofi --dmenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"

        # Lock
        "$mod, L, exec, hyprlock"

        # Scroll through workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
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

  # Notifications
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 100;
        offset = "10x10";
        origin = "top-right";
        transparency = 10;
        frame_color = "#7aa2f7";
        font = "JetBrainsMono Nerd Font 10";
        corner_radius = 8;
      };
      urgency_low = {
        background = "#1a1b26";
        foreground = "#a9b1d6";
      };
      urgency_normal = {
        background = "#1a1b26";
        foreground = "#a9b1d6";
      };
      urgency_critical = {
        background = "#1a1b26";
        foreground = "#f7768e";
        frame_color = "#f7768e";
      };
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
