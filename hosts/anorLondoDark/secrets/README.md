# Firelink Secrets Setup

## Adding Your SSH Public Key

Before installing NixOS on firelink, you need to add your SSH public key to the secrets.yaml file:

1. **Edit the secrets file:**
   ```bash
   cd ~/nixos/hosts/firelink/secrets
   sops secrets.yaml
   ```

2. **Add this line to the file:**
   ```yaml
   ssh-public-key: ssh-ed25519 YOUR_PUBLIC_KEY_HERE your@email.com
   ```
   Replace `YOUR_PUBLIC_KEY_HERE` with your actual SSH public key.

3. **Save and close the editor** (sops will automatically encrypt it)

## Notes

- The SSH public key should be in the format: `ssh-ed25519 AAAA... comment`
- You can get your public key from GitHub if you use that
- The system will read this key and add it to `~/.ssh/authorized_keys` for the vyke user
- Make sure you have the age key file at `/home/vyke/.config/sops/age/keys.txt` on the firelink machine before installation (or during first boot)
