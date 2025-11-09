{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    startPlugins = with pkgs.vimPlugins; [ opencode-nvim ];

    options = {
      autoread = true;
    };

    keymaps = [
      {
        key = "<leader>oa";
        mode = [
          "n"
          "x"
        ];
        silent = true;
        action = "<cmd>lua require('opencode').ask('@this: ', { submit = true })<cr>";
        desc = "Ask about this";
      }
      {
        key = "<leader>os";
        mode = [
          "n"
          "x"
        ];
        silent = true;
        action = "<cmd>lua require('opencode').select()<cr>";
        desc = "Select prompt";
      }
      {
        key = "<leader>o+";
        mode = [
          "n"
          "x"
        ];
        silent = true;
        action = "<cmd>lua require('opencode').prompt('@this')<cr>";
        desc = "Add this";
      }
      {
        key = "<leader>ot";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('opencode').toggle()<cr>";
        desc = "Toggle embedded";
      }
      {
        key = "<leader>oc";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('opencode').command()<cr>";
        desc = "Select command";
      }
      {
        key = "<leader>on";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('opencode').command('session_new')<cr>";
        desc = "New session";
      }
      {
        key = "<leader>oi";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('opencode').command('session_interrupt')<cr>";
        desc = "Interrupt session";
      }
      {
        key = "<leader>oA";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('opencode').command('agent_cycle')<cr>";
        desc = "Cycle selected agent";
      }
      {
        key = "<S-C-u>";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('opencode').command('messages_half_page_up')<cr>";
        desc = "Messages half page up";
      }
      {
        key = "<S-C-d>";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('opencode').command('messages_half_page_down')<cr>";
        desc = "Messages half page down";
      }
    ];
  };
}
