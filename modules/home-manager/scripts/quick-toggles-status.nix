# - ## Quick Toggles Status
#-
#- Unified status checker for quick toggle features (recording, caffeine, night-shift).
#- This provides a single module for hyprpanel instead of separate modules.
#-
#- - `quick-toggles-status` - Check status of all toggles and output JSON for hyprpanel.

{ pkgs, ... }:
let
  quick-toggles-status = pkgs.writeShellScriptBin "quick-toggles-status" ''
    # Initialize variables for building the status
    icons=""
    tooltip_parts=""
    has_active=false

    # Check recording status (gpu-screen-recorder PID file)
    if [ -f "/tmp/gpu-screen-recorder.pid" ]; then
      PID=$(cat "/tmp/gpu-screen-recorder.pid" 2>/dev/null)
      if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
        icons="🎥 "
        tooltip_parts="Recording"
        has_active=true
      fi
    fi

    # Check caffeine status (active when hypridle is NOT running)
    if ! pidof "hypridle" >/dev/null 2>&1; then
      # Add icon with space separator if we already have icons
      if [ -n "$icons" ]; then
        icons="$icons ☕ "
      else
        icons="☕ "
      fi

      # Add to tooltip with separator if needed
      if [ -n "$tooltip_parts" ]; then
        tooltip_parts="$tooltip_parts • Caffeine"
      else
        tooltip_parts="Caffeine"
      fi
      has_active=true
    fi

    # Check night-shift status (active when hyprsunset IS running)
    if pidof "hyprsunset" >/dev/null 2>&1; then
      # Add icon with space separator if we already have icons
      if [ -n "$icons" ]; then
        icons="$icons 💤 "
      else
        icons="💤 "
      fi

      # Add to tooltip with separator if needed
      if [ -n "$tooltip_parts" ]; then
        tooltip_parts="$tooltip_parts • Night-shift"
      else
        tooltip_parts="Night-shift"
      fi
      has_active=true
    fi



    # Format the final JSON output
    if [ "$has_active" = true ]; then
      # Trim leading space/separator from tooltip
      tooltip_parts=$(echo "$tooltip_parts" | sed 's/^ • //')
      echo "{\"text\": \"$icons \", \"tooltip\": \"$tooltip_parts\", \"alt\": \"active\"}"
    fi
    # Output nothing when no toggles are active (for hideOnEmpty to work)
  '';

in
{
  home.packages = [ quick-toggles-status ];
}
