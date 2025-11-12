# Harpoon - Quick file marking
{ ... }:
{
  programs.nvf.settings.vim.navigation.harpoon = {
    enable = true;
    mappings = {
      markFile = "<leader>m";
      listMarks = "<leader>\`";
      file1 = "<leader>1";
      file2 = "<leader>2";
      file3 = "<leader>3";
      file4 = "<leader>4";
    };
  };
}
