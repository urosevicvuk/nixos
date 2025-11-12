# Terminal multiplexer navigation - Seamless tmux + nvim integration
{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    startPlugins = [
      pkgs.vimPlugins.vim-tmux-navigator
    ];

    # vim-tmux-navigator automatically handles Ctrl+hjkl
    # It intelligently switches between nvim splits and tmux panes
    # No manual keybind configuration needed - the plugin sets up everything!

    # How it works:
    # - Press Ctrl+h in nvim → moves left within nvim splits
    # - At the leftmost nvim split → automatically moves to tmux pane to the left
    # - Same for j/k/l (down/up/right)
    # - Works seamlessly in both directions (nvim → tmux and tmux → nvim)
  };
}
