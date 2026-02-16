{ ... }: {
  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      DISK_IDLE_SECS_ON_AC = 0;
    };
  };

  # Still suspend on lid close
  services.logind.settings.Login.HandleLidSwitch = "suspend";

  # Disable auto-suspend system-wide (prevents GNOME from overriding logind settings)
  # Lid close will still trigger suspend, but idle/timeout suspension is disabled
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
}
