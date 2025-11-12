# Pure vim options - no plugin configuration
{ ... }:
{
  programs.nvf.settings.vim = {
    viAlias = false;
    vimAlias = true;
    withNodeJs = true;
    syntaxHighlighting = true;

    options = {
      autoindent = true;
      smartindent = true;
      foldlevel = 99;
      foldcolumn = "auto:1";
      mousescroll = "ver:1,hor:1";
      mousemoveevent = true;
      fillchars = "eob:‿,fold: ,foldopen:▼,foldsep:⸽,foldclose:⏵";
      signcolumn = "yes";
      wrap = false;
      scrolloff = 9;
    };

    clipboard = {
      enable = true;
      registers = "unnamedplus";
      providers.wl-copy.enable = true;
    };
  };
}
