-- Highlight text when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Multiple lsp autocmds
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    -- Autocomplete - Can't use while using blink.nvim since they conflict with each other.
    --if client:supports_method("textDocument/completion") then
    --  vim.lsp.completion.enable(true, client.id, args.buf)
    --end

    -- Autoformatting - Can't use while using conform.nvim since they conflict with each other.
    -- if client:supports_method("textDocument/formatting") then
    --   vim.api.nvim_create_autocmd("BufWritePre", {
    --     buffer = args.buf,
    --     group = vim.api.nvim_create_augroup("format on save native", { clear = true }),
    --     callback = function()
    --       vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
    --     end,
    --   })
    -- end

    -- disable builtin color preview since it conflicts with nvim-highlight-colors.lua
    vim.lsp.document_color.enable(false, nil, { style = "virtual" })
  end,
})

-- Show diagnostics on hover
vim.api.nvim_create_autocmd("CursorHold", {
  group = vim.api.nvim_create_augroup("show diagnostics on hover", { clear = true }),
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = true,
      close_events = {
        "BufLeave",
        "CursorMoved",
        "InsertEnter",
      },
      border = "rounded",
      source = true,
      scope = "cursor",
    })
  end,
})

-- Lint on save
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("format on save nvim-lint", { clear = true }),
  callback = function()
    require("lint").try_lint()
  end,
})

local function set_keyboard(layout)
  vim.fn.jobstart({ "im-select.exe", layout })
end

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    set_keyboard("1033") -- English US
  end,
})
