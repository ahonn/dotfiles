{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.zed-editor;
in {
  options.services.zed-editor = {
    enable = mkEnableOption "enable";
  };

  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "nvim-nightfox"
      ];
      userSettings = builtins.fromJSON (builtins.readFile ../../../config/zed-editor/settings.json);
      userKeymaps = builtins.fromJSON (builtins.readFile ../../../config/zed-editor/keymaps.json);
    };
  };
}
