{
  inputs,
  ...
}:
{
  imports = [
    inputs.nvf.homeManagerModules.default

    # Core
    ./core/options.nix
    ./core/globals.nix
    ./core/keymaps.nix

    # Editor
    ./editor/motion.nix
    ./editor/text-objects.nix
    ./editor/editing.nix
    ./editor/undo.nix

    # UI
    ./ui/theme.nix
    ./ui/statusline.nix
    ./ui/dashboard.nix
    ./ui/visuals.nix
    ./ui/notifications.nix
    ./ui/windows.nix
    ./ui/mini.nix
    ./ui/snacks.nix

    # Navigation
    ./navigation/file-explorer.nix
    ./navigation/fuzzy-finder.nix
    ./navigation/marks.nix
    ./navigation/outline.nix
    ./navigation/terminal-nav.nix

    # Coding
    ./coding/treesitter.nix
    ./coding/lsp.nix
    ./coding/languages.nix
    ./coding/completion.nix
    ./coding/diagnostics.nix
    ./coding/formatting.nix

    # Development
    ./devel/dap.nix
    ./devel/testing.nix
    ./devel/refactoring.nix

    # Git
    ./git/integration.nix
    ./git/lazygit.nix

  # AI
  ./ai/completion.nix
  #./ai/avante.nix
  ./ai/opencode.nix

    # Session
    ./session/projects.nix
    ./session/sessions.nix
  ];

  programs.nvf.enable = true;
}
