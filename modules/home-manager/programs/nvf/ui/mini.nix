# Mini.nvim plugin suite - small, focused utilities
{ ... }:
{
  programs.nvf.settings.vim.mini = {
    # Existing modules
    starter.enable = true;
    comment.enable = true;
    cursorword.enable = true;
    icons.enable = true;
    indentscope.enable = true;
    notify.enable = true;
    pairs.enable = true;
    diff.enable = true;
    git.enable = true;

    # New modules - Text objects and editing
    ai.enable = true; # Extended text objects (vai, vii, vaq, vaf, etc.)
    splitjoin.enable = true; # Split/join code structures (gS/gJ)
    bracketed.enable = true; # Navigate with [ and ] (buffers, diagnostics, files, etc.)
    move.enable = true; # Move lines/selections with Alt+hjkl
    align.enable = true; # Interactive alignment (ga)
    hipatterns.enable = true; # Highlight hex colors and patterns
    trailspace.enable = true; # Highlight and trim trailing whitespace
  };
}
