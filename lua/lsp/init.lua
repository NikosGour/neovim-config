local caps = require("lsp.capabilities").capabilities

vim.lsp.config("*", require("lsp.workspace_diagnostics"))

vim.lsp.config("html", { capabilities = caps })
vim.lsp.enable("html")

vim.lsp.config("tailwindcss", { capabilities = caps })
vim.lsp.enable("tailwindcss")

vim.lsp.config("vue_ls", { capabilities = caps })
vim.lsp.enable("vue_ls")

vim.lsp.config("ts_ls", { capabilities = caps })
vim.lsp.enable("ts_ls")

vim.lsp.config("dockerls", { capabilities = caps })
vim.lsp.enable("dockerls")

vim.lsp.config("lua_ls", require("lsp.lua_ls"))
vim.lsp.enable("lua_ls")

vim.lsp.config("gopls", { capabilities = caps })
vim.lsp.enable("gopls")

vim.lsp.config("roslyn_ls", { capabilities = caps })
vim.lsp.enable("roslyn_ls")

vim.lsp.config("vtsls", require("lsp.vtsls"))
vim.lsp.enable("vtsls")

vim.lsp.config("yamlls", require("lsp.yamlls"))
vim.lsp.enable("yamlls")

vim.lsp.config("cssls", { capabilities = caps })
vim.lsp.enable("cssls")

vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
  float = {
    source = true,
  },
})
