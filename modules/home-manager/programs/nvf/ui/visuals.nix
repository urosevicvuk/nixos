# Visual enhancements - colors, highlighting, animations
{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    visuals = {
      rainbow-delimiters.enable = true;
      nvim-scrollbar.enable = false;
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      highlight-undo.enable = true;
      cinnamon-nvim.enable = true;
      fidget-nvim.enable = true;
      indent-blankline.enable = true;
    };

    ui.colorizer.enable = true;

    startPlugins = with pkgs.vimPlugins; [
      vim-highlightedyank
    ];

    # Configure rainbow-delimiters to use single color (subtle gray)
    luaConfigRC.rainbow-delimiters-config = ''
      local rainbow_delimiters = require('rainbow-delimiters')
      vim.g.rainbow_delimiters = {
        strategy = {
          [""  ] = rainbow_delimiters.strategy['global'],
        },
        query = {
          [""  ] = 'rainbow-delimiters',
        },
        highlight = {
          'RainbowDelimiterGray',
        },
      }

      -- Set all bracket levels to use the same subtle color
      vim.api.nvim_set_hl(0, 'RainbowDelimiterGray', { fg = '#928374' })
    '';

    luaConfigRC.highlightedyank = ''
      vim.g.highlightedyank_highlight_duration = 200
    '';
  };
}
