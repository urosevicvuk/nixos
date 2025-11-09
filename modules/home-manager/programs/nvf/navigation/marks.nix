# Harpoon - Quick file marking
{ ... }:
{
  programs.nvf.settings.vim.navigation.harpoon = {
    enable = true;
    mappings = {
      markFile = "<M-`>";
      listMarks = "<M-~>";
      file1 = "<M-1>";
      file2 = "<M-2>";
      file3 = "<M-3>";
      file4 = "<M-4>";
    };
  };
}
