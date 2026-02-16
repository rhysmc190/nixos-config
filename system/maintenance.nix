{ ... }:
{
  services.fwupd.enable = true;
  services.fstrim.enable = true;
  services.journald.extraConfig = "SystemMaxUse=500M";
}
