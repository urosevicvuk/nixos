{ pkgs, ... }:
{
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # This is the correct way to set quantum in NixOS
    configPackages = [
      (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/99-custom-quantum.conf" ''
        context.properties = {
        default.clock.quantum = 128
        default.clock.min-quantum = 32
        default.clock.max-quantum = 2048
        default.clock.rate = 44100
        }
      '')
    ];

    wireplumber = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/99-alsa-config.conf" ''
                   monitor.alsa.rules = [
                   {
                   matches = [
                   {
          # This matches all ALSA devices
                   device.name = "~alsa_card.*"
                   }
                   ]
                   actions = {
                   update-props = {
                   api.alsa.period-size = 1024
                   api.alsa.headroom = 8192
                   }
                   }
                   }
                   ]
        '')
      ];
      extraConfig = {
        "10-disable-camera" = {
          "wireplumber.profiles" = {
            main."monitor.libcamera" = "disabled";
          };
        };
      };
    };
  };
}
