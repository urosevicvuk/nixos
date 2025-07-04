{ pkgs, lib, ... }:
{
  programs.nvf.settings.vim = {

    utility = {
      yazi-nvim = {
        enable = true;
        mappings = {
          openYazi = "<leader>-";
          openYaziDir = "<leader>=";
        };
      };
      motion.flash-nvim.enable = true;
      outline.aerial-nvim.enable = true;
    };

    #tabline.nvimBufferline.enable = true;
    tabline.nvimBufferline.enable = false;

    notes.todo-comments.enable = true;

    assistant = {
      copilot = {
        enable = true;
        cmp.enable = true;
      };
    };

    statusline.lualine = {
      enable = true;
      #theme = lib.mkForce "gruvbox_dark";
    };

    autocomplete = {
      nvim-cmp = {
        enable = true;
        sources = {
          buffer = "[Buffer]";
          nvim-cmp = null;
          path = "[Path]";
        };
        mappings = {
          next = "<C-n>";
          previous = "<C-p>";
          confirm = "<C-y>";
        };
        sourcePlugins = [ pkgs.vimPlugins.cmp-cmdline ];
      };
    };

    snippets.luasnip.enable = true;

    ui = {
      noice.enable = true;
      colorizer.enable = true;
    };

    git = {
      enable = true;
      gitsigns.enable = true;
    };

    terminal.toggleterm = {
      enable = true;
      lazygit = {
        enable = true;
        mappings.open = "<leader>gl";
      };
    };

    visuals = {
      rainbow-delimiters.enable = true;
      nvim-scrollbar = {
        enable = false;
      };
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      highlight-undo.enable = true;
    };

    formatter.conform-nvim.enable = true;
  };
}
