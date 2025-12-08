{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.claude-code;
  dotfilesPath = "${config.home.homeDirectory}/.config/nix-darwin";
in {
  options = {
    my.claude-code.enable = mkEnableOption "Claude Code CLI configuration and settings";
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

    home.file.".claude/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/claude/CLAUDE.md";
    home.file.".claude/commands/".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/claude/commands";
    home.file.".claude/agents/".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/claude/agents";
  };
}
