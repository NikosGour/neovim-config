return {
  "nvim-mini/mini.nvim",
  version = "*",
  config = function()
    require("mini.ai").setup({
      n_lines = 999999,
    })
    require("mini.comment").setup({ mappings = { comment_line = "<Leader>b", comment_visual = "<Leader>b" } })
    -- require("mini.move").setup({})
    require("mini.pairs").setup({})
    -- require("mini.splitjoin").setup({}) look into it later
    require("mini.surround").setup({})
    -- require("mini.bracketed").setup({}) look into it later
    require("mini.jump").setup({})
  end,
}
