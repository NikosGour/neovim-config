return {
  "williamboman/mason.nvim",
  lazy = false,
  opts = {
    registries = {
      "github:mason-org/mason-registry",
      "github:Crashdummyy/mason-registry",
    },
    ensure_installed = {
      "gopls",
      "html-lsp",
      "lua-language-server",
      "tailwindcss-language-server",
      "typescript-language-server",
      "vtsls",
      "vue-language-server",
      "roslyn_ls",
    }
  }
}
