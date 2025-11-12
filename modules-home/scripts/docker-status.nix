# - ## Docker Status
#-
#- Shows the number of running Docker containers in hyprpanel.
#- Displays container count with icon and detailed tooltip on hover.
#-
#- - `docker-status` - Check running Docker containers and output JSON for hyprpanel.

{ pkgs, ... }:
let
  docker-status = pkgs.writeShellScriptBin "docker-status" ''
    # Check if Docker is available
    if ! command -v docker &> /dev/null; then
      exit 0
    fi

    # Check if Docker daemon is running
    if ! docker info &> /dev/null; then
      exit 0
    fi

    # Get count of running containers
    container_count=$(docker ps --format '{{.Names}}' 2>/dev/null | wc -l)

    # Only show if there are running containers
    if [ "$container_count" -gt 0 ]; then
      # Get container names for tooltip
      container_names=$(docker ps --format '{{.Names}}' 2>/dev/null | tr '\n' ', ' | sed 's/, $//')

      # Build the output
      icon="🐋"
      text="$icon - $container_count "

      # Create tooltip with container details
      if [ "$container_count" -eq 1 ]; then
        tooltip="1 container running: $container_names"
      else
        tooltip="$container_count containers running: $container_names"
      fi

      # Output JSON for hyprpanel
      echo "{\"text\": \"$text \", \"tooltip\": \"$tooltip\", \"alt\": \"active\"}"
    fi
    # Output nothing when no containers are running (for hideOnEmpty to work)
  '';

in
{
  home.packages = [ docker-status ];
}
