# Text objects and surround functionality
{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    startPlugins = with pkgs.vimPlugins; [
      nvim-surround
    ];

    luaConfigRC.nvim-surround = ''
      require("nvim-surround").setup({
        -- Default config works well
      })
    '';
  };
}
