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

-- map ctrl + c to esc

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
    {
      "folke/tokyonight.nvim",
      config = function()
        require("tokyonight").setup()
        vim.cmd.colorscheme("tokyonight")
      end,
    },

    -- Treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      lazy = false,
      build = ":TSUpdate",
      branch = "main",
      config = function()
        require("nvim-treesitter").setup({})
      end,
    },

    -- Mason
    {
      "williamboman/mason.nvim",
      lazy = false,
      config = function()
        require("mason").setup()
      end,
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
        keymap = { preset = "super-tab" },

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

    -- vim surround
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
      }
    },

  },

  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

require("nvim-treesitter").install({ "c", "lua", "vim", "vimdoc", "query", "html", "css", "vue", "typescript",
  "javascript" })

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
vim.diagnostic.config({ virtual_text = true })


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


-- Remaps
--- Command
vim.keymap.set("n", "<space><space>r", ":w<CR>:restart<CR>")
vim.keymap.set("n", "<Leader>w", ":w<CR>")

--- Navigation
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz")
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "n", "nzzzv")

--- Delete - Registers
vim.keymap.set({ "n", "v" }, "d", "\"_d")
vim.keymap.set({ "n", "v" }, "c", "\"_c")
vim.keymap.set({ "n", "v" }, "x", "\"_x")
vim.keymap.set("v", "p", "\"_dP")
vim.keymap.set({ "n", "v" }, "<Leader>d", "d")

-- General
vim.keymap.set({ "i", "v" }, "<C-c>", "<Esc>")
