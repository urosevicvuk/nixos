# Code formatting
{ ... }:
{
  programs.nvf.settings.vim.formatter = {
    conform-nvim = {
      enable = true;
      setupOpts = {
        formatters_by_ft = {
          nix = [ "nixfmt" ];
          c = [ "clang-format" ];
        };
      };
    };
  };
}
