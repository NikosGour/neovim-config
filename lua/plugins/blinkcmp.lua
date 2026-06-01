return {
  "saghen/blink.cmp",

  dependencies = { 'rafamadriz/friendly-snippets' },
  version = "1.*",

  opts = {
    keymap = {
      preset = "super-tab",
      ['<C-f>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-b>'] = { 'scroll_documentation_down', 'fallback' },
    },

    completion = { documentation = { auto_show = true } },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" }
    },

    fuzzy = { implementation = "prefer_rust_with_warning" }

  },
}
