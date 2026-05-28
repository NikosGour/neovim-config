local M = {}

M.base46 = {
  theme = "bearded-arc",
}

M.ui = {
  statusline = {
    theme = "minimal",
    separator_style = "round",
  },
  telescope = { style = "bordered" },
  tabufline = {
    enabled = false
  },
  lsp = { signature = true },
  colorify = {
    enabled = true,
    mode = "fg",
    virt_text = "󱓻 ",
    highlight = { hex = true, lspvars = true },
  }

}
return M
