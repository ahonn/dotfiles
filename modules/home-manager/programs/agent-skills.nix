{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.agent-skills;
  dotfilesPath = "${config.home.homeDirectory}/.config/nix-darwin";

  # Expose each Claude skill at ~/.agents/skills/<name>, the cross-agent
  # standard directory read by skills.sh-compatible tools (amp, cursor,
  # opencode, ...). Linked per-skill rather than as a whole directory so
  # skills installed there by the skills CLI can coexist.
  skillsSrc = ../../../.claude/skills;
  skillNames = builtins.filter (name: builtins.pathExists (skillsSrc + "/${name}/SKILL.md")) (
    builtins.attrNames (builtins.readDir skillsSrc)
  );
  skillLinks = listToAttrs (
    map (name: {
      name = ".agents/skills/${name}";
      value.source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.claude/skills/${name}";
    }) skillNames
  );
in
{
  options = {
    my.agent-skills.enable = mkEnableOption "Shared skills in ~/.agents/skills for cross-agent CLIs";
  };

  config = mkIf cfg.enable {
    home.file = skillLinks;
  };
}
