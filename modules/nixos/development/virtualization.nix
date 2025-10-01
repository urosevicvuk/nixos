{ pkgs, ... }:

{
  # Enable KVM virtualization
  boot.kernelModules = [
    "kvm-amd"
    "vfio-pci"
  ];

  # Virtualization services
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true; # TPM support for Windows 11
        ovmf.enable = true; # UEFI firmware
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };

    spiceUSBRedirection.enable = true; # USB device redirection
  };

  # Management tools
  programs.virt-manager.enable = true;

  # Additional packages
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio # Windows VirtIO drivers
    win-spice # Windows SPICE guest tools
    swtpm # Software TPM for Windows 11
  ];

  # Networking for VMs
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  # Performance optimizations
  boot.kernel.sysctl = {
    "vm.nr_hugepages" = 1024; # Huge pages for better performance
  };
}
