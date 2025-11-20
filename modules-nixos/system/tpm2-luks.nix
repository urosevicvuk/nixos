{ config, lib, pkgs, ... }:
{
  # TPM2 LUKS Auto-Unlock
  # Automatically unlock LUKS encryption using TPM2 chip
  #
  # This module is NOT imported yet - it's for ariandel (laptop) only
  #
  # ═══════════════════════════════════════════════════════════════════════
  # WHAT THIS DOES
  # ═══════════════════════════════════════════════════════════════════════
  #
  # TPM2 (Trusted Platform Module 2.0) is a hardware security chip that can:
  # 1. Store encryption keys securely
  # 2. Only release keys when system state matches expectations
  # 3. Detect tampering (Secure Boot disabled, bootloader modified, etc.)
  #
  # With TPM2 + LUKS:
  # - Normal boot: Auto-unlock (no password needed)
  # - Tampered boot: Fall back to password
  # - Stolen laptop with different firmware: Password required
  #
  # Security features:
  # ✓ Automatic unlock on trusted boot
  # ✓ Password fallback if TPM check fails
  # ✓ Protection against evil maid attacks
  # ✓ Binds encryption to Secure Boot state
  #
  # ═══════════════════════════════════════════════════════════════════════
  # SETUP INSTRUCTIONS
  # ═══════════════════════════════════════════════════════════════════════
  #
  # 1. INSTALL NIXOS WITH LUKS (using disko config)
  #
  # 2. BOOT INTO NEW SYSTEM (will require password)
  #
  # 3. ENROLL TPM2 FOR AUTO-UNLOCK:
  #    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/nvme0n1p2
  #
  #    PCR explanation:
  #    - PCR 0: Firmware and UEFI settings
  #    - PCR 7: Secure Boot state
  #
  #    (This binds unlock to: firmware + Secure Boot enabled)
  #
  # 4. VERIFY ENROLLMENT:
  #    sudo systemd-cryptenroll /dev/nvme0n1p2
  #    (Should show "tpm2" in enrollment list)
  #
  # 5. REBOOT AND TEST:
  #    Should auto-unlock without password!
  #
  # 6. IF AUTO-UNLOCK FAILS:
  #    - Check Secure Boot is enabled: bootctl status
  #    - Check TPM2 is accessible: systemd-cryptenroll --tpm2-device=list
  #    - System will fall back to password automatically
  #
  # ═══════════════════════════════════════════════════════════════════════
  # CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════

  # Enable systemd in initrd (required for TPM2 support)
  boot.initrd.systemd.enable = true;

  # TPM2 support in initrd
  boot.initrd.availableKernelModules = [ "tpm_crb" "tpm_tis" ];

  # Ensure TPM2 tools are available
  environment.systemPackages = with pkgs; [
    tpm2-tools  # For managing TPM2
  ];

  # ═══════════════════════════════════════════════════════════════════════
  # ADVANCED: RE-ENROLLMENT AFTER CHANGES
  # ═══════════════════════════════════════════════════════════════════════
  #
  # If you update firmware, change Secure Boot keys, or modify bootloader,
  # the TPM2 state changes and auto-unlock will fail.
  #
  # To re-enroll after such changes:
  #
  # 1. Boot with password (TPM2 won't work yet)
  # 2. Wipe old TPM2 enrollment:
  #    sudo systemd-cryptenroll /dev/nvme0n1p2 --wipe-slot=tpm2
  # 3. Re-enroll with new state:
  #    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/nvme0n1p2
  # 4. Reboot to test
  #
  # ═══════════════════════════════════════════════════════════════════════
  # SECURITY CONSIDERATIONS
  # ═══════════════════════════════════════════════════════════════════════
  #
  # What TPM2 DOES protect against:
  # ✓ Physical theft (different hardware = no unlock)
  # ✓ Evil maid attacks (bootloader tampering detected)
  # ✓ Secure Boot bypass attempts
  #
  # What TPM2 DOES NOT protect against:
  # ✗ Attacks while system is running (use full disk encryption for this)
  # ✗ Firmware-level attacks (nation-state level threats)
  # ✗ Someone with your password
  #
  # Best practices:
  # - Always keep password as fallback
  # - Enable BIOS password in addition
  # - Use strong LUKS passphrase
  # - Keep Secure Boot enabled
  #
  # ═══════════════════════════════════════════════════════════════════════
}
