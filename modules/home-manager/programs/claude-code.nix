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

  statuslineScript = pkgs.writeShellScriptBin "claude-statusline" ''
    input=$(cat)

    RESET=$'\033[0m'
    CYAN=$'\033[1;36m'
    GREEN=$'\033[32m'
    MAGENTA=$'\033[35m'
    YELLOW=$'\033[33m'
    RED=$'\033[31m'
    DIM=$'\033[90m'

    MODEL=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.model.display_name')
    DIR=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.workspace.current_dir' | xargs basename)
    CONTEXT=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.context_window.used_percentage // 0' | cut -d'.' -f1)

    if [ "$CONTEXT" -lt 50 ]; then
      CTX_COLOR=$GREEN
    elif [ "$CONTEXT" -lt 80 ]; then
      CTX_COLOR=$YELLOW
    else
      CTX_COLOR=$RED
    fi

    BRANCH=""
    if ${pkgs.git}/bin/git rev-parse --git-dir > /dev/null 2>&1; then
      BRANCH=$(${pkgs.git}/bin/git branch --show-current 2>/dev/null)
      [ -n "$BRANCH" ] && BRANCH=" $DIM|$RESET $MAGENTA$BRANCH$RESET"
    fi

    echo "$DIM[$RESET$CYAN$MODEL$RESET$DIM]$RESET $GREEN$DIR$RESET$BRANCH $DIM|$RESET $CTX_COLOR$CONTEXT%$RESET"
  '';
in {
  options = {
    my.claude-code.enable = mkEnableOption "Claude Code CLI configuration and settings";
  };

  config = mkIf cfg.enable {
    home.packages = [ statuslineScript ];

    home.file.".claude/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.claude/settings.json";
    home.file.".claude/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.claude/CLAUDE.md";
    home.file.".claude/commands/".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.claude/commands";
    home.file.".claude/agents/".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.claude/agents";
    home.file.".claude/skills/".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.claude/skills";
  };
}
