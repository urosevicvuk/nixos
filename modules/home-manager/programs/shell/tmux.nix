# Tmux is a terminal multiplexer that allows you to run multiple terminal sessions in a single window.
{ pkgs, ... }:
#let
#  Config = pkgs.writeShellScriptBin "Config" ''
#    SESSION="Nixy Config"
#
#    tmux has-session -t "$SESSION" 2>/dev/null
#
#    if [ $? == 0 ]; then
#      tmux attach -t "$SESSION"
#      exit 0
#    fi
#
#    tmux new-session -d -s "$SESSION"
#    tmux send-keys -t "$SESSION" "sleep 0.2 && clear && cd ~/.config/nixos/ && vim" C-m
#
#    tmux new-window -t "$SESSION" -n "nixy"
#    tmux send-keys -t "$SESSION":1 "sleep 0.2 && clear && cd ~/.config/nixos/ && nixy loop" C-m
#
#    tmux new-window -t "$SESSION" -n "lazygit"
#    tmux send-keys -t "$SESSION":2 "sleep 0.2 && clear && cd ~/.config/nixos/ && lazygit" C-m
#
#    tmux select-window -t "$SESSION":0
#    tmux select-pane -t 0
#    tmux attach -t "$SESSION"
#  '';
#in
{
  programs.tmux = {
    enable = true;
    mouse = true;
    shell = "${pkgs.zsh}/bin/zsh";
    prefix = "C-Space";
    terminal = "kitty";
    keyMode = "vi";

    extraConfig = ''
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      unbind -n C-h 
      unbind -n C-j 
      unbind -n C-k 
      unbind -n C-l 

      set-option -g status-position top

      set -g base-index 1
      setw -g pane-base-index 1

      set -gq allow-passthrough on
      bind-key x kill-pane # skip "kill-pane 1? (y/n)" prompt

      bind-key ` run-shell "tmux neww tmux-sessionizer"
    '';

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      sensible
      gruvbox
      tmux-which-key
      {
        plugin = gruvbox;
        extraConfig = ''
          set -g @tmux-gruvbox-statusbar-alpha 'true'
          set -g @tmux-gruvbox-right-status-x '%d.%m.%Y' # e.g.: 30.01.2024
        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-processes 'ssh psql mysql sqlite3'
          set -g @resurrect-strategy-nvim 'session'

          resurrect_dir="$HOME/.tmux/resurrect"
          set -g @resurrect-dir $resurrect_dir
          set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/home/$USER/.nix-profile/bin/||g" $target | sponge $target'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-boot 'on'
        '';
      }
    ];
  };
  #home.packages = [Config];
  home.packages = [ ];
}
