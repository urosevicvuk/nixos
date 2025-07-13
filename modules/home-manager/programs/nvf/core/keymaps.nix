{
  programs.nvf.settings.vim = {
    globals.mapleader = " ";
    binds = {
      whichKey = {
        enable = true;
        # TODO: registers
        register = {};
      };
    };
    keymaps = [
      # General Mappings
      {
        key = "<leader><C-e>";
        mode = "n";
        silent = true;
        action = "oif err != nil {<CR>}<Esc>Oreturn err<Esc>";
        desc = "error handling in go";
      }
      {
        key = "<leader>r";
        mode = "n";
        silent = true;
        action = ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>";
        desc = "Refactor word under cursor";
      }
      {
        key = "Q";
        mode = "n";
        silent = true;
        action = "<nop>";
        desc = "Disable Q";
      }
      {
        key = "p";
        mode = "x";
        silent = true;
        action = "\"_dP";
        desc = "Paste and keep selection";
      }
      {
        key = "N";
        mode = "n";
        silent = true;
        action = "Nzzzv";
        desc = "Previous search result";
      }
      {
        key = "n";
        mode = "n";
        silent = true;
        action = "nzzzv";
        desc = "Next search result";
      }
      {
        key = "<C-u>";
        mode = "n";
        silent = true;
        action = "<C-u>zz";
        desc = "Scroll up";
      }
      {
        key = "<C-d>";
        mode = "n";
        silent = true;
        action = "<C-d>zz";
        desc = "Scroll down";
      }
      {
        key = "J";
        mode = "n";
        silent = true;
        action = "mzJ`z";
        desc = "Join lines";
      }
      {
        key = "J";
        mode = "v";
        silent = true;
        action = ":m '>+1<cr>gv=gv";
        desc = "Move selected lines down";
      }
      {
        key = "K";
        mode = "v";
        silent = true;
        action = ":m '<-2<cr>gv=gv";
        desc = "Move selected lines up";
      }
      {
        key = "s";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('flash').jump()<cr>";
        desc = "Flash";
      }
      {
        key = "K";
        mode = "n";
        silent = true;
        action = "<cmd>lua vim.lsp.buf.hover()<cr>";
        desc = "LSP Hover";
      }
      {
        key = "L";
        mode = "v";
        silent = true;
        action = "$";
        desc = "Go all the way right";
      }
      {
        key = "H";
        mode = "v";
        silent = true;
        action = "^";
        desc = "Go all the way left";
      }
      {
        key = "L";
        mode = "n";
        silent = true;
        action = "$";
        desc = "Go all the way right";
      }
      {
        key = "H";
        mode = "n";
        silent = true;
        action = "^";
        desc = "Go all the way left";
      }
      {
        key = "<C-tab>";
        mode = "n";
        silent = true;
        action = "<cmd>bnext<cr>";
        desc = "Next Buffer";
      }
      {
        key = "<C-S-tab>";
        mode = "n";
        silent = true;
        action = "<cmd>bprev<cr>";
        desc = "Previous Buffer";
      }

      # Kitty navigator
      {
        key = "<C-h>";
        mode = "n";
        silent = true;
        #action = "<cmd>KittyNavigateLeft<cr>";
        action = ''
          <cmd>lua
          if vim.env.TMUX and vim.env.TMUX ~= "" then
              vim.cmd("wincmd h")
          else
              vim.cmd("KittyNavigateLeft")
                  end
                  <CR>
        '';
      }
      {
        key = "<C-j>";
        mode = "n";
        silent = true;
        #action = "<cmd>KittyNavigateDown<cr>";
        action = ''
          <cmd>lua
          if vim.env.TMUX and vim.env.TMUX ~= "" then
              vim.cmd("wincmd j")
          else
              vim.cmd("KittyNavigateDown")
                  end
                  <CR>
        '';
      }
      {
        key = "<C-k>";
        mode = "n";
        silent = true;
        #action = "<cmd>KittyNavigateUp<cr>";
        action = ''
          <cmd>lua
          if vim.env.TMUX and vim.env.TMUX ~= "" then
              vim.cmd("wincmd k")
          else
              vim.cmd("KittyNavigateUp")
                  end
                  <CR>
        '';
      }
      {
        key = "<C-l>";
        mode = "n";
        silent = true;
        #action = "<cmd>KittyNavigateRight<cr>";
        action = ''
          <cmd>lua
          if vim.env.TMUX and vim.env.TMUX ~= "" then
              vim.cmd("wincmd l")
          else
              vim.cmd("KittyNavigateRight")
                  end
                  <CR>
        '';
      }

      # Disable Arrow Keys in Normal Mode
      {
        key = "<Up>";
        mode = "n";
        silent = true;
        action = "<Nop>";
        desc = "Disable Up Arrow";
      }
      {
        key = "<Down>";
        mode = "n";
        silent = true;
        action = "<Nop>";
        desc = "Disable Down Arrow";
      }
      {
        key = "<Left>";
        mode = "n";
        silent = true;
        action = "<Nop>";
        desc = "Disable Left Arrow";
      }
      {
        key = "<Right>";
        mode = "n";
        silent = true;
        action = "<Nop>";
        desc = "Disable Right Arrow";
      }

      # UI
      {
        key = "<leader>uw";
        mode = "n";
        silent = true;
        action = "<cmd>set wrap!<cr>";
        desc = "Toggle word wrapping";
      }
      {
        key = "<leader>ul";
        mode = "n";
        silent = true;
        action = "<cmd>set linebreak!<cr>";
        desc = "Toggle linebreak";
      }
      {
        key = "<leader>us";
        mode = "n";
        silent = true;
        action = "<cmd>set spell!<cr>";
        desc = "Toggle spellLazyGitcheck";
      }
      {
        key = "<leader>uc";
        mode = "n";
        silent = true;
        action = "<cmd>set cursorline!<cr>";
        desc = "Toggle cursorline";
      }
      {
        key = "<leader>un";
        mode = "n";
        silent = true;
        action = "<cmd>set number!<cr>";
        desc = "Toggle line numbers";
      }
      {
        key = "<leader>ur";
        mode = "n";
        silent = true;
        action = "<cmd>set relativenumber!<cr>";
        desc = "Toggle relative line numbers";
      }
      {
        key = "<leader>ut";
        mode = "n";
        silent = true;
        action = "<cmd>set showtabline=2<cr>";
        desc = "Show tabline";
      }
      {
        key = "<leader>uT";
        mode = "n";
        silent = true;
        action = "<cmd>set showtabline=0<cr>";
        desc = "Hide tabline";
      }

      # Windows
      {
        key = "<leader>ws";
        mode = "n";
        silent = true;
        action = "<cmd>split<cr>";
        desc = "Split";
      }
      {
        key = "<leader>wv";
        mode = "n";
        silent = true;
        action = "<cmd>vsplit<cr>";
        desc = "VSplit";
      }
      {
        key = "<leader>wd";
        mode = "n";
        silent = true;
        action = "<cmd>close<cr>";
        desc = "Close";
      }
    ];
  };
}
