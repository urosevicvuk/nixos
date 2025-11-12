# - ## Mic
#-
#- This module provides a set of scripts to control the volume of the default audio source (microphone) using `wpctl`.
#-
#- - `mic-up` increases the mic volume by 5%.
#- - `mic-down` decreases the mic volume by 5%.
#- - `mic-set [value]` sets the mic volume to the given value.
#- - `mic-toggle` toggles the mute state of the default audio source.
{ pkgs, ... }:

let
  increments = "5";

  mic-change = pkgs.writeShellScriptBin "mic-change" ''
    [[ $1 == "mute" ]] && wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    [[ $1 == "up" ]] && wpctl set-volume @DEFAULT_AUDIO_SOURCE@ ''${2-${increments}}%+
    [[ $1 == "down" ]] && wpctl set-volume @DEFAULT_AUDIO_SOURCE@ ''${2-${increments}}%-
    [[ $1 == "set" ]] && wpctl set-volume @DEFAULT_AUDIO_SOURCE@ ''${2-100}%
  '';

  mic-up = pkgs.writeShellScriptBin "mic-up" ''
    mic-change up ${increments}
  '';

  mic-set = pkgs.writeShellScriptBin "mic-set" ''
    mic-change set ''${1-100}
  '';

  mic-down = pkgs.writeShellScriptBin "mic-down" ''
    mic-change down ${increments}
  '';

  mic-toggle = pkgs.writeShellScriptBin "mic-toggle" ''
    mic-change mute
  '';
in {
  home.packages = [ mic-change mic-up mic-down mic-toggle mic-set ];
}
