_: {
  services.printing = {
    enable = true;
    startWhenNeeded = true; # socket-activate instead of starting at boot
  };
}
