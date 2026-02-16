{ pkgs, ... }:
{
  # Requires nixos-hardware framework-13-7040-amd module (loaded in flake.nix)

  # Thunderbolt device management
  services.hardware.bolt.enable = true;

  # Custom fan curves for quieter operation
  hardware.fw-fanctrl = {
    enable = true;
    config.defaultStrategy = "lazy";
    config.strategies.lazy = {
      fanSpeedUpdateFrequency = 5;
      movingAverageInterval = 30;
      speedCurve = [
        {
          temp = 0;
          speed = 0;
        }
        {
          temp = 50;
          speed = 0;
        }
        {
          temp = 65;
          speed = 25;
        }
        {
          temp = 75;
          speed = 50;
        }
        {
          temp = 85;
          speed = 75;
        }
        {
          temp = 90;
          speed = 100;
        }
      ];
    };
  };

  environment.systemPackages = [ pkgs.fw-ectool ];
}
