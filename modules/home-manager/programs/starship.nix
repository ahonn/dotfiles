{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.starship;
in {
  options.services.starship = {
    enable = mkEnableOption "enable";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        docker_context.disabled = true;
        package.disabled = true;
        nix_shell.format = "via [❄️ devbox](bold blue) ";
      };
    };
  };
}
