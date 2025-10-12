{ ... }:
{
  # keyd - keyboard remapping daemon
  # Maps Caps Lock to:
  #   - Escape when tapped
  #   - Control when held
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            # Caps Lock acts as Escape when tapped, Control when held
            capslock = "overload(control, esc)";
          };
        };
      };
    };
  };
}
