return {
  "aserowy/tmux.nvim",
  config = function()
    ---@diagnostic disable-next-line: redundant-parameter
    require("tmux").setup({
      copy_sync = { enable = false, },
      navigation = {
        cycle_navigation = true,

        -- enables default keybindings (C-hjkl) for normal mode
        enable_default_keybindings = true,

        -- prevents unzoom tmux when navigating beyond vim border
        persist_zoom = false,
      },
      resize = {
        -- enables default keybindings (A-hjkl) for normal mode
        enable_default_keybindings = true,

        -- sets resize steps for x axis
        resize_step_x = 1,

        -- sets resize steps for y axis
        resize_step_y = 1,
      },
      swap = {
        -- cycles to opposite pane while navigating into the border
        cycle_navigation = false,

        -- enables default keybindings (C-A-hjkl) for normal mode
        enable_default_keybindings = true,
      }
    })
  end
}
