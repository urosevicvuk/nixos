{ config, ... }: {
  imports = [ ../../nixos/variables-config.nix ];

  config.var = {
    hostname = "desktop";
    username = "vuk23";
    configDirectory = "/home/" + config.var.username
      + "/nixos"; # The path of the nixos configuration directory

    keyboardLayout = "us";

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
    theme = import ../../themes/var/yoru.nix;
  };
}
