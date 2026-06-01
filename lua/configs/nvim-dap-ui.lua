local dapui = require("dapui")
local dap = require("dap")

--- open ui immediately when debugging starts
---@diagnostic disable-next-line: undefined-field
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
---@diagnostic disable-next-line: undefined-field
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
---@diagnostic disable-next-line: undefined-field
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

-- https://emojipedia.org/en/stickers/search?q=circle
vim.fn.sign_define('DapBreakpoint',
  {
    text = '⚪',
    texthl = 'DapBreakpointSymbol',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint'
  })

vim.fn.sign_define('DapStopped',
  {
    text = '🔴',
    texthl = 'yellow',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint'
  })
vim.fn.sign_define('DapBreakpointRejected',
  {
    text = '⭕',
    texthl = 'DapStoppedSymbol',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint'
  })

-- default configuration
dapui.setup()
