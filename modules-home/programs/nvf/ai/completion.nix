# AI-powered completion - Supermaven
{ ... }:
{
  programs.nvf.settings.vim.assistant = {
    supermaven-nvim = {
      enable = true;
      setupOpts = {
        keymaps = {
          accept_suggestion = "<Tab>";
          accept_word = "<M-Tab>";
          clear_suggestion = "<M-c>";
        };
        # Keep inline completion enabled for ghost text!
        disable_inline_completion = false;
        log_level = "info";
      };
    };
  };
}
