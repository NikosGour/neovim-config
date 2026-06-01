local capabilities = require("lsp.capabilities").capabilities
---
---
---@type vim.lsp.Config
return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose" },
  settings = {
    yaml = {
      validate = true,
      hover = true,
      completion = true,
      schemas = {
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
          "docker-compose.yml",
          "docker-compose.yaml",
          "compose.yml",
          "compose.yaml",
        },
      },
    },
  },
  capabilities = capabilities,
}
