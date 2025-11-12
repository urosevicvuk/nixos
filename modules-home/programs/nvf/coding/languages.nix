# Language-specific configurations
{ ... }:
{
  programs.nvf.settings.vim.languages = {
    enableFormat = true;
    enableTreesitter = true;
    enableExtraDiagnostics = true;
    enableDAP = true;

    # Languages
    go.enable = true;
    java.enable = true;
    kotlin.enable = true;
    rust = {
      enable = true;
      crates.enable = true;
    };
    astro.enable = true;
    ts = {
      enable = true;
      extensions.ts-error-translator.enable = true;
    };
    sql.enable = true;
    python.enable = true;
    clang.enable = true;
    css.enable = true;
    tailwind.enable = true;
    html.enable = true;
    svelte.enable = true;
    bash.enable = true;
    nix.enable = true;
    markdown = {
      enable = true;
      extensions = {
        render-markdown-nvim = {
          enable = true;
        };
      };
      extraDiagnostics.enable = true;
    };
  };
}
