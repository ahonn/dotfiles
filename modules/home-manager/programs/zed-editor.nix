{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.my.zed-editor;
in {
  options.my.zed-editor = {
    enable = mkEnableOption "Zed high-performance code editor";
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
