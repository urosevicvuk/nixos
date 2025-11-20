# Generate .sops.yaml from secrets.nix configuration
#
# Usage:
#   nix eval --raw .#sopsConfig > .sops.yaml
#   OR
#   nix run .#generate-sops-config

{
  lib ? (import <nixpkgs> { }).lib,
}:

let
  secrets = import ./secrets.nix;

  # Helper to create key references
  mkKeyRef = name: "&${name}";

  # Helper to create creation rules
  mkCreationRule =
    { path_regex, keys }:
    {
      inherit path_regex;
      key_groups = [
        {
          ssh_ed25519 = keys;
        }
      ];
    };

  # Generate YAML (simple string generation)
  toYAML =
    value:
    if builtins.isAttrs value then
      lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          k: v:
          if builtins.isList v then
            "${k}:\n" + lib.concatMapStringsSep "\n" (item: "  - ${toYAML item}") v
          else if builtins.isAttrs v then
            "${k}:\n" + lib.concatMapStringsSep "\n" (line: "  ${line}") (lib.splitString "\n" (toYAML v))
          else
            "${k}: ${toYAML v}"
        ) value
      )
    else if builtins.isList value then
      lib.concatMapStringsSep "\n" (item: "- ${toYAML item}") value
    else if builtins.isString value then
      if lib.hasPrefix "&" value || lib.hasPrefix "*" value then
        value # Don't quote YAML anchors/aliases
      else
        value # Simple string, no quotes needed for most cases
    else
      toString value;

  # Build the .sops.yaml structure
  sopsConfig = {
    # Define all keys with anchors
    keys =
      # User keys
      lib.mapAttrsToList (name: key: mkKeyRef "user_${name}" + " ${key}") secrets.keys.users
      ++
        # Host keys (filter out empty ones)
        lib.mapAttrsToList (name: key: mkKeyRef "host_${name}" + " ${key}") (
          lib.filterAttrs (n: v: v != "") secrets.keys.hosts
        );

    # Creation rules
    creation_rules =
      # Per-host secrets (only user key by default)
      lib.mapAttrsToList (
        host: paths:
        let
          # Use user keys + host key if it exists
          keys = [
            "*user_vyke"
          ]
          ++ (if secrets.keys.hosts.${host} or "" != "" then [ "*host_${host}" ] else [ ]);
        in
        mkCreationRule {
          path_regex = "secrets/${host}/.*\\.yaml$";
          inherit keys;
        }
      ) (removeAttrs secrets.secretPaths [ "shared" ])
      ++
        # Shared secrets (all keys)
        (
          if secrets.secretPaths.shared or [ ] != [ ] then
            [
              {
                path_regex = "secrets/shared/.*\\.yaml$";
                key_groups = [
                  {
                    ssh_ed25519 = [
                      "*user_vyke"
                    ]
                    ++ (lib.mapAttrsToList (name: _: "*host_${name}") (
                      lib.filterAttrs (n: v: v != "") secrets.keys.hosts
                    ));
                  }
                ];
              }
            ]
          else
            [ ]
        );
  };

in
# Generate the YAML config
''
  # ═══════════════════════════════════════════════════════════════════════
  # SOPS Configuration
  # Auto-generated from secrets/secrets.nix
  #
  # To regenerate: nix eval --raw .#sopsConfig > .sops.yaml
  # ═══════════════════════════════════════════════════════════════════════

  keys:
    # User keys (for editing secrets)
    - &user_vyke ${secrets.keys.users.vyke}

  ${lib.optionalString (
    secrets.keys.hosts.ariandel != ""
  ) "  - &host_ariandel ${secrets.keys.hosts.ariandel}"}
  ${lib.optionalString (
    secrets.keys.hosts.anorLondo != ""
  ) "  - &host_anorLondo ${secrets.keys.hosts.anorLondo}"}
  ${lib.optionalString (
    secrets.keys.hosts.firelink != ""
  ) "  - &host_firelink ${secrets.keys.hosts.firelink}"}

  creation_rules:
    # Secrets for ariandel
    - path_regex: secrets/ariandel/.*\.yaml$
      key_groups:
        - ssh_ed25519:
            - *user_vyke
  ${lib.optionalString (secrets.keys.hosts.ariandel != "") "          - *host_ariandel"}

    # Secrets for anorLondo
    - path_regex: secrets/anorLondo/.*\.yaml$
      key_groups:
        - ssh_ed25519:
            - *user_vyke
  ${lib.optionalString (secrets.keys.hosts.anorLondo != "") "          - *host_anorLondo"}

    # Secrets for firelink
    - path_regex: secrets/firelink/.*\.yaml$
      key_groups:
        - ssh_ed25519:
            - *user_vyke
  ${lib.optionalString (secrets.keys.hosts.firelink != "") "          - *host_firelink"}

    # Shared secrets (all hosts)
    - path_regex: secrets/shared/.*\.yaml$
      key_groups:
        - ssh_ed25519:
            - *user_vyke
  ${lib.optionalString (secrets.keys.hosts.ariandel != "") "          - *host_ariandel"}
  ${lib.optionalString (secrets.keys.hosts.anorLondo != "") "          - *host_anorLondo"}
  ${lib.optionalString (secrets.keys.hosts.firelink != "") "          - *host_firelink"}
''
