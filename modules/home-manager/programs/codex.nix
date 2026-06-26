{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.codex;
  dotfilesPath = "${config.home.homeDirectory}/.config/nix-darwin";

  # Surface each Claude skill as a Codex custom prompt: ~/.codex/prompts/<name>.md
  # symlinks to .claude/skills/<name>/SKILL.md, so it is callable as /<name> in Codex.
  skillsSrc = ../../../.claude/skills;
  skillNames = builtins.filter (name: builtins.pathExists (skillsSrc + "/${name}/SKILL.md")) (
    builtins.attrNames (builtins.readDir skillsSrc)
  );
  promptLinks = listToAttrs (
    map (name: {
      name = ".codex/prompts/${name}.md";
      value.source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.claude/skills/${name}/SKILL.md";
    }) skillNames
  );
in
{
  options = {
    my.codex.enable = mkEnableOption "Codex CLI configuration and shared agent skills";
  };

  config = mkIf cfg.enable {
    home.activation.relocateClobberedCodexAgentFiles = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      for f in "$HOME/.codex/AGENTS.md" "$HOME/.codex/config.toml" "$HOME/.codex/skills"; do
        if [ -e "$f" ] && [ ! -L "$f" ]; then
          ts=$(date +%Y%m%d-%H%M%S)
          run mv -v "$f" "$f.pre-rebuild.$ts"
        fi
      done
    '';

    home.file = promptLinks // {
      ".codex/AGENTS.md".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.claude/AGENTS.md";
      ".codex/config.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.codex/config.toml";
      ".codex/skills/".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.claude/skills";
    };
  };
}
