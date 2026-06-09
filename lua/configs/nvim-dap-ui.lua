---@diagnostic disable: undefined-field
local dapui = require("dapui")
local dap = require("dap")

--- open ui immediately when debugging starts
dap.listeners.before.attach.dapui_config = function()
  dapui.open({ layout = 2, reset = true })
  dapui.open({ layout = 3, reset = true })
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open({ layout = 2, reset = true })
  dapui.open({ layout = 3, reset = true })
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
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
---@diagnostic disable-next-line: missing-fields
dapui.setup({
  layouts = {
    {
      elements = {
        { id = "breakpoints", size = 0.33 },
        { id = "stacks", size = 0.33 },
        { id = "watches", size = 0.33 },
      },
      size = 40, -- width of left panel
      position = "left",
    },
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
local dapui_left_open = false

function ToggleDapUILeft()
  if dapui_left_open then
    dapui.close({ layout = 1 })
    dapui_left_open = false
  else
    dapui.open({ layout = 1, reset = true })
    dapui_left_open = true
  end
end

vim.api.nvim_create_user_command("DapUIToggleLeft", ToggleDapUILeft, {})

vim.keymap.set("n", "<Leader>?", function()
  ---@diagnostic disable-next-line: missing-fields
  require("dapui").eval(nil, { enter = true })
end)
