return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  config = function()
    require("tiny-inline-diagnostic").setup({
      options = {
        add_messages = {
          messages = false,
          display_count = true
        },
        multilines = {
          enabled = true,
          always_show = true,
        },
        show_source = {
          enabled = true,
        },
      }
    })
    vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
  end,
}
