local function IsZoomedIn()
  if vim.t['simple-zoom'] == nil then
    return ''
  elseif vim.t['simple-zoom'] == 'zoom' then
    return '󰍉'
  end
end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    "folke/tokyonight.nvim",
  },
  config = function()
    require("lualine").setup({
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diagnostics' },
        lualine_c = { 'filename', IsZoomedIn, "searchcount" },
        lualine_x = { { "diagnostics", sources = { "nvim_workspace_diagnostic" } }, 'filetype' },
        lualine_y = { 'lsp_status' },
        lualine_z = { 'progress' }
      },
    })
  end
}
