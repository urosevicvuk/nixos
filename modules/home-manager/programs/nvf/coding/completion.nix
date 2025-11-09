# Completion engine and snippets
{ ... }:
{
  programs.nvf.settings.vim = {
    autocomplete.blink-cmp = {
      enable = true;
      friendly-snippets.enable = true;
      mappings = {
        next = "<C-n>";
        previous = "<C-p>";
        confirm = "<C-y>";
      };
      setupOpts = {
        signature.enabled = true;
        completion = {
          menu = {
            border = "rounded";
            draw = {
              columns = [
                [ "kind_icon" ]
                [
                  "label"
                  "label_description"
                ]
                [ "source_name" ]
              ];
            };
          };
          documentation = {
            window = {
              border = "rounded";
            };
          };
        };
      };
    };

    snippets.luasnip.enable = true;
  };
}
