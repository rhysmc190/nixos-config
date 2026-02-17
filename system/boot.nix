{ pkgs, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "usbcore.autosuspend=-1" ];
    initrd.kernelModules = [ "amdgpu" ];
  };
}
