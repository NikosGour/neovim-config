vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitbelow = true
vim.opt.splitright = true


vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.autoindent = true

vim.opt.clipboard = "unnamedplus"

vim.opt.virtualedit = "block"

vim.opt.ignorecase = true

vim.opt.termguicolors = true

vim.opt.laststatus = 3
vim.opt.updatetime = 250

vim.opt.shortmess:append("S")

vim.g.clipboard = {
  name = "WslClipboard",
  copy = {
    ['+'] = "clip.exe",
    ['*'] = "clip.exe",
  },
  paste = {
    ['+'] =
    'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    ['*'] =
    'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  },
  cache_enabled = 0,
}
