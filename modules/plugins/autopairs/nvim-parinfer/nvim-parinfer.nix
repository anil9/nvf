{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.vim.autopairs.nvim-parinfer;
in {
  options.vim.autopairs.nvim-parinfer = {
    enable = mkEnableOption "nvim-parinfer";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = ["nvim-parinfer"];
  };
}
