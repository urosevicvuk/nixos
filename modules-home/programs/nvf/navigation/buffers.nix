# Buffer management keybinds
{ ... }:
{
  programs.nvf.settings.vim.keymaps = [
    # Delete buffers (using Snacks bufdelete for better handling)
    {
      key = "<leader>bd";
      mode = "n";
      silent = true;
      action = "<cmd>lua Snacks.bufdelete()<cr>";
      desc = "Delete Buffer";
    }
    {
      key = "<leader>bD";
      mode = "n";
      silent = true;
      action = "<cmd>lua Snacks.bufdelete.all()<cr>";
      desc = "Delete All Buffers";
    }
    {
      key = "<leader>bo";
      mode = "n";
      silent = true;
      action = "<cmd>lua Snacks.bufdelete.other()<cr>";
      desc = "Delete Other Buffers";
    }

    # Buffer navigation (supplements existing Ctrl-Tab/Ctrl-Shift-Tab)
    {
      key = "<leader>bn";
      mode = "n";
      silent = true;
      action = "<cmd>bnext<cr>";
      desc = "Next Buffer";
    }
    {
      key = "<leader>bp";
      mode = "n";
      silent = true;
      action = "<cmd>bprevious<cr>";
      desc = "Previous Buffer";
    }
    {
      key = "<leader>bl";
      mode = "n";
      silent = true;
      action = "<cmd>blast<cr>";
      desc = "Last Buffer";
    }
    {
      key = "<leader>bf";
      mode = "n";
      silent = true;
      action = "<cmd>bfirst<cr>";
      desc = "First Buffer";
    }
  ];
}
