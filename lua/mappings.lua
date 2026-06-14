-- General
vim.keymap.set("n", "<space><space>r", ":w<CR>:restart<CR>", { desc = "Restart nvim" })
vim.keymap.set("n", "<Leader>w", function()
  vim.cmd("w")
end, { desc = "Save file" })
vim.keymap.set("n", "<Leader>q", function()
  vim.cmd("bd")
end, { desc = "Close window" })
vim.keymap.set({ "i", "v" }, "<C-c>", "<Esc>", { desc = "Remap control+c to esc" })
vim.keymap.set("n", "<A-v>", "<C-v>", { desc = "Visual-Block mode" })
vim.keymap.set("n", "<Leader>z", function()
  vim.cmd("SimpleZoomToggle")
end, { desc = "Zoom window" })

-- Navigation
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz", { desc = "Center screen after page down" })
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz", { desc = "Center screen after page up" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Center screen after search" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Center screen after search" })
-- vim.keymap.set("n", "<C-h>", "<C-w>h")
-- vim.keymap.set("n", "<C-j>", "<C-w>j")
-- vim.keymap.set("n", "<C-k>", "<C-w>k")
-- vim.keymap.set("n", "<C-l>", "<C-w>l")

--- Delete - Registers
vim.keymap.set({ "n", "v" }, "d", '"_d', { desc = "Delete doesn't add to registers" })
vim.keymap.set({ "n", "v" }, "c", '"_c', { desc = "Change doesn't add to registers" })
vim.keymap.set({ "n", "v" }, "x", '"_x', { desc = "Remove doesn't add to registers" })
vim.keymap.set("v", "p", '"_dP', { desc = "Paste doesn't add to registers" })
vim.keymap.set({ "n", "v" }, "<Leader>d", "d", { desc = "Delete does add to registers" })

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<Leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<Leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<Leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<Leader>fe", function()
  builtin.diagnostics({ sort_by = "severity" })
end, { desc = "Telescope buffers" })

-- LSP
vim.keymap.set("n", "<C-q>", vim.lsp.buf.hover, { desc = "Lsp documentation" })
vim.keymap.set("n", "<Leader>lc", function()
  vim.lsp.buf.code_action({
    filter = function(action)
      return not action.disabled
    end,
  })
end, { desc = "Code actions" })
vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<Leader>ld", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<Leader>lt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
vim.keymap.set("n", "<Leader>li", builtin.lsp_references, { desc = "Telescope references" })
vim.keymap.set("n", "<Leader>lii", builtin.lsp_implementations, { desc = "Telescope implementations" })

vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
  desc = "Accept Copilot suggestion",
})

vim.keymap.set("n", "<leader>nd", function()
  require("notify").dismiss()
end, { desc = "Dismiss notifications" })

vim.keymap.set(
  "n",
  "<Leader>nh",
  require("telescope").extensions.notify.notify,
  { desc = "Telescope notification history" }
)

vim.keymap.set("n", "<Leader>ne", function()
  vim.diagnostic.jump({
    count = 1,
    severity = vim.diagnostic.severity.ERROR,
  })
end)

vim.keymap.set("n", "<Leader>pe", function()
  vim.diagnostic.jump({
    count = -1,
    severity = vim.diagnostic.severity.ERROR,
  })
end)
