{ config, lib, ... }:
{
  # Tailscale-Only SSH Access
  # Configure SSH to only accept connections via Tailscale VPN
  #
  # This module is NOT imported yet - it's for firelink (server) only
  #
  # ═══════════════════════════════════════════════════════════════════════
  # WHAT THIS DOES
  # ═══════════════════════════════════════════════════════════════════════
  #
  # Instead of exposing SSH to the public internet, this configuration:
  # 1. Listens for SSH ONLY on the Tailscale network interface
  # 2. Blocks all SSH access from public internet
  # 3. Allows SSH from any device on your Tailscale network
  #
  # Benefits:
  # ✓ No public SSH exposure = no brute force attacks
  # ✓ No need to manage firewall rules for SSH
  # ✓ Access from anywhere via Tailscale
  # ✓ End-to-end encrypted via WireGuard
  # ✓ Works through NAT/firewalls
  # ✓ Access controlled via Tailscale ACLs
  #
  # ═══════════════════════════════════════════════════════════════════════
  # PREREQUISITES
  # ═══════════════════════════════════════════════════════════════════════
  #
  # 1. Tailscale must be installed and running on firelink
  # 2. firelink must have joined your Tailnet
  # 3. You need Tailscale on the client devices you SSH from
  #
  # Verify Tailscale is working:
  #    sudo tailscale status
  #    (Should show your Tailnet devices)
  #
  # Get firelink's Tailscale IP:
  #    tailscale ip -4
  #    (Will be something like 100.x.x.x)
  #
  # ═══════════════════════════════════════════════════════════════════════
  # CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════

  services.openssh = {
    enable = true;

    # DO NOT open firewall for SSH (blocks public access)
    openFirewall = false;

    # Listen ONLY on Tailscale interface
    # Note: After first boot, check `tailscale ip -4` and update this IP
    listenAddresses = [
      {
        addr = "100.64.0.1"; # PLACEHOLDER - Update with actual Tailscale IP after setup!
        port = 22;
      }
    ];

    settings = {
      # Security hardening
      PasswordAuthentication = false;  # SSH keys only
      PermitRootLogin = "no";          # No root login
      KbdInteractiveAuthentication = false;

      # Performance
      UseDNS = false;

      # X11 forwarding (if needed)
      X11Forwarding = false;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════
  # IMPORTANT: UPDATE TAILSCALE IP AFTER FIRST BOOT
  # ═══════════════════════════════════════════════════════════════════════
  #
  # 1. After installing NixOS on firelink, boot the system
  #
  # 2. Get the actual Tailscale IP:
  #    tailscale ip -4
  #
  # 3. Update this module with the real IP:
  #    Replace "100.64.0.1" with your actual Tailscale IP
  #
  # 4. Rebuild:
  #    sudo nixos-rebuild switch
  #
  # 5. Test SSH access from another Tailscale device:
  #    ssh vyke@<tailscale-ip>
  #    OR
  #    ssh vyke@firelink  # If you set up Tailscale MagicDNS
  #
  # ═══════════════════════════════════════════════════════════════════════
  # ALTERNATIVE: Use Tailscale Hostname
  # ═══════════════════════════════════════════════════════════════════════
  #
  # If you enable Tailscale MagicDNS, you can also listen on all interfaces
  # and use firewall rules instead:
  #
  # networking.firewall = {
  #   enable = true;
  #   # Only allow SSH from Tailscale network (100.64.0.0/10)
  #   extraCommands = ''
  #     iptables -A INPUT -i tailscale0 -p tcp --dport 22 -j ACCEPT
  #     iptables -A INPUT -p tcp --dport 22 -j DROP
  #   '';
  # };
  #
  # This approach allows:
  # - ssh vyke@firelink  (via Tailscale hostname)
  # - Automatically blocks non-Tailscale SSH attempts
  #
  # ═══════════════════════════════════════════════════════════════════════
  # ACCESSING YOUR SERVER
  # ═══════════════════════════════════════════════════════════════════════
  #
  # From laptop (ariandel) or desktop (anorLondo):
  #
  # 1. Ensure Tailscale is running:
  #    sudo tailscale up
  #
  # 2. Check you can see firelink:
  #    tailscale status | grep firelink
  #
  # 3. SSH to firelink:
  #    ssh vyke@<firelink-tailscale-ip>
  #    OR
  #    ssh vyke@firelink  # If MagicDNS is enabled
  #
  # 4. Optional: Add to ~/.ssh/config for convenience:
  #    Host firelink
  #      HostName <tailscale-ip-or-hostname>
  #      User vyke
  #      ForwardAgent yes
  #
  #    Then just: ssh firelink
  #
  # ═══════════════════════════════════════════════════════════════════════
  # SECURITY BENEFITS
  # ═══════════════════════════════════════════════════════════════════════
  #
  # Traditional SSH setup (public internet):
  # - Exposed to constant brute force attempts
  # - Need fail2ban or similar protection
  # - Security through obscurity (non-standard ports)
  # - Still vulnerable to zero-day SSH exploits
  #
  # Tailscale-only SSH:
  # ✓ Zero public exposure
  # ✓ No brute force attempts (not discoverable)
  # ✓ WireGuard encryption (in addition to SSH encryption)
  # ✓ Tailscale ACLs for access control
  # ✓ Audit logs via Tailscale admin panel
  # ✓ Can revoke access by removing device from Tailnet
  #
  # ═══════════════════════════════════════════════════════════════════════
  # TROUBLESHOOTING
  # ═══════════════════════════════════════════════════════════════════════
  #
  # Cannot SSH to firelink:
  # 1. Check Tailscale is running on both machines:
  #    sudo tailscale status
  #
  # 2. Verify firelink's Tailscale IP:
  #    tailscale ip -4  # Run on firelink
  #
  # 3. Check SSH is listening on Tailscale interface:
  #    sudo ss -tlnp | grep :22
  #    (Should show listening on 100.x.x.x:22)
  #
  # 4. Test connectivity:
  #    tailscale ping firelink
  #
  # 5. Check SSH logs on firelink:
  #    sudo journalctl -u sshd -f
  #
  # Still can't connect?
  # - Temporarily listen on all interfaces to debug
  # - Check Tailscale ACLs in admin panel
  # - Verify SSH keys are properly set up
  #
  # ═══════════════════════════════════════════════════════════════════════
}
