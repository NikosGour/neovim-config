local dapui = require("dapui")
local dap = require("dap")

--- open ui immediately when debugging starts
---@diagnostic disable-next-line: undefined-field
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
---@diagnostic disable-next-line: undefined-field
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
---@diagnostic disable-next-line: undefined-field
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- https://emojipedia.org/en/stickers/search?q=circle
vim.fn.sign_define("DapBreakpoint", {
  text = "⚪",
  texthl = "DapBreakpointSymbol",
  linehl = "DapBreakpoint",
  numhl = "DapBreakpoint",
})

vim.fn.sign_define("DapStopped", {
  text = "🔴",
  texthl = "yellow",
  linehl = "DapBreakpoint",
  numhl = "DapBreakpoint",
})
vim.fn.sign_define("DapBreakpointRejected", {
  text = "⭕",
  texthl = "DapStoppedSymbol",
  linehl = "DapBreakpoint",
  numhl = "DapBreakpoint",
})

-- default configuration
dapui.setup({
  layouts = {
    {
      elements = {
        { id = "scopes", size = 1 },
      },
      size = 20,
      position = "bottom",
    },
    {
      elements = {
        { id = "repl", size = 1 },
      },
      size = 1,
      position = "bottom",
    },
  },
  -- mappings = {
  --   edit = "e",
  --   expand = { "<CR>", "<2-LeftMouse>" },
  --   open = "o",
  --   remove = "d",
  --   repl = "r",
  --   toggle = "t",
  -- },
  -- icons = {
  --   collapsed = "",
  --   current_frame = "",
  --   expanded = "",
  -- },
  -- force_buffers = true,
  -- floating = {
  --   border = "single",
  --   mappings = {
  --     close = { "q", "<Esc>" },
  --   },
  -- },
  -- element_mappings = {},
  -- expand_lines = true,
  -- controls = {
  --   element = "repl",
  --   enabled = true,
  --   icons = {
  --     disconnect = "",
  --     pause = "",
  --     play = "",
  --     run_last = "",
  --     step_back = "",
  --     step_into = "",
  --     step_out = "",
  --     step_over = "",
  --     terminate = "",
  --   },
  -- },
})
