# Treesitter - Syntax highlighting and parsing
{ ... }:
{
  programs.nvf.settings.vim.treesitter = {
    enable = true;
    autotagHtml = true;
    context = {
      enable = false;
      setupOpts = {
        line_number = true;
        max_lines = 3;
      };
    };
    highlight.enable = true;
  };
}
