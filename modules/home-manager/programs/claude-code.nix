{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.claude-code;
in {
  options = {
    services.claude-code.enable = mkEnableOption "claude-code configuration";
  };

  config = mkIf cfg.enable {
    # Claude Code user settings
    home.file.".claude/settings.json" = {
      text = builtins.toJSON {
        "includeCoAuthoredBy" = false;
        "env" = {
          "CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR" = "1";
        };
        "permissions" = {
          "defaultMode" = "bypassPermissions";
        };
      };
    };
  };
}
