# Secrets configuration for sops-nix
# This file defines all keys AND generates the .sops.yaml configuration
#
# Usage:
#   - Imported by flake.nix as `sopsConfig` output
#   - Auto-regenerates .sops.yaml on every `nixos-rebuild switch`

{ lib ? (import <nixpkgs> { }).lib }:

let
  # ═══════════════════════════════════════════════════════════════════════
  # CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════

  # Your SSH public key (used to encrypt all secrets)
  userKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQpgKiftVTzqkfu6zbRpvZFtWZH/HBQSj6DhuVvVRul vuk23urosevic@gmail.com";

  # Host SSH keys (optional - leave empty to use only your personal key)
  # Get these from: ssh-keyscan hostname or cat /etc/ssh/ssh_host_ed25519_key.pub
  hostKeys = {
    ariandel = "";  # ssh-ed25519 AAAAC3...
    anorLondo = ""; # ssh-ed25519 AAAAC3...
    firelink = "";  # ssh-ed25519 AAAAC3...
  };

  # ═══════════════════════════════════════════════════════════════════════
  # YAML GENERATION (Simple string interpolation)
  # ═══════════════════════════════════════════════════════════════════════

  # Helper to conditionally include host keys in rules
  hostKeyLine = name:
    lib.optionalString (hostKeys.${name} != "") "          - *host_${name}";

in
# Generate .sops.yaml as a string
''
  # ═══════════════════════════════════════════════════════════════════════
  # SOPS Configuration
  # Auto-generated from secrets/default.nix
  #
  # To regenerate: nix eval --raw .#sopsConfig > .sops.yaml
  # (Happens automatically on nixos-rebuild switch)
  # ═══════════════════════════════════════════════════════════════════════

  keys:
    # User keys (for editing secrets)
    - &user_vyke ${userKey}

  ${lib.optionalString (hostKeys.ariandel != "") "  - &host_ariandel ${hostKeys.ariandel}"}
  ${lib.optionalString (hostKeys.anorLondo != "") "  - &host_anorLondo ${hostKeys.anorLondo}"}
  ${lib.optionalString (hostKeys.firelink != "") "  - &host_firelink ${hostKeys.firelink}"}

  creation_rules:
    # Secrets for ariandel (laptop)
    - path_regex: secrets/ariandel/.*\.yaml$
      key_groups:
        - ssh_ed25519:
            - *user_vyke
  ${hostKeyLine "ariandel"}

    # Secrets for anorLondo (desktop)
    - path_regex: secrets/anorLondo/.*\.yaml$
      key_groups:
        - ssh_ed25519:
            - *user_vyke
  ${hostKeyLine "anorLondo"}

    # Secrets for firelink (server)
    - path_regex: secrets/firelink/.*\.yaml$
      key_groups:
        - ssh_ed25519:
            - *user_vyke
  ${hostKeyLine "firelink"}

    # Shared secrets (all hosts)
    - path_regex: secrets/shared/.*\.yaml$
      key_groups:
        - ssh_ed25519:
            - *user_vyke
  ${hostKeyLine "ariandel"}
  ${hostKeyLine "anorLondo"}
  ${hostKeyLine "firelink"}
''
