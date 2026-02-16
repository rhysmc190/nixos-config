{ config, pkgs, ... }:
let
  ccusage = pkgs.writeShellScriptBin "ccusage" ''
    exec ${pkgs.nodePackages.pnpm}/bin/pnpm dlx ccusage "$@"
  '';
in
{
  home.packages = [ ccusage ];

  home.file.".claude/statusline.sh" = {
    source = ../files/statusline.sh;
    executable = true;
  };

  # Fix Claude Code chrome-native-host shebang for NixOS
  # The generated script uses #!/bin/bash which doesn't exist on NixOS
  home.activation.fixClaudeCodeChromeNativeHost = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    NATIVE_HOST="$HOME/.claude/chrome/chrome-native-host"
    if [ -f "$NATIVE_HOST" ]; then
      $DRY_RUN_CMD ${pkgs.gnused}/bin/sed -i '1s|^#!/bin/bash|#!/usr/bin/env bash|' "$NATIVE_HOST"
      echo "Fixed Claude Code chrome-native-host shebang"
    fi
  '';
}
