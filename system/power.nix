{ ... }:
{
  # PPD is recommended over TLP for AMD 7040 — it integrates with AMD P-State
  # natively and works with GNOME's power profile quick settings
  services.power-profiles-daemon.enable = true;

  # Still suspend on lid close
  services.logind.settings.Login.HandleLidSwitch = "suspend";

  # Disable auto-suspend system-wide (prevents GNOME from overriding logind settings)
  # Lid close will still trigger suspend, but idle/timeout suspension is disabled
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
}
