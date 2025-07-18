{pkgs, ...}: {
  programs.nvf.settings.vim = {
    utility = {
      yazi-nvim = {
        enable = true;
        mappings = {
          openYazi = "<leader>-";
          openYaziDir = "<leader>=";
        };
      };
      motion = {
        flash-nvim.enable = true;
      };
      outline.aerial-nvim.enable = true;
    };

    #tabline.nvimBufferline.enable = true;
    tabline.nvimBufferline.enable = false;

    notes.todo-comments.enable = true;

    assistant = {
      copilot = {
        enable = true;
        cmp.enable = true;
        mappings = {
          panel = {
            open = "<leader>ac";
          };
        };
      };
    };

    comments = {
      comment-nvim = {
        enable = true;
      };
    };

    statusline.lualine = {
      enable = true;
      #theme = lib.mkForce "gruvbox_dark";
    };

    autocomplete = {
      blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
        mappings = {
          next = "<C-n>";
          previous = "<C-p>";
          confirm = "<C-y>";
        };
        setupOpts = {
          completion = {
            menu = {
              border = "rounded";
              draw = {
                columns = [["kind_icon"] ["label" "label_description"] ["source_name"]];
              };
            };
            documentation = {
              window = {
                border = "rounded";
              };
            };
          };
        };
        #sources = {
        #  buffer = "[Buffer]";
        #  nvim-cmp = null;
        #  path = "[Path]";
        #};
        #sourcePlugins = [pkgs.vimPlugins.cmp-cmdline];
      };
    };

    snippets.luasnip.enable = true;

    ui = {
      borders.enable = true;
      noice.enable = true;
      colorizer.enable = true;

      fastaction.enable = true;
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
      #rainbow-delimiters.enable = true;
      nvim-scrollbar = {
        enable = false;
      };
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      highlight-undo.enable = true;

      cinnamon-nvim.enable = true;
      fidget-nvim.enable = true;
      #indent-blankline.enable = true;
    };
  };
}
