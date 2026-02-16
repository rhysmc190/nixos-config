{ ... }:
{
  # fwupd and fstrim are enabled by nixos-hardware
  services.journald.extraConfig = "SystemMaxUse=500M";

  zramSwap.enable = true;
  services.earlyoom.enable = true;
}
