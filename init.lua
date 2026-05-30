vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

require("options")

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "folke/tokyonight.nvim",
      config = function()
        require("tokyonight").setup({
          style = "night",
          lualine_bold = true,   -- bold headers for each section header
          day_brightness = 0.15, -- high contrast but colorful

          -- jack up all saturation, default is too dull!
          on_colors = function(colors)
            local hsluv = require("tokyonight.hsluv")
            local multiplier = 2.0

            for k, v in pairs(colors) do
              if type(v) == "string" and v ~= "NONE" then
                local hsv = hsluv.hex_to_hsluv(v)
                hsv[2] = hsv[2] * multiplier > 100 and 100 or hsv[2] * multiplier
                colors[k] = hsluv.hsluv_to_hex(hsv)
              elseif type(v) == "table" then
                if vim.islist(v) then
                  for kk, vv in ipairs(v) do
                    if type(vv) == "string" and vv ~= "NONE" then
                      local hsv = hsluv.hex_to_hsluv(vv)
                      hsv[2] = hsv[2] * multiplier > 100 and 100 or hsv[2] * multiplier
                      colors[k][kk] = hsluv.hsluv_to_hex(hsv)
                    end
                  end
                else
                  for kk, vv in pairs(v) do
                    if type(vv) == "string" and vv ~= "NONE" then
                      local hsv = hsluv.hex_to_hsluv(vv)
                      hsv[2] = hsv[2] * multiplier > 100 and 100 or hsv[2] * multiplier
                      colors[k][kk] = hsluv.hsluv_to_hex(hsv)
                    end
                  end
                end
              end
            end
          end,
        })

        vim.cmd.colorscheme("tokyonight")
      end
      ,
    },

    -- Treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      lazy = false,
      build = ":TSUpdate",
      branch = "main",
      event = { 'BufRead', 'BufNewFile' },
      config = function()
        require("nvim-treesitter").setup({})

        require("nvim-treesitter").install({ "c", "lua", "vim", "vimdoc", "query", "html", "css", "json", "vue",
          "typescript", "javascript", "go", "c_sharp", "razor", "dockerfile" })


        vim.api.nvim_create_autocmd('FileType', {
          group = vim.api.nvim_create_augroup('treesitter.setup', {}),
          callback = function(args)
            local buf = args.buf
            local filetype = args.match

            -- you need some mechanism to avoid running on buffers that do not
            -- correspond to a language (like oil.nvim buffers), this implementation
            -- checks if a parser exists for the current language
            local language = vim.treesitter.language.get_lang(filetype) or filetype
            if not vim.treesitter.language.add(language) then
              return
            end

            -- replicate `fold = { enable = true }`
            -- vim.wo.foldmethod = 'expr'
            -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

            -- replicate `highlight = { enable = true }`
            vim.treesitter.start(buf, language)

            -- replicate `indent = { enable = true }`
            -- vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

            -- `incremental_selection = { enable = true }` covered by 0.12.0
          end,
        })
      end,
    },

    -- Mason
    {
      "williamboman/mason.nvim",
      lazy = false,
      opts = {
        registries = {
          "github:mason-org/mason-registry",
          "github:Crashdummyy/mason-registry",
        },
        ensure_installed = {
          "gopls",
          "html-lsp",
          "lua-language-server",
          "tailwindcss-language-server",
          "typescript-language-server",
          "vtsls",
          "vue-language-server",
          "roslyn_ls",
        }
      }
    },

    -- LSPConfig
    {
      "neovim/nvim-lspconfig",
      lazy = false,
    },

    -- Blink
    {
      "saghen/blink.cmp",

      dependencies = { 'rafamadriz/friendly-snippets' },
      version = "1.*",

      opts = {
        keymap = {
          preset = "super-tab",
          ['<C-f>'] = { 'scroll_documentation_up', 'fallback' },
          ['<C-b>'] = { 'scroll_documentation_down', 'fallback' },
        },

        completion = { documentation = { auto_show = true } },

        sources = {
          default = { "lsp", "path", "snippets", "buffer" }
        },

        fuzzy = { implementation = "prefer_rust_with_warning" }

      },
    },

    -- Undotree
    {
      "mbbill/undotree"
    },

    -- Tig
    {
      "iberianpig/tig-explorer.vim",
      dependencies = { "rbgrouleff/bclose.vim" }, -- required for Neovim
    },

    -- Telescope
    {
      'nvim-telescope/telescope.nvim',
      version = '*',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      },
      config = function()
        require("telescope").setup({
          defaults = {
            layout_strategy = "vertical",
            layout_config = {
              vertical = {
                prompt_position = "top",
                mirror = true,

                width = 0.9,
                height = 0.95,

                preview_height = 0.7,
              }
            }
          },
          pickers = {
            find_files = {
              hidden = true,
              frllow = true
            },
            live_grep = {
              additional_args = function()
                return { "--hidden" }
              end
            },
            buffers = {
              sort_mru = true,
              sort_lastused = true,
            }
          },
        })

        require("telescope").load_extension("ui-select")
      end
    },

    { "nvim-tree/nvim-web-devicons", lazy = true },
    { "nvim-lua/plenary.nvim" },
    {
      -- Debug Framework
      "mfussenegger/nvim-dap",
      dependencies = {
        "rcarriga/nvim-dap-ui",
      },
      config = function()
        require "configs.nvim-dap"
      end,
      event = "VeryLazy",
    },
    { "nvim-neotest/nvim-nio" },
    {
      -- UI for debugging
      "rcarriga/nvim-dap-ui",
      dependencies = {
        "mfussenegger/nvim-dap",
      },
      config = function()
        require "configs.nvim-dap-ui"
      end,
    },
    -- Neotest for testing
    {
      "nvim-neotest/neotest",
      requires = {
        {
          "Issafalcon/neotest-dotnet",
        }
      },
      dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter"
      }
    },
    {
      "Issafalcon/neotest-dotnet",
      lazy = false,
      dependencies = {
        "nvim-neotest/neotest"
      }
    },
    {
      "ramboe/ramboe-dotnet-utils",
      dependencies = { "mfussenegger/nvim-dap" }
    },
    -- Yazi file navigation
    {
      "mikavilpas/yazi.nvim",
      version = "*", -- use the latest stable version
      event = "VeryLazy",
      dependencies = {
        { "nvim-lua/plenary.nvim",      lazy = true },
        { "nvim-tree/nvim-web-devicons" },

      },
      keys = {
        {
          "<Leader>ns",
          mode = { "n", "v" },
          "<cmd>Yazi<cr>",
          desc = "Open yazi at the current file",
        },
        {
          "<Leader>nc",
          mode = { "n", "v" },
          "<cmd>Yazi cwd<cr>",
          desc = "Open the file manager in nvim's working directory",
        },
        {
          "<Leader>nf",
          mode = { "n", "v" },
          "<cmd>Yazi toggle<cr>",
          desc = "Resume the last yazi session",
        },
      },
      opts = {
        -- if you want to open yazi instead of netrw, see below for more info
        open_for_directories = true,
        keymaps = {
          show_help = "<f1>",
        },
      },
      -- ?? if you use `open_for_directories=true`, this is recommended
      init = function()
        -- mark netrw as loaded so it's not loaded at all.
        vim.g.loaded_netrwPlugin = 1
      end,

    },
    {
      'brenoprata10/nvim-highlight-colors',
      opts = {

        render = "virtual",
        virtual_symbol = '⬛',

        --Set virtual symbol suffix (defaults to '')
        virtual_symbol_prefix = '',

        ---Set virtual symbol suffix (defaults to ' ')
        virtual_symbol_suffix = '',

        virtual_symbol_position = 'inline',

        ---Highlight hex colors, e.g. '#FFFFFF'
        enable_hex = true,

        ---Highlight short hex colors e.g. '#fff'
        enable_short_hex = true,

        ---Highlight rgb colors, e.g. 'rgb(0 0 0)'
        enable_rgb = true,

        ---Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
        enable_hsl = true,

        ---Highlight ansi colors, e.g '\033[0;34m'
        enable_ansi = true,

        ---Highlight xterm 256 (8bit) colors, e.g '\033[38;5;118m'
        enable_xterm256 = true,

        ---Highlight xterm True Color (24bit) colors, e.g '\033[38;2;118;64;90m'
        enable_xtermTrueColor = true,

        -- Highlight hsl colors without function, e.g. '--foreground: 0 69% 69%;'
        enable_hsl_without_function = true,

        ---Highlight CSS variables, e.g. 'var(--testing-color)'
        enable_var_usage = true,

        ---Highlight named colors, e.g. 'green'
        enable_named_colors = true,

        ---Highlight tailwind colors, e.g. 'bg-blue-500'
        enable_tailwind = true,
      }
    },
    {
      'nvim-mini/mini.nvim',
      version = '*',
      config = function()
        require("mini.ai").setup({})
        require("mini.comment").setup({ mappings = { comment_line = "<Leader>b", comment_visual = "<Leader>b" } })
        require("mini.move").setup({})
        require("mini.pairs").setup({})
        -- require("mini.splitjoin").setup({}) look into it later
        require("mini.surround").setup({})
        -- require("mini.bracketed").setup({}) look into it later
        require("mini.jump").setup({})
      end
    },

    -- Lsp info popup
    {
      "j-hui/fidget.nvim",
      opts = {}
    },
    {
      "windwp/nvim-ts-autotag",
      opts = {}
    },
    {
      "folke/trouble.nvim",
      opts = {}, -- for default options, refer to the configuration section for custom setup.
      cmd = "Trouble",
      keys = {
        {
          "<leader>xx",
          "<cmd>Trouble diagnostics toggle<cr>",
          desc = "Diagnostics (Trouble)",
        },
        {
          "<leader>xX",
          "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
          desc = "Buffer Diagnostics (Trouble)",
        },
        {
          "<leader>cs",
          "<cmd>Trouble symbols toggle focus=false<cr>",
          desc = "Symbols (Trouble)",
        },
        {
          "<leader>cl",
          "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
          desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
          "<leader>xL",
          "<cmd>Trouble loclist toggle<cr>",
          desc = "Location List (Trouble)",
        },
        {
          "<leader>xQ",
          "<cmd>Trouble qflist toggle<cr>",
          desc = "Quickfix List (Trouble)",
        },
      },
    },
    { "artemave/workspace-diagnostics.nvim" },
    { "romainl/vim-cool" },
  },
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = true },
})

require("neotest").setup({
  adapters = {
    require("neotest-dotnet")
  }
})


vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,

        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library"
        }
      }
    }
  }
})

-- html lsp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config("html", {
  capabilities = capabilities,
})

vim.lsp.enable("html")

-- tailwindcss lsp
vim.lsp.enable("tailwindcss")

-- vue lsp
vim.lsp.enable("vue_ls")

-- typescript lsp
vim.lsp.enable("ts_ls")

-- Docker lsp
vim.lsp.enable("docker_language_server")

-- typescript lsp
local vue_language_server_path = vim.fn.stdpath("data") ..
    "/mason/packages/vue-language-server/node_modules/@vue/language-server"

vim.lsp.config("vtsls", {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_language_server_path,
            languages = { "vue" },
            configNamespace = "typescript",
          }
        },
      },
    },
  },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})

vim.lsp.enable("vtsls")

-- lua lsp
vim.lsp.enable("lua_ls")
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  severity_sort = true,
})


-- go lsp
vim.lsp.config("gopls", {
  capabilities = capabilities,
})

vim.lsp.enable("gopls")

-- Csharp lsp
vim.lsp.config("roslyn_ls", {
  capabilities = capabilities
})
vim.lsp.enable("roslyn_ls")

vim.lsp.config('*', {
  on_attach = function(client, bufnr)
    -- some clients support workspace diagnostics natively
    if client:supports_method("workspace/diagnostic", bufnr) then
      vim.lsp.buf.workspace_diagnostics({ client_id = client.id })
    else
      require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
    end
  end
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end
})


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


--local clip = "/mnt/c/Windows/System32/clip.exe"
--
--if vim.fn.executable(clip) == 1 then
--  local group = vim.api.nvim_create_augroup("WSLYank", { clear = true })
--
--  vim.api.nvim_create_autocmd("TextYankPost", {
--    group = group,
--    callback = function()
--      if vim.v.event.operator == "y" then
--        vim.fn.system(clip, vim.fn.getreg("0"))
--      end
--    end,
--  })
--end


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


vim.api.nvim_set_hl(0, "htmlEndTag", { link = "Function" })
vim.api.nvim_set_hl(0, "@keyword.function", { link = "@keyword" })
vim.api.nvim_set_hl(0, "PreProc", { link = "@keyword" })

-- Remap
--- Command
vim.keymap.set("n", "<space><space>r", ":w<CR>:restart<CR>")
vim.keymap.set("n", "<Leader>w", ":w<CR>")

--- Navigation
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz")
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "n", "nzzzv")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

--- Delete - Registers
vim.keymap.set({ "n", "v" }, "d", "\"_d")
vim.keymap.set({ "n", "v" }, "c", "\"_c")
vim.keymap.set({ "n", "v" }, "x", "\"_x")
vim.keymap.set("v", "p", "\"_dP")
vim.keymap.set({ "n", "v" }, "<Leader>d", "d")

-- General
vim.keymap.set({ "i", "v" }, "<C-c>", "<Esc>")
vim.keymap.set("n", "<A-v>", "<C-v>")
vim.keymap.del("n", "<Leader>bd")

vim.keymap.set("n", "<C-q>", vim.lsp.buf.hover)
vim.keymap.set("n", "<Leader>c",
  function()
    vim.lsp.buf.code_action({ filter = function(action) return not action.disabled end })
  end)

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fe', function() builtin.diagnostics({ sort_by = "severity" }) end,
  { desc = 'Telescope buffers' })

--terminal
--fix docker lsp to have docs and work on docker-compose
--fix bug with dotnet test running
--fix autocomplete choosing
--split config into dirs
--search and replace
--refactor keybinds
--html + css no errors/lsp
--debugger show object on hover/keybind
--
-- Plugins
-- snacks plugin
-- notifier
-- noice plugin
