# Smart Screenshot - Omarchy-inspired with intelligent window detection
{ pkgs, ... }:
let
  smart-screenshot = pkgs.writeShellScriptBin "smart-screenshot" ''
    OUTPUT_DIR="$HOME/Pictures/screenshots"
    mkdir -p "$OUTPUT_DIR"
    
    # Kill any existing slurp instances
    pkill slurp && exit 0
    
    # Get all rectangles (monitors and windows) on the active workspace
    get_rectangles() {
      local active_workspace=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.focused == true) | .activeWorkspace.id')
      
      # Get monitor geometries
      ${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r --arg ws "$active_workspace" \
        '.[] | select(.activeWorkspace.id == ($ws | tonumber)) | "\(.x),\(.y) \((.width / .scale) | floor)x\((.height / .scale) | floor)"'
      
      # Get window geometries on active workspace
      ${pkgs.hyprland}/bin/hyprctl clients -j | ${pkgs.jq}/bin/jq -r --arg ws "$active_workspace" \
        '.[] | select(.workspace.id == ($ws | tonumber)) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
    }
    
    # Get rectangles for slurp
    RECTS=$(get_rectangles)
    
    # Freeze screen and let user select
    ${pkgs.wayfreeze}/bin/wayfreeze & 
    FREEZE_PID=$!
    sleep 0.1
    
    SELECTION=$(echo "$RECTS" | ${pkgs.slurp}/bin/slurp 2>/dev/null)
    kill $FREEZE_PID 2>/dev/null
    
    # Exit if cancelled
    [ -z "$SELECTION" ] && exit 0
    
    # Smart detection: if selection is tiny (< 20px area), assume user clicked a window
    if [[ "$SELECTION" =~ ^([0-9]+),([0-9]+)[[:space:]]([0-9]+)x([0-9]+)$ ]]; then
      click_x="''${BASH_REMATCH[1]}"
      click_y="''${BASH_REMATCH[2]}"
      sel_width="''${BASH_REMATCH[3]}"
      sel_height="''${BASH_REMATCH[4]}"
      
      # If area is less than 20 pixels, find which rectangle contains the click
      if (( sel_width * sel_height < 20 )); then
        while IFS= read -r rect; do
          if [[ "$rect" =~ ^([0-9]+),([0-9]+)[[:space:]]([0-9]+)x([0-9]+) ]]; then
            rect_x="''${BASH_REMATCH[1]}"
            rect_y="''${BASH_REMATCH[2]}"
            rect_width="''${BASH_REMATCH[3]}"
            rect_height="''${BASH_REMATCH[4]}"
            
            # Check if click is inside this rectangle
            if (( click_x >= rect_x && click_x < rect_x + rect_width && \
                  click_y >= rect_y && click_y < rect_y + rect_height )); then
              SELECTION="''${rect_x},''${rect_y} ''${rect_width}x''${rect_height}"
              break
            fi
          fi
        done <<< "$RECTS"
      fi
    fi
    
    # Take screenshot with grim and open in satty
    ${pkgs.grim}/bin/grim -g "$SELECTION" - | \
      ${pkgs.satty}/bin/satty \
        --filename - \
        --output-filename "$OUTPUT_DIR/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png" \
        --early-exit \
        --copy-command '${pkgs.wl-clipboard}/bin/wl-copy' \
        --initial-tool crop
  '';

in {
  home.packages = [
    smart-screenshot
    pkgs.satty
    pkgs.wayfreeze
    pkgs.slurp
    pkgs.grim
    pkgs.jq
  ];
}
