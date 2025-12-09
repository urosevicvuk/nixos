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
          cpp = [ "clang-format" ];
          go = [ "goimports" "gofmt" ];
          rust = [ "rustfmt" ];
          python = [ "black" ];
          javascript = [ "prettier" ];
          typescript = [ "prettier" ];
          javascriptreact = [ "prettier" ];
          typescriptreact = [ "prettier" ];
          json = [ "prettier" ];
          jsonc = [ "prettier" ];
          yaml = [ "prettier" ];
          markdown = [ "prettier" ];
          html = [ "prettier" ];
          css = [ "prettier" ];
          scss = [ "prettier" ];
          sh = [ "shfmt" ];
          bash = [ "shfmt" ];
          lua = [ "stylua" ];
        };
      };
    };
  };
}
