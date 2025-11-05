{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.my.starship;
in {
  options.my.starship = {
    enable = mkEnableOption "Starship cross-shell prompt";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        docker_context.disabled = true;
        package.disabled = true;
        nix_shell.format = "via [❄️devenv](bold blue) ";
      };
    };
  };
}
