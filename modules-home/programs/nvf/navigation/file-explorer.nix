# File explorers - Three complementary explorers for different use cases
# - Snacks Explorer: Quick tree sidebar for navigation (<leader>e, <leader>fe)
# - Oil: Edit filesystem as a buffer, unique workflow (<leader>fO, -)
# - Yazi: Advanced terminal file manager with previews (<leader>-, <leader>=)
{ ... }:
{
  programs.nvf.settings.vim = {
    # Yazi - Full-featured terminal file manager (like ranger)
    # Use for: Advanced file operations, previews, bulk operations
    utility.yazi-nvim = {
      enable = true;
      mappings = {
        openYazi = "<leader>-";
        openYaziDir = "<leader>=";
      };
    };

    # Oil - Edit filesystem like a text buffer
    # Use for: Quick renames, moves, deletes using vim motions
    utility.oil-nvim.enable = true;

    # Snacks explorer - Simple tree sidebar
    # Configured in: ui/snacks.nix and navigation/fuzzy-finder.nix
    # Keybinds: <leader>e (quick), <leader>fe (find menu)
  };
}
