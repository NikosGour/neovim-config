return {
  "stevearc/conform.nvim",
  opts = {
    format_on_save = {
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      html = { "prettierd", "prettier", stop_after_first = true },
      vue = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      lua = { "stylua" },
      go = { "gofmt" },
      cs = { "csharpier" },
    },
  },
}
