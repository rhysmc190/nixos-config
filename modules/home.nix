{ config, pkgs, ... }:

{
  # TODO please change the username & home directory to your own
  home.username = "rhys";
  home.homeDirectory = "/home/rhys";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # Packages that should be installed to the user profile.
  home.packages = (with pkgs; [
    #android-sdk
    #android-tools
    caprine-bin
    firebase-tools
    firefox
    google-chrome
    nodejs_20
    nodePackages.eas-cli
    palenight-theme
    python3
    spotify
    watchman
  ]) ++ (with pkgs.gnomeExtensions; [
    blur-my-shell
    dash-to-panel
    gsconnect
    tray-icons-reloaded
    user-themes
    vitals
  ]);
  
  programs.bash.enable = true;

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName  = "rhysmc190";
    userEmail = "rhysmc190@gmail.com";
    aliases = {
      ac = "!git add -A && git commit -m";
    };
    extraConfig = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
			push = { autoSetupRemote = true; };
    };
  };
  
  # https://github.com/K1aymore/Nixos-Config/blob/master/packages/coding.nix
	# https://github.com/thomashoneyman/.dotfiles/blob/69d61ae8650f12f123d375534714c78a3095fb0e/modules/programs/default.nix
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      ms-python.python
      jnoortheen.nix-ide
    ];
    userSettings = {
      "editor.minimap.enabled" = false;
      "editor.codeActionsOnSave"= {
        # "source.organizeImports"= "explicit";
      };
      "nix.enableLanguageServer" = false;
      # "nix.serverPath" = "nil";
      # "nix.formatterPath" = "nixpkgs-fmt";
      # "nix.serverSettings" = {
      #   "nil" = {
      #     "formatting" = { "command" = [ "nixpkgs-fmt" ]; };
      #   };
      # };
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
      line_break.disabled = true;
    };
  };

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
        "blur-my-shell@aunetx"
        "dash-to-panel@jderose9.github.com"
        "gsconnect@andyholmes.github.io"
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
    "org/gnome/mutter" = {
      # enables fractional scaling, but:
      # have to manually set scaling factor in settings gui, no way to set it here yet
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
    "org/gtk/settings/file-chooser" = {
      clock-format = "12h";
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
