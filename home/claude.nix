{ config, pkgs, ... }:
let
  ccusage = pkgs.writeShellScriptBin "ccusage" ''
    exec ${pkgs.nodePackages.pnpm}/bin/pnpm dlx ccusage "$@"
  '';

  agentStateCmd =
    state:
    "[ -n \"$TMUX_AGENT_INDICATOR_DIR\" ] && \"$TMUX_AGENT_INDICATOR_DIR/scripts/agent-state.sh\" --agent claude --state ${state}";

  hooksFile = pkgs.writeText "claude-hooks.json" (
    builtins.toJSON {
      UserPromptSubmit = [
        {
          matcher = "";
          hooks = [
            {
              type = "command";
              command = agentStateCmd "off";
            }
          ];
        }
        {
          matcher = "";
          hooks = [
            {
              type = "command";
              command = agentStateCmd "running";
            }
          ];
        }
      ];
      PermissionRequest = [
        {
          matcher = "";
          hooks = [
            {
              type = "command";
              command = agentStateCmd "needs-input";
            }
          ];
        }
      ];
      Stop = [
        {
          hooks = [
            {
              type = "command";
              command = agentStateCmd "done";
            }
          ];
        }
      ];
    }
  );

  mergeHooksScript = pkgs.writeShellScript "merge-claude-hooks" ''
    SETTINGS="$1"
    mkdir -p "$(dirname "$SETTINGS")"
    if [ -f "$SETTINGS" ]; then
      ${pkgs.jq}/bin/jq --argjson hooks "$(cat ${hooksFile})" '.hooks = $hooks' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
    else
      ${pkgs.jq}/bin/jq -n --argjson hooks "$(cat ${hooksFile})" '{hooks: $hooks}' > "$SETTINGS"
    fi
  '';
in
{
  home.packages = [ ccusage ];

  home.file.".claude/statusline.sh" = {
    source = ../files/statusline.sh;
    executable = true;
  };

  # Merge tmux-agent-indicator hooks into Claude Code settings
  # NOTE: This replaces the entire "hooks" key in settings.json on every rebuild.
  # All Claude Code hooks should be declared in hooksFile above, not added manually.
  home.activation.claudeCodeHooks = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${mergeHooksScript} "$HOME/.claude/settings.json"
  '';

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
