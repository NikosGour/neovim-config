return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    -- optional but recommended
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    require("telescope").setup({
      defaults = {
        layout_strategy = "vertical",
        layout_config = {
          vertical = {
            prompt_position = "top",
            mirror = true,

            width = 0.9,
            height = 0.95,

            preview_height = 0.7,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          frllow = true,
        },
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
        buffers = {
          sort_mru = true,
          sort_lastused = true,
        },
      },
    })

    require("telescope").load_extension("ui-select")
    require("telescope").load_extension("notify")
  end,
}
