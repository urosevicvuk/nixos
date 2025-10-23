# - ## Screenshot
#-
#- This module provides a script to take screenshots using `grimblast` and `swappy`.
#-
#- - `screenshot [region|window|monitor] [swappy]` - Take a screenshot of the region, window, or monitor. Optionally, use `swappy` to copy the screenshot to the clipboard.
{ pkgs, ... }:
let
  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    if [[ $2 == "swappy" ]];then
      folder="/tmp"
    else
      folder="$HOME/Pictures"
    fi
    filename="$(date +%Y-%m-%d_%H:%M:%S).png"

    if [[ $1 == "window" ]];then
      mode="active"
    elif [[ $1 == "region" ]];then
      mode="area"
    elif [[ $1 == "monitor" ]];then
      mode="output"
    fi

    ${pkgs.grimblast}/bin/grimblast --notify --freeze copysave $mode "$folder/$filename" || exit 1

    if [[ $2 == "swappy" ]];then
      ${pkgs.swappy}/bin/swappy -f "$folder/$filename" -o "$HOME/Pictures/$filename"
      exit 0
    fi
  '';
  screenshot-annotate = pkgs.writeShellScriptBin "screenshot-annotate" ''
    filename="/tmp/screenshot-$(date +%Y%m%d-%H%M%S).png"
    
    ${pkgs.grimblast}/bin/grimblast --freeze save area "$filename" || exit 1
    
    ${pkgs.satty}/bin/satty --filename "$filename" --output-filename "$HOME/Pictures/$(basename $filename)"
  '';

  record-screen = pkgs.writeShellScriptBin "record-screen" ''
    OUTPUT_DIR="$HOME/Videos/Recordings"
    mkdir -p "$OUTPUT_DIR"
    FILENAME="$OUTPUT_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4"
    PID_FILE="/tmp/screen-recorder.pid"
    ICON_FILE="/tmp/recording-indicator"
    
    if [ -f "$PID_FILE" ]; then
      PID=$(cat "$PID_FILE")
      if kill -0 "$PID" 2>/dev/null; then
        kill -INT "$PID"
        rm "$PID_FILE"
        rm -f "$ICON_FILE"
        ${pkgs.libnotify}/bin/notify-send -u critical "⏹ Recording Stopped" "Saved to: $(basename $FILENAME)"
        exit 0
      else
        rm "$PID_FILE"
        rm -f "$ICON_FILE"
      fi
    fi
    
    # Record using geometry to capture at native resolution
    # Get monitor geometry including scale
    GEOMETRY=$(${pkgs.slurp}/bin/slurp -o -f "%x,%y %wx%h")
    
    if [ -z "$GEOMETRY" ]; then
      ${pkgs.libnotify}/bin/notify-send "Screen Recording" "Cancelled"
      exit 1
    fi
    
    # Create indicator file
    touch "$ICON_FILE"
    
    # wf-recorder with explicit geometry captures at native resolution
    ${pkgs.wf-recorder}/bin/wf-recorder -g "$GEOMETRY" -f "$FILENAME" &
    echo $! > "$PID_FILE"
    ${pkgs.libnotify}/bin/notify-send -u critical "⏺ Recording Started" "Press F9 again to stop"
  '';
in {
  home.packages = [
    pkgs.hyprshot
    screenshot
    screenshot-annotate
    record-screen
    pkgs.slurp
    pkgs.grim
    pkgs.grimblast
    pkgs.satty
    pkgs.wf-recorder
  ];
}
