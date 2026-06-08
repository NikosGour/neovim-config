vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.autoindent = true
-- vim.opt.smartindent = true

vim.opt.clipboard = "unnamedplus"

vim.opt.virtualedit = "block"

vim.opt.ignorecase = true

vim.opt.termguicolors = true

vim.opt.laststatus = 3
vim.opt.updatetime = 250

vim.opt.scrolloff = 8

-- vim.opt.shortmess:append("S")

vim.g.clipboard = {
  name = "WslClipboard",
  copy = {
    ["+"] = "clip.exe",
    ["*"] = "clip.exe",
  },
  paste = {
    ["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    ["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  },
  cache_enabled = 0,
}

vim.g.copilot_no_tab_map = true

vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*", "*/.git/*" })
