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
    services.claude-code.enable = mkEnableOption "Claude Code CLI configuration and settings";
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

    home.file.".claude/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink ../../../config/claude/CLAUDE.md;
    home.file.".claude/commands/".source = config.lib.file.mkOutOfStoreSymlink ../../../config/claude/commands;
    home.file.".claude/agents/".source = config.lib.file.mkOutOfStoreSymlink ../../../config/claude/agents;
  };
}
