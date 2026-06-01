-- Highlight text when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end
})

-- Multiple lsp autocmds
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    -- Autocomplete
    --if client:supports_method("textDocument/completion") then
    --  vim.lsp.completion.enable(true, client.id, args.buf)
    --end

    -- Autoformatting
    if client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end,
      })
    end
    -- disable builtin color preview
    vim.lsp.document_color.enable(false, nil, { style = "virtual" })

    -- Workspace diagnostics
    -- if client:supports_method("workspace/diagnostic", args.buf) then
    --   vim.lsp.buf.workspace_diagnostics({ client_id = client.id })
    -- else
    --   require("workspace-diagnostics").populate_workspace_diagnostics(client, args.buf)
    -- end
  end
})

-- Show diagnostics on hover
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      close_events = {
        "BufLeave",
        "CursorMoved",
        "InsertEnter"
      },
      border = "rounded",
      source = "if_many",
      scope = "cursor",
    })
  end,
})
