# Keybindings Viewer - Searchable cheatsheet of all keybindings
{ pkgs, config, ... }:
let
  show-keybindings = pkgs.writeShellScriptBin "show-keybindings" ''
    # Extract keybindings from the documented bindings file
    bindings_file="${config.var.configDirectory}/modules/home-manager/system/hyprland/bindings-documented.nix"
    
    if [ ! -f "$bindings_file" ]; then
      ${pkgs.libnotify}/bin/notify-send "Keybindings" "Bindings file not found!"
      exit 1
    fi
    
    # Parse keybindings and descriptions
    keybindings=$(${pkgs.gnugrep}/bin/grep -E '^\s*".*#' "$bindings_file" | \
      ${pkgs.gnused}/bin/sed -E 's/^\s*"([^"]+)".*#\s*(.*)$/\2|\1/' | \
      ${pkgs.coreutils}/bin/sort)
    
    if [ -z "$keybindings" ]; then
      ${pkgs.libnotify}/bin/notify-send "Keybindings" "No keybindings found!"
      exit 1
    fi
    
    # Display with Walker
    selected=$(echo "$keybindings" | \
      ${pkgs.gnused}/bin/sed 's/|/ → /' | \
      ${pkgs.walker}/bin/walker --dmenu)
    
    if [ -n "$selected" ]; then
      # Extract just the description part
      description=$(echo "$selected" | ${pkgs.gawk}/bin/awk -F' → ' '{print $1}')
      ${pkgs.libnotify}/bin/notify-send "Keybinding" "$description"
    fi
  '';
  
  show-keybindings-by-category = pkgs.writeShellScriptBin "show-keybindings-by-category" ''
    categories=(
      "All Keybindings"
      "Launcher & Menu"
      "Window Management"
      "Applications"
      "Focus & Movement"
      "Screenshots"
      "System & Utilities"
      "Workspaces"
      "Audio & Media"
    )
    
    selected_category=$(printf '%s\n' "''${categories[@]}" | ${pkgs.walker}/bin/walker --dmenu)
    
    case "$selected_category" in
      "All Keybindings")
        show-keybindings
        ;;
      "Launcher & Menu")
        show-keybindings | ${pkgs.gnugrep}/bin/grep -E "Launch:|Menu:"
        ;;
      "Window Management")
        show-keybindings | ${pkgs.gnugrep}/bin/grep -E "Window:|Layout:|Toggle:"
        ;;
      "Applications")
        show-keybindings | ${pkgs.gnugrep}/bin/grep -E "App:|TUI:"
        ;;
      "Focus & Movement")
        show-keybindings | ${pkgs.gnugrep}/bin/grep -E "Focus:|Move:|Monitor:"
        ;;
      "Screenshots")
        show-keybindings | ${pkgs.gnugrep}/bin/grep "Screenshot:"
        ;;
      "System & Utilities")
        show-keybindings | ${pkgs.gnugrep}/bin/grep -E "System:|Display:|Keyboard:"
        ;;
      "Workspaces")
        show-keybindings | ${pkgs.gnugrep}/bin/grep "Workspace:"
        ;;
      "Audio & Media")
        show-keybindings | ${pkgs.gnugrep}/bin/grep -E "Audio:|Media:"
        ;;
    esac
  '';
  
  # HTML cheatsheet generator
  generate-keybindings-html = pkgs.writeShellScriptBin "generate-keybindings-html" ''
    output_file="$HOME/.config/keybindings-cheatsheet.html"
    bindings_file="${config.var.configDirectory}/modules/home-manager/system/hyprland/bindings-documented.nix"
    
    # Parse keybindings
    keybindings=$(${pkgs.gnugrep}/bin/grep -E '^\s*".*#' "$bindings_file" | \
      ${pkgs.gnused}/bin/sed -E 's/^\s*"([^"]+)".*#\s*(.*)$/\2|\1/')
    
    # Generate HTML
    cat > "$output_file" << 'EOF'
<!DOCTYPE html>
<html>
<head>
  <title>Hyprland Keybindings</title>
  <style>
    body {
      font-family: 'SF Pro', 'Inter', sans-serif;
      background: #282828;
      color: #d5c4a1;
      padding: 20px;
      max-width: 1200px;
      margin: 0 auto;
    }
    h1 { color: #83a598; }
    table {
      width: 100%;
      border-collapse: collapse;
      margin: 20px 0;
    }
    th, td {
      padding: 12px;
      text-align: left;
      border-bottom: 1px solid #3c3836;
    }
    th {
      background: #3c3836;
      color: #83a598;
    }
    tr:hover {
      background: #3c3836;
    }
    .category {
      color: #b8bb26;
      font-weight: bold;
    }
    .key {
      background: #3c3836;
      padding: 4px 8px;
      border-radius: 4px;
      font-family: monospace;
      color: #fabd2f;
    }
  </style>
</head>
<body>
  <h1>Hyprland Keybindings Cheatsheet</h1>
  <table>
    <thead>
      <tr>
        <th>Category</th>
        <th>Description</th>
        <th>Keybinding</th>
      </tr>
    </thead>
    <tbody>
EOF
    
    # Add rows
    echo "$keybindings" | while IFS='|' read -r desc key; do
      category=$(echo "$desc" | ${pkgs.coreutils}/bin/cut -d: -f1)
      description=$(echo "$desc" | ${pkgs.coreutils}/bin/cut -d: -f2-)
      echo "      <tr>" >> "$output_file"
      echo "        <td class=\"category\">$category</td>" >> "$output_file"
      echo "        <td>$description</td>" >> "$output_file"
      echo "        <td><span class=\"key\">$key</span></td>" >> "$output_file"
      echo "      </tr>" >> "$output_file"
    done
    
    cat >> "$output_file" << 'EOF'
    </tbody>
  </table>
</body>
</html>
EOF
    
    ${pkgs.libnotify}/bin/notify-send "Cheatsheet Generated" "Saved to: $output_file"
    zen "$output_file"
  '';

in {
  home.packages = [
    show-keybindings
    show-keybindings-by-category
    generate-keybindings-html
  ];
}
