-- General
vim.keymap.set("n", "<space><space>r", ":w<CR>:restart<CR>", { desc = "Restart nvim" })
vim.keymap.set("n", "<Leader>w", function() vim.cmd("w") end, { desc = "Save file" })
vim.keymap.set("n", "<Leader>q", function() vim.cmd("bd") end, { desc = "Close window" })
vim.keymap.set({ "i", "v" }, "<C-c>", "<Esc>", { desc = "Remap control+c to esc" })
vim.keymap.set("n", "<A-v>", "<C-v>", { desc = "Visual-Block mode" })
vim.keymap.set('n', '<Leader>z', function() vim.cmd("SimpleZoomToggle") end, { desc = "Zoom window" })

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
vim.keymap.set({ "n", "v" }, "d", "\"_d", { desc = "Delete doesn't add to registers" })
vim.keymap.set({ "n", "v" }, "c", "\"_c", { desc = "Change doesn't add to registers" })
vim.keymap.set({ "n", "v" }, "x", "\"_x", { desc = "Remove doesn't add to registers" })
vim.keymap.set("v", "p", "\"_dP", { desc = "Paste doesn't add to registers" })
vim.keymap.set({ "n", "v" }, "<Leader>d", "d", { desc = "Delete does add to registers" })

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fe', function() builtin.diagnostics({ sort_by = "severity" }) end,
  { desc = 'Telescope buffers' })


-- LSP
vim.keymap.set("n", "<C-q>", vim.lsp.buf.hover, { desc = "Lsp documentation" })
vim.keymap.set("n", "<Leader>ca",
  function()
    vim.lsp.buf.code_action({ filter = function(action) return not action.disabled end })
  end, { desc = "Code actions" })
