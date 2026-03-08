{ ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "tray"
          "cpu"
          "memory"
          "temperature"
          "pulseaudio"
          "network"
          "bluetooth"
          "battery"
        ];

        "hyprland/workspaces" = {
          "sort-by" = "number";
          "on-click" = "activate";
        };

        "hyprland/window" = {
          max-length = 50;
        };

        clock = {
          format = "{:%I:%M %p}";
          format-alt = "{:%A, %B %d, %Y %I:%M %p}";
          tooltip-format = "<tt>{calendar}</tt>";
        };

        cpu = {
          format = " {usage}%";
          interval = 5;
        };

        memory = {
          format = " {percentage}%";
          interval = 5;
        };

        temperature = {
          format = " {temperatureC}°C";
          critical-threshold = 80;
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " muted";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };

        network = {
          format-wifi = " {signalStrength}%";
          format-ethernet = " {ipaddr}";
          format-disconnected = "⚠ disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}\n{essid}";
          on-click = "nm-connection-editor";
        };

        bluetooth = {
          format = " {status}";
          format-connected = " {device_alias}";
          format-disabled = "";
          on-click = "blueman-manager";
        };

        battery = {
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          states = {
            warning = 30;
            critical = 15;
          };
        };

        tray = {
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(26, 27, 38, 0.9);
        color: #a9b1d6;
        border-bottom: 2px solid #292e42;
      }

      #workspaces button {
        padding: 0 8px;
        color: #565f89;
        border-bottom: 2px solid transparent;
      }

      #workspaces button.active {
        color: #7aa2f7;
        border-bottom: 2px solid #7aa2f7;
      }

      #workspaces button:hover {
        background: rgba(122, 162, 247, 0.2);
      }

      #window {
        padding: 0 12px;
        color: #a9b1d6;
      }

      #clock {
        color: #7aa2f7;
        font-weight: bold;
      }

      #cpu,
      #memory,
      #temperature,
      #pulseaudio,
      #network,
      #bluetooth,
      #battery,
      #tray {
        padding: 0 8px;
      }

      #battery.warning {
        color: #e0af68;
      }

      #battery.critical {
        color: #f7768e;
      }

      #temperature.critical {
        color: #f7768e;
      }

      #pulseaudio.muted {
        color: #565f89;
      }

      #network.disconnected {
        color: #f7768e;
      }

      tooltip {
        background-color: #1a1b26;
        border: 1px solid #292e42;
        border-radius: 8px;
      }
    '';
  };
}
