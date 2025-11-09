# File explorers - oil, yazi, snacks
{ ... }:
{
  programs.nvf.settings.vim = {
    utility.yazi-nvim = {
      enable = true;
      mappings = {
        openYazi = "<leader>-";
        openYaziDir = "<leader>=";
      };
    };

    # Enable oil-nvim file browser
    utility.oil-nvim.enable = true;

    # Snacks explorer is configured in snacks section
  };
}
