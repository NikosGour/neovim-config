return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nsidorenco/neotest-vstest",
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-vstest"),
        },
      })
    end,
  },
  { "nsidorenco/neotest-vstest" },
  {
    "ramboe/ramboe-dotnet-utils",
    dependencies = { "mfussenegger/nvim-dap" },
  },
}
