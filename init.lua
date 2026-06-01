local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("options")

require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = true },
  -- {
  --   "ramboe/ramboe-dotnet-utils",
  --   dependencies = { "mfussenegger/nvim-dap" }
  -- },
})

require("filetypes")
require("mappings")
require("autocmd")
require("highlights")
require("lsp")

--fix docker lsp to have docs
--search and replace
--debugger show object on hover/keybind
--change color for functions
--
-- Plugins
-- snacks plugin
-- notifier
-- noice plugin
