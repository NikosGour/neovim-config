return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
  },
  config = function()
    require "configs.nvim-dap"
  end,
  event = "VeryLazy",
}
