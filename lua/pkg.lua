-- lazy package manager init
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

opt = { noremap = true, silent = true }

return require('lazy').setup({
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ':TSUpdate',
    opts = function(_, opts)
      opts.ignore_install = { "help" }
    end,
  },
  { 'nvim-treesitter/nvim-treesitter-refactor' },
  -- LSP
  { "neovim/nvim-lspconfig" },
  ---- LSP source for nvim-cmp
  { "hrsh7th/cmp-nvim-lsp" },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    }
  },

  -- Gist integration
  {
    "mattn/vim-gist",
    dependencies = {
      "mattn/webapi-vim",
    },
  },

  -- Copilot
  {
    'github/copilot.vim',
    keys = {
      { '<S-tab>', 'copilot#Accept("\\<CR>")', mode = 'i', unpack(opt), expr = true, replace_keycodes = false },
      { '<M-down>', '<Plug>(copilot-next)', mode = 'i', unpack(opt) },
      { '<M-up>', '<Plug>(copilot-previous)', mode = 'i', unpack(opt) },
    },
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
    end,
    lazy = false,
  },

  ---- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- Sources
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "ray-x/cmp-treesitter",
      "dmitmel/cmp-cmdline-history",

      "onsails/lspkind.nvim",
    },
  },

  {
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
      require("lspsaga").setup {
        outline = {
          keys = {
            jump = "<CR>",
            expand_collapse = " ",
            quit = "<Esc>",
          },
        },
        callhierarchy = {
          keys = {
            jump = "<CR>",
            quit = "<Esc>",
            expand_collapse = " ",
          },
        },
        code_action = {
          num_shortcut = true,
          show_server_name = false,
          keys = {
            quit = "<Esc>",
            exec = "<CR>",
          },
        }
      }
    end,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    }
  },

  -- run tests and show results
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-go",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-python",
    },
    config = function()
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message =
            diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup({
        -- your neotest config here
        adapters = {
          require("neotest-go"),
          require("neotest-python"),
        },
      })
    end,
    keys = {
      {
        "<leader>xt",
        function()
          require("neotest").run.run()
        end,
        mode = "n",
        unpack(opt),
      },
      {
        "<leader>xf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        mode = "n",
        unpack(opt),
      },
    },
  },

  -- display coverage in sign column
  {
    "andythigpen/nvim-coverage",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("coverage").setup()
    end,
  },

  -- prettier
  { 'MunifTanjim/prettier.nvim' },

  -- jinja2 / nunjucks
  { 'Glench/Vim-Jinja2-Syntax' },

  -- Go development
  --use("fatih/vim-go")
  -- Graphql syntax
  { "jparise/vim-graphql" },
  -- Display popup with possible keybindings
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end,
  },
  -- Fuzzy filtering
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", mode = "n", unpack(opt) },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", mode = "n", unpack(opt) },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", mode = "n", unpack(opt) },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", mode = "n", unpack(opt) },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", mode = "n", unpack(opt) },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", mode = "n", unpack(opt) },
    },
    config = function()
      require("telescope").setup()
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        color_overrides = {
          mocha = { -- custom
            rosewater = "#ffc6be",
            flamingo = "#fb4934",
            pink = "#ff75a0",
            mauve = "#f2594b",
            red = "#f2594b",
            maroon = "#fe8019",
            peach = "#FFAD7D",
            yellow = "#e9b143",
            green = "#b0b846",
            teal = "#8bba7f",
            sky = "#7daea3",
            sapphire = "#689d6a",
            blue = "#80aa9e",
            lavender = "#e2cca9",
            text = "#e2cca9",
            subtext1 = "#e2cca9",
            subtext0 = "#e2cca9",
            overlay2 = "#8C7A58",
            overlay1 = "#735F3F",
            overlay0 = "#806234",
            surface2 = "#665c54",
            surface1 = "#3c3836",
            surface0 = "#32302f",
            base = "#282828",
            mantle = "#1d2021",
            crust = "#1b1b1b",
          },
        },
      })

      vim.cmd("colorscheme catppuccin-mocha")
    end,
  },
  -- status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("lualine").setup {
        options = {
          theme = 'seoul256'
        }
      }
    end,
  },
  -- file navigator
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icon
    },
    keys = {
      { '<leader>to', '<cmd>NvimTreeOpen<cr>', mode = 'n', unpack(opt) },
    },
    config = function()
      print("nvim-tree setup")
      require("nvim-tree").setup {
        filters = {
          dotfiles = true,
        }
      }
    end,
  },
  -- edit matching parens, brackets, etc
  { 'tpope/vim-surround' },
  { 'tpope/vim-repeat' },
  -- hilight f/t targets
  { 'unblevable/quick-scope' },
  -- fancy lsp diagnostics window
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics<cr>', mode = 'n', unpack(opt) },
    },
    config = function()
      require("trouble").setup {
        padding = false,
        height = 5,
        modes = {
          diagnostics = {
            auto_close = true,
          },
        },
      }
    end,
  },
  -- zoom panels
  {
    'Pocco81/TrueZen.nvim',
    keys = {
      { '<C-z>', '<cmd>TZFocus<CR>', mode = 'n', unpack(opt) },
      { '<C-z>', '<cmd>TZFocus<CR>', mode = 't', unpack(opt) },
    },
  },
  -- git integration
  {
    'tpope/vim-fugitive',
  },
})
