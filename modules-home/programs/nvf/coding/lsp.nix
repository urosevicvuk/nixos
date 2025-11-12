# LSP infrastructure and ALL LSP keymaps
{ ... }:
{
  programs.nvf.settings.vim = {
    lsp = {
      enable = true;
      trouble.enable = true;
      lspconfig.enable = true;
      formatOnSave = true;
      inlayHints.enable = true;
      null-ls.enable = true;

      otter-nvim = {
        enable = true;
        setupOpts = {
          buffers.set_filetype = true;
          lsp = {
            diagnostic_update_event = [
              "BufWritePost"
              "InsertLeave"
            ];
          };
        };
      };

      lspkind.enable = true;

      lspsaga = {
        enable = true;
        setupOpts = {
          ui = {
            code_action = "";
          };
          lightbulb = {
            sign = false;
            virtual_text = true;
          };
          breadcrumbs.enable = false;
        };
      };
    };

    # ALL LSP keymaps consolidated here
    keymaps = [
      # Hover and code actions
      {
        key = "K";
        mode = "n";
        silent = true;
        action = "<cmd>lua vim.lsp.buf.hover()<cr>";
        desc = "LSP Hover";
      }
      {
        key = "<M-CR>";
        mode = [
          "n"
          "v"
        ];
        silent = true;
        action = "<cmd>Lspsaga code_action<cr>";
        desc = "Code Actions";
      }

      # LSP Navigation (from old picker.nix)
      {
        key = "gd";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.lsp_definitions()<cr>";
        desc = "Go to definition";
      }
      {
        key = "gD";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.lsp_declarations()<cr>";
        desc = "Go to declaration";
      }
      {
        key = "gr";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.lsp_references()<cr>";
        desc = "Find references";
      }
      {
        key = "gI";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.lsp_implementations()<cr>";
        desc = "Go to implementation";
      }
      {
        key = "gy";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.lsp_type_definitions()<cr>";
        desc = "Go to type definition";
      }
      {
        key = "<leader>fs";
        mode = "n";
        silent = true;
        action = "<cmd>lua Snacks.picker.lsp_symbols()<cr>";
        desc = "LSP symbols";
      }
    ];
  };
}
