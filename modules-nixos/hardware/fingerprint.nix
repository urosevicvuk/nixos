{ config, lib, ... }:
let
  inherit (config.var) device;
  isLaptop = device == "laptop";
in
{
  # Framework AMD fingerprint reader fix
  # Prevents USB controller from dying on resume after long suspend periods
  #
  # Issue: After suspend (especially 30+ min), the xHCI USB controller at c1:00.4
  # fails to resume with error: "xHCI host controller not responding, assume dead"
  # This causes the Goodix fingerprint reader to disconnect from USB entirely.
  #
  # Root cause: AMD APU xHCI controller has buggy USB autosuspend behavior that
  # causes it to enter a deep power state it cannot recover from on resume.
  #
  # Solution: Disable autosuspend for this specific USB controller via udev rule.
  # The controller stays active (minimal power impact ~0.1-0.5W) but always works.
  #
  # References:
  # - Framework Community: Fingerprint reader issues after suspend
  # - Red Hat Bug #1196943: USB autosuspend breaks xHCI on AMD APU chipsets
  # - Arch Wiki: Framework Laptop 13 AMD suspend problems

  #services.udev.extraRules = lib.mkIf isLaptop ''
  #  # Disable autosuspend for Framework AMD USB controller (fingerprint reader)
  #  # Targets PCI device 0000:c1:00.4 (AMD xHCI USB controller)
  #  ACTION=="add", SUBSYSTEM=="pci", KERNEL=="0000:c1:00.4", ATTR{power/control}="on"
  #'';
}
