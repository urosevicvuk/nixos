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

            # Left Alt (physical): Super when held, Enter when tapped
            leftalt = "overload(meta, enter)";
            rightalt = "overload(alt, backspace)";

            # Left Super (physical): Alt when held, Backspace when tapped
            leftmeta = "overload(alt, backspace)";
          };

          # Tapping both shift keys together activates capslock
          shift = {
            leftshift = "capslock";
            rightshift = "capslock";
          };
        };
      };
    };
  };
}
