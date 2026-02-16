{ ... }: {
  services.ollama = {
    enable = true;
    loadModels = [ "deepseek-r1:14b" ];
  };
}
