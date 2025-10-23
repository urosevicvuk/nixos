{
  pkgs,
  inputs,
  config,
  ...
}:
{
  virtualisation = {
    libvirtd = {
      enable = true;
      package = with pkgs.stable; libvirt;
      qemu = {
        package = with pkgs.stable; qemu;
        swtpm = {
          enable = false;
          package = with pkgs.stable; swtpm;
        };
      };
    };
    spiceUSBRedirection.enable = true;
  };
  users.users.${config.var.username}.extraGroups = [ "libvirtd" ];
  services.spice-vdagentd.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = [
    inputs.winboat.packages.${pkgs.system}.winboat
    pkgs.freerdp
  ];
}
