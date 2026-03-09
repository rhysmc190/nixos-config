{ pkgs, lib, ... }:
let
  # Keyboard debounce plugin for interception-tools. Delays key-release events
  # by a configurable window; if a re-press arrives during that window it's
  # treated as chatter and the release is discarded. Works at the evdev level
  # under any compositor. https://github.com/cpphusky/debouncer-udevmon
  debouncer-udevmon = pkgs.rustPlatform.buildRustPackage {
    pname = "debouncer-udevmon";
    version = "0.2.3-unstable-2025-08-18";
    src = pkgs.fetchFromGitHub {
      owner = "cpphusky";
      repo = "debouncer-udevmon";
      rev = "753f660cde1ed7630d84c0d84e9b025a0c9d3be4";
      hash = "sha256-gs/anqSW17KmaIL76KU3Vo4o7pcd3eAG+Wgc4RjxxCI=";
    };
    cargoHash = "sha256-eGP1XpurdY8j/piONvS5w5R3uiDoH2QcISIMB8v8Ya4=";
    LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
    nativeBuildInputs = [
      pkgs.rustPlatform.bindgenHook
      pkgs.pkg-config
    ];
    buildInputs = [ pkgs.openssl ];
  };
  sddm-tokyo-night = pkgs.stdenvNoCC.mkDerivation {
    pname = "sddm-tokyo-night";
    version = "2024-03-06";
    src = pkgs.fetchFromGitHub {
      owner = "siddrs";
      repo = "tokyo-night-sddm";
      rev = "320c8e74ade1e94f640708eee0b9a75a395697c6";
      hash = "sha256-JRVVzyefqR2L3UrEK2iWyhUKfPMUNUnfRZmwdz05wL0=";
    };
    installPhase = ''
      mkdir -p $out/share/sddm/themes/tokyo-night-sddm
      cp -r $src/* $out/share/sddm/themes/tokyo-night-sddm/
    '';
  };
  # Stash the login password so Hyprland can unlock gnome-keyring.
  # Hyprland's exec-once reads this file to unlock the keyring daemon.
  stashGkPassword = pkgs.writeShellScript "stash-gk-password" ''
    umask 0077
    cat > "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/.gk-login"
  '';
in
{
  programs.hyprland.enable = true;

  # Login manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "tokyo-night-sddm";
    extraPackages = [ sddm-tokyo-night ];
    package = pkgs.kdePackages.sddm;
  };

  # Forward login password to gpg-agent so GPG key is unlocked at login
  security.pam.services.sddm.gnupg.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  security.polkit.enable = true;
  security.pam.services.hyprlock = { };

  # Stash the login password for gnome-keyring unlock (see stashGkPassword above)
  security.pam.services.login.rules.session.stash-gk-password = {
    order = 12650; # after gnome_keyring (12600)
    control = "optional";
    modulePath = "${pkgs.pam}/lib/security/pam_exec.so";
    args = [
      "expose_authtok"
      "quiet"
      "${stashGkPassword}"
    ];
  };

  # System-level key debounce via interception-tools
  services.interception-tools = {
    enable = true;
    plugins = [ debouncer-udevmon ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${debouncer-udevmon}/bin/debouncer-udevmon | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [[KEY_RESERVED, KEY_MAX]]
    '';
  };

  # Debouncer config: 30ms delay, exclude modifier keys from debouncing
  environment.etc."debouncer.toml".text = ''
    debounce_time = 30
    exceptions = [29, 42, 54, 56, 97, 100, 125]
  '';
}
