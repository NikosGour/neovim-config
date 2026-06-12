return {
  "saghen/blink.cmp",

  dependencies = {
    -- "rafamadriz/friendly-snippets",
    "L3MON4D3/LuaSnip",
  },
  version = "1.*",

  opts = {
    keymap = {
      preset = "super-tab",
      ["<C-f>"] = { "scroll_documentation_up", "fallback" },
      ["<C-b>"] = { "scroll_documentation_down", "fallback" },
    },

    completion = { documentation = { auto_show = true } },

    sources = {
      default = {
        "lsp",
        "path",
        "snippets",
        "buffer",
      },
    },
    snippets = { preset = "luasnip" },

    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}
