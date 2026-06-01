return {
  "williamboman/mason.nvim",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  lazy = false,
  config = function()
    require("mason").setup({})

    require("mason-tool-installer").setup({
      ensure_installed = {
        "gopls",
        "html-lsp",
        "lua-language-server",
        "tailwindcss-language-server",
        "typescript-language-server",
        "vtsls",
        "vue-language-server",
        "roslyn-language-server",
        "yaml-language-server",
        "css-lsp",
        "eslint_d",
        "htmlhint",
        "netcoredbg",
        "prettier",
        "prettierd",
        "stylua",
      },
      auto_update = false,
      run_on_start = true,
    })
  end,
}
