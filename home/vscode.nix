{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default = {
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      extensions =
        with pkgs.vscode-extensions;
        [
          bierner.markdown-mermaid
          bradlc.vscode-tailwindcss
          denoland.vscode-deno
          enkia.tokyo-night
          github.copilot
          github.copilot-chat
          github.vscode-github-actions
          golang.go
          grapecity.gc-excelviewer
          jnoortheen.nix-ide
          mechatroner.rainbow-csv
          mkhl.direnv
          ms-azuretools.vscode-containers
          ms-python.python
          ms-vscode.powershell
          tamasfe.even-better-toml
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "vscode-sshfs";
            publisher = "Kelvin";
            version = "1.26.1";
            sha256 = "sha256-WO9vYELNvwmuNeI05sUBE969KAiKYtrJ1fRfdZx3OYU=";
          }
          {
            name = "json-script-tag";
            publisher = "sissel";
            version = "0.3.2";
            sha256 = "sha256-vlZRlhluEBXehXe9pK7iZjzi8a3LZdWBfkOli36C6h4=";
          }
          {
            name = "go-template";
            publisher = "romantomjak";
            version = "0.0.2";
            sha256 = "sha256-mvVimz+rzftSQM09/7L7SCJtJWp/+DR0zaDWSWormAM=";
          }
        ];
      userSettings = {
        "workbench.colorTheme" = "Tokyo Night Storm";
        "editor.minimap.enabled" = false;
        "sshfs.configs" = [
          {
            "name" = "homeserver";
            "host" = "192.168.1.108";
            "root" = "~";
          }
          {
            "name" = "testbench";
            "host" = "192.168.1.102";
            "root" = "~";
          }
        ];
      };
    };
  };
}
