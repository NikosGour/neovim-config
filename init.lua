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
    -- Theme
    --    {
    --      "loctvl842/monokai-pro.nvim",
    --      lazy = false,
    --      priority = 1000,
    --      config = function()
    --        require("monokai-pro").setup()
    --        vim.cmd.colorscheme("monokai-pro")
    --      end,
    --    },
    -- {
    --   "folke/tokyonight.nvim",
    --   config = function()
    --     require("tokyonight").setup()
    --     vim.cmd.colorscheme("tokyonight")
    --   end,
    -- },

    -- Treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      lazy = false,
      build = ":TSUpdate",
      branch = "main",
      event = { 'BufRead', 'BufNewFile' },
      config = function()
        require("nvim-treesitter").setup({})

        require("nvim-treesitter").install({ "c", "lua", "vim", "vimdoc", "query", "html", "css", "vue", "typescript",
          "javascript", "go", "c_sharp", "razor", "dockerfile" })


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
          "roslyn",
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

      dependancies = { "rafamandiz/friendly-snippets" },

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

    -- Autopairs
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = true
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

    -- Vim Surround
    {
      "kylechui/nvim-surround",
      version = "^4.0.0",
      event = "VeryLazy",
    },

    -- Telescope
    {
      'nvim-telescope/telescope.nvim',
      version = '*',
      dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      },
      config = function()
        require("telescope").setup({

          pickers = {
            find_files = {
              hidden = true,
              frllow = true
            },
            live_grep = {
              additional_args = function()
                return { "--hidden" }
              end
            }
          },
        })
      end
    },

    -- Comments
    {
      'numToStr/Comment.nvim',
      opts = {
        mappings = false
      }
    },
    { "nvim-tree/nvim-web-devicons", lazy = true },
    { "nvim-lua/plenary.nvim" },
    {
      "nvchad/ui",
      config = function()
        require("nvchad")
      end
    },
    {
      "nvchad/base46",
      lazy = true,
      build = function()
        require("base46").load_all_highlights()
      end
    },
    { "nvchad/volt" },
    {
      "seblyng/roslyn.nvim",
      ft = { "cs", "razor" },
      opts = {}
    },

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
  },
  install = { colorscheme = { "bearded-arc" } },
  checker = { enabled = true },
})

-- dofile(vim.g.base46_cache .. "defaults")
-- dofile(vim.g.base46_cache .. "statusline")
-- dofile(vim.g.base46_cache .. "syntax")
-- dofile(vim.g.base46_cache .. "treesitter")

for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
  dofile(vim.g.base46_cache .. v)
end

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
})


-- go lsp
vim.lsp.config("gopls", {
  capabilities = capabilities,
})

vim.lsp.enable("gopls")

-- Csharp lsp
-- vim.lsp.config("roslyn_ls", {})

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
  end
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
vim.keymap.set('n', '<leader>fe', builtin.diagnostics, { desc = 'Telescope buffers' })

-- Comments
local comment_api = require("Comment.api")
vim.keymap.set("n", "<Leader>b", comment_api.toggle.linewise.current)
vim.keymap.set("v", "<Leader>b", function()
  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)

  vim.api.nvim_feedkeys(esc, "nx", false)
  comment_api.toggle.linewise(vim.fn.visualmode())
end)


--run nohlsearch neovim automatically
--error float
--best neovim plugins
--terminal
--file explorer (yazi)
--git / tig
--neovim make crlf to lf
--fix docker lsp to have docs and work on docker-compose
--fix bug with dotnet test running
--split config into dirs
