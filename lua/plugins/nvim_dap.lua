return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "leoluz/nvim-dap-go",
  },
  config = function()
    require("configs.nvim-dap")
    require("dap-go").setup()
  end,
  event = "VeryLazy",
}
