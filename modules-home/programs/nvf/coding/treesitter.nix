# Treesitter - Syntax highlighting and parsing
{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    treesitter = {
      enable = true;
      autotagHtml = true;
      fold = true;
      context = {
        enable = true;
        setupOpts = {
          enable = true;
          line_numbers = true;
          max_lines = 3;
          min_window_height = 20;
          multiline_threshold = 1;
          trim_scope = "outer";
          mode = "cursor";
        };
      };
      highlight.enable = true;
    };

    # Add treesitter-textobjects for better code navigation
    startPlugins = with pkgs.vimPlugins; [
      nvim-treesitter-textobjects
    ];

    luaConfigRC.treesitter-textobjects = ''
      require('nvim-treesitter.configs').setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              -- Functions (mini.ai provides af/if, use aF/iF for treesitter-specific)
              ["aF"] = "@function.outer",
              ["iF"] = "@function.inner",
              -- Classes
              ["aC"] = "@class.outer",
              ["iC"] = "@class.inner",
              -- Conditionals (avoid ai/ii conflict with mini.ai indent)
              ["aI"] = "@conditional.outer",
              ["iI"] = "@conditional.inner",
              -- Loops
              ["aL"] = "@loop.outer",
              ["iL"] = "@loop.inner",
              -- Parameters/arguments
              ["aA"] = "@parameter.outer",
              ["iA"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]k"] = "@class.outer",
              ["]p"] = "@parameter.inner",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]K"] = "@class.outer",
              ["]P"] = "@parameter.inner",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[k"] = "@class.outer",
              ["[p"] = "@parameter.inner",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[K"] = "@class.outer",
              ["[P"] = "@parameter.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              [">p"] = "@parameter.inner",
            },
            swap_previous = {
              ["<p"] = "@parameter.inner",
            },
          },
        },
      })
    '';
  };
}
