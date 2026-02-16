_:
{
  # PPD is recommended over TLP for AMD 7040 — it integrates with AMD P-State
  # natively and works with GNOME's power profile quick settings
  services.power-profiles-daemon.enable = true;

  # Suspend on lid close
  services.logind.settings.Login.HandleLidSwitch = "suspend";

  # Disable hibernate (not configured with swap)
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
}
