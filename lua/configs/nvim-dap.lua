local dap = require("dap")

local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"

local netcoredbg_adapter = {
  type = "executable",
  command = mason_path,
  args = { "--interpreter=vscode" },
}

---@diagnostic disable-next-line: undefined-field
dap.adapters.netcoredbg = netcoredbg_adapter -- needed for normal debugging
---@diagnostic disable-next-line: undefined-field
dap.adapters.coreclr = netcoredbg_adapter -- needed for unit test debugging

---@diagnostic disable-next-line: undefined-field
dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      -- return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/src/", "file")
      -- return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net9.0/", "file")
      return require("dap-dll-autopicker").build_dll_path()
    end,

    env = {
      ASPNETCORE_ENVIRONMENT = function()
        return "Development"
      end,
    },
  },
}

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>", opts)
vim.keymap.set("n", "<F6>", "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>", opts)
vim.keymap.set("n", "<F9>", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
vim.keymap.set("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", opts)
vim.keymap.set("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", opts)
vim.keymap.set("n", "<F8>", "<Cmd>lua require'dap'.step_out()<CR>", opts)
