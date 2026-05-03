{ pkgs, ... }: {
  services.printing = {
    enable = true;
    startWhenNeeded = true; # socket-activate instead of starting at boot
    drivers = [ pkgs.gutenprint ]; # Canon PIXMA MG2900 and many others
  };
}
