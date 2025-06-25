{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nvf.homeManagerModules.default

    ./core/options.nix
    ./core/keymaps.nix

    ./lsp/languages.nix

    ./plugins/mini.nix
    ./plugins/picker.nix
    ./plugins/snacks.nix
    ./plugins/utils.nix
  ];

  programs.nvf = {
    enable = true;
    settings.vim = {
      startPlugins = [
        pkgs.vimPlugins.vim-kitty-navigator
      ];
    };
  };
}
