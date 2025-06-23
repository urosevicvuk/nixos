{ config, lib, ... }: {
  imports = [
    # Choose your theme here:
    ../../themes/gruvbox.nix
  ];
  config.var = {
    hostname = "anorLondo";
    username = "vyke";
    configDirectory = "/home/" + config.var.username
      + "/nixos"; # The path of the nixos configuration directory

    keyboardLayout = "us";
    keyboardVariant = "";

    location = "Belgrade";
    timeZone = "Europe/Belgrade";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "fr_FR.UTF-8";

    git = {
      username = "urosevicvuk";
      email = "vuk23urosevic@gmail.com";
    };

    autoUpgrade = false;
    autoGarbageCollector = true;

    # Choose your theme variables here
    theme = import ../../themes/var/gruvbox.nix;
  };

  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
