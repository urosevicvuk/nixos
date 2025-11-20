# Auto-generate .sops.yaml from secrets configuration
# This ensures .sops.yaml is always in sync with secrets/secrets.nix
{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Generate .sops.yaml in the flake directory on every system activation
  system.activationScripts.generateSopsConfig = lib.stringAfter [ "var" ] ''
    # Get the flake directory (where this config lives)
    FLAKE_DIR="${toString ./../..}"

    # Generate .sops.yaml from the sopsConfig output
    echo "Generating .sops.yaml from secrets configuration..."
    ${pkgs.nix}/bin/nix eval --raw "$FLAKE_DIR#sopsConfig" > "$FLAKE_DIR/.sops.yaml" 2>/dev/null || true

    # Ensure proper permissions
    if [ -f "$FLAKE_DIR/.sops.yaml" ]; then
      chmod 644 "$FLAKE_DIR/.sops.yaml"
      echo "✓ .sops.yaml generated successfully"
    fi
  '';
}
