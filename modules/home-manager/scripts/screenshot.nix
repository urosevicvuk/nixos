# - ## Screenshot & Recording
#-
#- This module provides scripts for screenshots using hyprshot and screen recording using gpu-screen-recorder.
#-
#- Screenshots:
#- - `screenshot-monitor` - Screenshot current monitor (save + clipboard)
#- - `screenshot-monitor-annotate` - Screenshot current monitor (save + clipboard + annotate)
#- - `screenshot-region` - Screenshot region (save + clipboard)
#- - `screenshot-region-annotate` - Screenshot region (save + clipboard + annotate)
#-
#- Recording:
#- - `record-monitor` - Record current monitor (start/stop)
#- - `record-monitor-edit` - Record current monitor (start/stop + open in LosslessCut)
#- - `record-region` - Record region (start/stop)
#- - `record-region-edit` - Record region (start/stop + open in LosslessCut)

{ pkgs, ... }:
let
  # Screenshot scripts using hyprshot
  screenshot-monitor = pkgs.writeShellScriptBin "screenshot-monitor" ''
    OUTPUT_DIR="$HOME/Pictures/screenshots"
    mkdir -p "$OUTPUT_DIR"
    FILENAME="$OUTPUT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"

    # Get current monitor name
    MONITOR=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.focused == true) | .name')

    # Take screenshot with hyprshot
    ${pkgs.hyprshot}/bin/hyprshot -m output -o "$OUTPUT_DIR" -m "$MONITOR" -f "$(basename $FILENAME)"

    # Copy to clipboard
    ${pkgs.wl-clipboard}/bin/wl-copy < "$FILENAME"
  '';

  screenshot-monitor-annotate = pkgs.writeShellScriptBin "screenshot-monitor-annotate" ''
    OUTPUT_DIR="$HOME/Pictures/screenshots"
    mkdir -p "$OUTPUT_DIR"
    TEMP_FILE="/tmp/screenshot-$(date +%Y%m%d-%H%M%S).png"
    FILENAME="$OUTPUT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"

    # Get current monitor name
    MONITOR=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.focused == true) | .name')

    # Take screenshot with hyprshot to temp
    ${pkgs.hyprshot}/bin/hyprshot -m output -o "/tmp" -m "$MONITOR" -f "$(basename $TEMP_FILE)"

    # Open in satty for annotation
    ${pkgs.satty}/bin/satty --filename "$TEMP_FILE" --output-filename "$FILENAME" --copy-command "${pkgs.wl-clipboard}/bin/wl-copy"
  '';

  screenshot-region = pkgs.writeShellScriptBin "screenshot-region" ''
    OUTPUT_DIR="$HOME/Pictures/screenshots"
    mkdir -p "$OUTPUT_DIR"

    # hyprshot handles region selection, clipboard copy, and saving
    ${pkgs.hyprshot}/bin/hyprshot -m region -o "$OUTPUT_DIR" -z
  '';

  screenshot-region-annotate = pkgs.writeShellScriptBin "screenshot-region-annotate" ''
    OUTPUT_DIR="$HOME/Pictures/screenshots"
    mkdir -p "$OUTPUT_DIR"
    TEMP_FILE="/tmp/screenshot-$(date +%Y%m%d-%H%M%S).png"
    FILENAME="$OUTPUT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"

    # Take region screenshot with hyprshot to temp
    ${pkgs.hyprshot}/bin/hyprshot -m region -o "/tmp" -f "$(basename $TEMP_FILE)"

    # Open in satty for annotation
    ${pkgs.satty}/bin/satty --filename "$TEMP_FILE" --output-filename "$FILENAME" --copy-command "${pkgs.wl-clipboard}/bin/wl-copy"
  '';

  # Recording scripts using gpu-screen-recorder
  record-monitor = pkgs.writeShellScriptBin "record-monitor" ''
    OUTPUT_DIR="$HOME/Videos/Recordings"
    mkdir -p "$OUTPUT_DIR"
    PID_FILE="/tmp/gpu-screen-recorder.pid"
    FILENAME_FILE="/tmp/gpu-screen-recorder-filename"

    # Check if already recording
    if [ -f "$PID_FILE" ]; then
      PID=$(cat "$PID_FILE")
      if kill -0 "$PID" 2>/dev/null; then
        # Stop recording
        kill -SIGINT "$PID"
        wait "$PID" 2>/dev/null
        rm "$PID_FILE"

        FILENAME=$(cat "$FILENAME_FILE" 2>/dev/null || echo "recording")
        ${pkgs.libnotify}/bin/notify-send "⏹ Recording Stopped" "Saved to: $(basename $FILENAME)"
        rm "$FILENAME_FILE"
        exit 0
      else
        rm "$PID_FILE"
        rm -f "$FILENAME_FILE"
      fi
    fi

    # Start recording current monitor
    FILENAME="$OUTPUT_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4"
    echo "$FILENAME" > "$FILENAME_FILE"

    # Get current monitor name
    MONITOR=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.focused == true) | .name')

    ${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder -w "$MONITOR" -f 60 -a default_output -o "$FILENAME" &
    echo $! > "$PID_FILE"
    ${pkgs.libnotify}/bin/notify-send "⏺ Recording Started" "Recording $MONITOR"
  '';

  record-monitor-edit = pkgs.writeShellScriptBin "record-monitor-edit" ''
    OUTPUT_DIR="$HOME/Videos/Recordings"
    mkdir -p "$OUTPUT_DIR"
    PID_FILE="/tmp/gpu-screen-recorder.pid"
    FILENAME_FILE="/tmp/gpu-screen-recorder-filename"
    EDIT_FLAG="/tmp/gpu-screen-recorder-edit"

    # Check if already recording
    if [ -f "$PID_FILE" ]; then
      PID=$(cat "$PID_FILE")
      if kill -0 "$PID" 2>/dev/null; then
        # Stop recording and mark for editing
        touch "$EDIT_FLAG"
        kill -SIGINT "$PID"
        wait "$PID" 2>/dev/null
        rm "$PID_FILE"

        FILENAME=$(cat "$FILENAME_FILE" 2>/dev/null || echo "")
        rm "$FILENAME_FILE"

        if [ -f "$EDIT_FLAG" ]; then
          rm "$EDIT_FLAG"
          if [ -n "$FILENAME" ] && [ -f "$FILENAME" ]; then
            ${pkgs.libnotify}/bin/notify-send "⏹ Recording Stopped" "Opening in LosslessCut..."
            ${pkgs.losslesscut-bin}/bin/losslesscut "$FILENAME" &
          fi
        fi
        exit 0
      else
        rm "$PID_FILE"
        rm -f "$FILENAME_FILE"
        rm -f "$EDIT_FLAG"
      fi
    fi

    # Start recording current monitor (same as record-monitor)
    FILENAME="$OUTPUT_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4"
    echo "$FILENAME" > "$FILENAME_FILE"

    MONITOR=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.focused == true) | .name')

    ${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder -w "$MONITOR" -f 60 -a default_output -o "$FILENAME" &
    echo $! > "$PID_FILE"
    ${pkgs.libnotify}/bin/notify-send "⏺ Recording Started" "Recording $MONITOR (will open in LosslessCut)"
  '';

  record-region = pkgs.writeShellScriptBin "record-region" ''
    OUTPUT_DIR="$HOME/Videos/Recordings"
    mkdir -p "$OUTPUT_DIR"
    PID_FILE="/tmp/gpu-screen-recorder.pid"
    FILENAME_FILE="/tmp/gpu-screen-recorder-filename"

    # Check if already recording
    if [ -f "$PID_FILE" ]; then
      PID=$(cat "$PID_FILE")
      if kill -0 "$PID" 2>/dev/null; then
        # Stop recording
        kill -SIGINT "$PID"
        wait "$PID" 2>/dev/null
        rm "$PID_FILE"

        FILENAME=$(cat "$FILENAME_FILE" 2>/dev/null || echo "recording")
        ${pkgs.libnotify}/bin/notify-send "⏹ Recording Stopped" "Saved to: $(basename $FILENAME)"
        rm "$FILENAME_FILE"
        exit 0
      else
        rm "$PID_FILE"
        rm -f "$FILENAME_FILE"
      fi
    fi

    # Select region with slurp
    GEOMETRY=$(${pkgs.slurp}/bin/slurp -f "%wx%h+%x+%y")

    if [ -z "$GEOMETRY" ]; then
      ${pkgs.libnotify}/bin/notify-send "Screen Recording" "Cancelled"
      exit 1
    fi

    # Start recording region
    FILENAME="$OUTPUT_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4"
    echo "$FILENAME" > "$FILENAME_FILE"

    ${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder -w region -region "$GEOMETRY" -f 60 -a default_output -o "$FILENAME" &
    echo $! > "$PID_FILE"
    ${pkgs.libnotify}/bin/notify-send "⏺ Recording Started" "Recording region"
  '';

  record-region-edit = pkgs.writeShellScriptBin "record-region-edit" ''
    OUTPUT_DIR="$HOME/Videos/Recordings"
    mkdir -p "$OUTPUT_DIR"
    PID_FILE="/tmp/gpu-screen-recorder.pid"
    FILENAME_FILE="/tmp/gpu-screen-recorder-filename"
    EDIT_FLAG="/tmp/gpu-screen-recorder-edit"

    # Check if already recording
    if [ -f "$PID_FILE" ]; then
      PID=$(cat "$PID_FILE")
      if kill -0 "$PID" 2>/dev/null; then
        # Stop recording and mark for editing
        touch "$EDIT_FLAG"
        kill -SIGINT "$PID"
        wait "$PID" 2>/dev/null
        rm "$PID_FILE"

        FILENAME=$(cat "$FILENAME_FILE" 2>/dev/null || echo "")
        rm "$FILENAME_FILE"

        if [ -f "$EDIT_FLAG" ]; then
          rm "$EDIT_FLAG"
          if [ -n "$FILENAME" ] && [ -f "$FILENAME" ]; then
            ${pkgs.libnotify}/bin/notify-send "⏹ Recording Stopped" "Opening in LosslessCut..."
            ${pkgs.losslesscut-bin}/bin/losslesscut "$FILENAME" &
          fi
        fi
        exit 0
      else
        rm "$PID_FILE"
        rm -f "$FILENAME_FILE"
        rm -f "$EDIT_FLAG"
      fi
    fi

    # Select region with slurp
    GEOMETRY=$(${pkgs.slurp}/bin/slurp -f "%wx%h+%x+%y")

    if [ -z "$GEOMETRY" ]; then
      ${pkgs.libnotify}/bin/notify-send "Screen Recording" "Cancelled"
      exit 1
    fi

    # Start recording region
    FILENAME="$OUTPUT_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4"
    echo "$FILENAME" > "$FILENAME_FILE"

    ${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder -w region -region "$GEOMETRY" -f 60 -a default_output -o "$FILENAME" &
    echo $! > "$PID_FILE"
    ${pkgs.libnotify}/bin/notify-send "⏺ Recording Started" "Recording region (will open in LosslessCut)"
  '';

in
{
  home.packages = [
    pkgs.hyprshot
    pkgs.satty
    pkgs.wl-clipboard
    pkgs.gpu-screen-recorder
    pkgs.slurp
    pkgs.losslesscut-bin
    screenshot-monitor
    screenshot-monitor-annotate
    screenshot-region
    screenshot-region-annotate
    record-monitor
    record-monitor-edit
    record-region
    record-region-edit
  ];
}
