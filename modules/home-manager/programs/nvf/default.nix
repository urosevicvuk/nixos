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
    ./core/languages.nix

    ./plugins/mini.nix
    ./plugins/picker.nix
    ./plugins/snacks.nix
    ./plugins/utils.nix
    ./plugins/avante.nix
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
