{
  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      width = 300;
      border-radius = 8;
      border-size = 2;
      default-timeout = 5000;
      font = "JetBrainsMono Nerd Font 13";
      background-color = "#1a1b26";
      border-color = "#7aa2f7";
      text-color = "#a9b1d6";
      progress-color = "over #292e42";

      "urgency=critical" = {
        default-timeout = 0;
        border-color = "#f7768e";
      };
    };
  };
}
