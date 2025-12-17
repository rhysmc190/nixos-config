{ config, pkgs, ... }:

let
  # Custom wrapper for ccusage (Claude Code usage tracker)
  # Uses pnpm dlx to run ccusage - downloads are cached in ~/.pnpm-store
  ccusage = pkgs.writeShellScriptBin "ccusage" ''
    exec ${pkgs.nodePackages.pnpm}/bin/pnpm dlx ccusage "$@"
  '';
in
{
  # TODO please change the username & home directory to your own
  home.username = "rhys";
  home.homeDirectory = "/home/rhys";

  # Link Claude Code statusline script
  home.file.".claude/statusline.sh" = {
    source = ../files/statusline.sh;
    executable = true;
  };

  services.mpris-proxy.enable = true;

  # Packages that should be installed to the user profile.
  home.packages = [
    ccusage  # Custom ccusage package defined above
  ] ++ (with pkgs; [
    #android-sdk
    #android-tools
    caprine-bin
    claude-code
    firefox
    google-chrome
    libreoffice
    nodejs_20
    nodePackages.eas-cli
    palenight-theme
    pass
    python3
    spotify
    supabase-cli
    watchman
    zenBrowserTwilight
  ]) ++ (with pkgs.gnomeExtensions; [
    bluetooth-battery-meter
    blur-my-shell
    dash-to-panel
    gsconnect
    media-controls
    tray-icons-reloaded
    user-themes
    vitals
  ]);
  
  programs.bash = {
    enable = true;
    bashrcExtra = "eval \"$(direnv hook bash)\"";
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "rhysmc190";
        email = "rhysmc190@gmail.com";
      };
      alias = {
        ac = "!git add -A && git commit -m";
      };
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
      push = { autoSetupRemote = true; };
    };
  };

  programs.gnome-shell = {
    enable = true;
    extensions = [{ package = pkgs.gnomeExtensions.gsconnect; }];
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentry = {
      package = pkgs.pinentry-gnome3;
    };
  };
  
  # https://github.com/K1aymore/Nixos-Config/blob/master/packages/coding.nix
	# https://github.com/thomashoneyman/.dotfiles/blob/69d61ae8650f12f123d375534714c78a3095fb0e/modules/programs/default.nix
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default = {
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        bierner.markdown-mermaid
        bradlc.vscode-tailwindcss
        denoland.vscode-deno
        dracula-theme.theme-dracula
        github.copilot
        github.copilot-chat
        github.vscode-github-actions
        golang.go
        grapecity.gc-excelviewer
        jnoortheen.nix-ide
        mechatroner.rainbow-csv
        mkhl.direnv
        ms-azuretools.vscode-containers
        ms-python.python
        ms-vscode.powershell
        tamasfe.even-better-toml
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vscode-sshfs";
        publisher = "Kelvin";
        version = "1.26.1";
        sha256 = "sha256-WO9vYELNvwmuNeI05sUBE969KAiKYtrJ1fRfdZx3OYU=";
      }
      {
        name = "json-script-tag";
        publisher = "sissel";
        version = "0.3.2";
        sha256 = "sha256-vlZRlhluEBXehXe9pK7iZjzi8a3LZdWBfkOli36C6h4=";
      }
      {
        name = "go-template";
        publisher = "romantomjak";
        version = "0.0.2";
        sha256 = "sha256-mvVimz+rzftSQM09/7L7SCJtJWp/+DR0zaDWSWormAM=";
      }
      {
        name = "claude-code";
        publisher = "anthropic";
        version = "2.0.58";
        sha256 = "sha256-Ah3/N1nUgZQZn572zUPI4cn8r3x08x3Zz3Au1W/2Y5U=";
      }
      ];
      userSettings = {
        "editor.minimap.enabled" = false;
        "editor.codeActionsOnSave" = {
          # "source.organizeImports"= "explicit";
        };
        # "nix.enableLanguageServer" = true;
        # "nix.serverPath" = "nil";
        # "nix.formatterPath" = "nixpkgs-fmt";
        # "nix.serverSettings" = {
        #   "nil" = {
        #     "formatting" = { "command" = [ "nixpkgs-fmt" ]; };
        #   };
        # };
        "sshfs.configs" = [
          {
            "name" = "homeserver";
            "host" = "192.168.1.108";
            "root" = "~";
          }
          {
            "name" = "testbench";
            "host" = "192.168.1.107"; ###should be.102
            "root" = "~";
          }
        ];
      };
    };
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = false;
    };
  };

  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

# run `dconf watch /` to watch for changes made in the ui, then add the changes here
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
        "firefox.desktop"
        "org.gnome.Console.desktop"
      ];
      disable-user-extensions = false;

      enabled-extensions = [
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
      # enables fractional scaling, but:
      # have to manually set scaling factor in settings gui, no way to set it here yet
      experimental-features = [ "scale-monitor-framebuffer" ];
      dynamic-workspaces = false;
      workspaces-only-on-primary = false;
    };
    "org/gtk/settings/file-chooser" = {
      clock-format = "12h";
    };
    "org/gnome/desktop/wm/keybindings" = {
      move-to-workspace-1 = ["<Shift><Super>1"];
      move-to-workspace-2 = ["<Shift><Super>2"];
      move-to-workspace-3 = ["<Shift><Super>3"];
      move-to-workspace-4 = ["<Shift><Super>4"];
      switch-to-workspace-1 = ["<Alt><Super>1"];
      switch-to-workspace-2 = ["<Alt><Super>2"];
      switch-to-workspace-3 = ["<Alt><Super>3"];
      switch-to-workspace-4 = ["<Alt><Super>4"];
    };
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 4;
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
