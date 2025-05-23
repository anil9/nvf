{lib, ...}: let
  inherit (lib.generators) mkLuaInline;
  inherit (lib.options) mkOption mkEnableOption literalMD;
  inherit (lib.types) attrs either nullOr;
  inherit (lib.nvim.lua) toLuaObject;
  inherit (lib.nvim.types) luaInline mkPluginSetupOption;
in {
  options.vim.formatter.conform-nvim = {
    enable = mkEnableOption "lightweight yet powerful formatter plugin for Neovim [conform-nvim]";
    setupOpts = mkPluginSetupOption "conform.nvim" {
      formatters_by_ft = mkOption {
        type = attrs;
        default = {};
        example = {lua = ["stylua"];};
        description = ''
          Map of filetype to formatters. This option takes a set of
          `key = value` format where the `value will` be converted
          to its Lua equivalent. You are responsible for passing the
          correct Nix data types to generate a correct Lua value that
          conform is able to accept.
        '';
      };

      default_format_opts = mkOption {
        type = attrs;
        default = {lsp_format = "fallback";};
        description = "Default values when calling `conform.format()`";
      };

      format_on_save = mkOption {
        type = nullOr (either attrs luaInline);
        default = mkLuaInline ''
          function()
            if not vim.g.formatsave or vim.b.disableFormatSave then
              return
            else
              return {lsp_format = "fallback", timeout_ms = 500}
            end
          end
        '';
        defaultText = literalMD ''
          enabled by default, and respects {option}`vim.lsp.formatOnSave` and
          {option}`vim.lsp.mappings.toggleFormatSave`
        '';
        description = ''
          Attribute set or Lua function that will be passed to
          `conform.format()`. If this is set, Conform will run the formatter
          on save.
        '';
      };

      format_after_save = let
        defaultFormatAfterSaveOpts = {lsp_format = "fallback";};
      in
        mkOption {
          type = nullOr (either attrs luaInline);
          default = mkLuaInline ''
            function()
              if not vim.g.formatsave or vim.b.disableFormatSave then
                return
              else
                return ${toLuaObject defaultFormatAfterSaveOpts}
              end
            end
          '';
          description = ''
            Table or function(luainline) that will be passed to `conform.format()`. If this
            is set, Conform will run the formatter asynchronously after save.
          '';
        };
    };
  };
}
