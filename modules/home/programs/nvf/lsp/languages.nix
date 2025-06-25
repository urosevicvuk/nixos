{ lib, ... }:
{
  programs.nvf.settings.vim = {

    diagnostics = {
      enable = true;
      config = {
        signs = {
          text = {
            "vim.diagnostic.severity.Error" = " ";
            "vim.diagnostic.severity.Warn" = " ";
            "vim.diagnostic.severity.Hint" = " ";
            "vim.diagnostic.severity.Info" = " ";
          };
        };
        underline = true;
        update_in_insert = true;
        virtual_text = {
          format =
            lib.generators.mkLuaInline
              # lua
              ''
                function(diagnostic)
                  return string.format("%s", diagnostic.message)
                  --return string.format("%s (%s)", diagnostic.message, diagnostic.source)
                end
              '';
        };
      };
      nvim-lint = {
        enable = true;
      };
    };

    syntaxHighlighting = true;

    treesitter = {
      enable = true;
      autotagHtml = true;
      context = {
        enable = true;
        setupOpts = {
          line_number = true;
        };
      };
      highlight.enable = true;
    };

    lsp = {
      enable = true;
      trouble.enable = true;
      lspSignature.enable = true;
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

    languages = {
      enableDAP = true;
      astro.enable = true;
      go.enable = true;

      markdown = {
        enable = true;
        extensions = {
          render-markdown-nvim = {
            enable = true;
          };
        };
        extraDiagnostics.enable = true;
      };
      ts = {
        enable = true;
        extensions.ts-error-translator.enable = true;
      };
      java = {
        enable = true;
        lsp.enable = true;
      };
      kotlin = {
        enable = true;
        lsp.enable = true;
      };
      sql.enable = true;
      python.enable = true;
      clang.enable = true;
      css.enable = true;
      svelte.enable = true;
      html.enable = true;
      bash.enable = true;
      nix.enable = true;
      tailwind.enable = true;
    };

    formatter = {
      conform-nvim = {
        enable = true;
      };
    };
  };
}
