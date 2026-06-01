local capabilities = require("lsp.capabilities").capabilities
---
---
---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  settings = {
    Lua = {
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true)
      }
    }
  },
  capabilities = capabilities
}
