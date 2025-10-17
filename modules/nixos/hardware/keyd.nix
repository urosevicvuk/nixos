{ ... }:
{
  # keyd - keyboard remapping daemon
  # Handles all keyboard remapping at system level
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            # Caps Lock acts as Escape when tapped, Control when held
            capslock = "overload(control, esc)";

            # Both shifts together toggle Caps Lock
            leftshift+rightshift = "capslock";

            # Swap left Alt and left Super (Windows key)
            leftalt = "leftmeta";
            leftmeta = "leftalt";
          };
        };
      };
    };
  };
}
