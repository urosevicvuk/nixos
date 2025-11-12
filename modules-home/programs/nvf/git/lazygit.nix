# Lazygit integration via toggleterm
{ ... }:
{
  programs.nvf.settings.vim.terminal.toggleterm = {
    enable = true;
    lazygit = {
      enable = true;
      mappings.open = "<leader>gl";
    };
  };
}
