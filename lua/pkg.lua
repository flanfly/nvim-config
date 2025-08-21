-- lazy package manager init
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

local opt = { noremap = true, silent = true }

-- disable netrw, use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
      { '<S-tab>',  'copilot#Accept("\\<CR>")', mode = 'i', unpack(opt), expr = true, replace_keycodes = false },
      { '<M-down>', '<Plug>(copilot-next)',     mode = 'i', unpack(opt) },
      { '<M-up>',   '<Plug>(copilot-previous)', mode = 'i', unpack(opt) },
    },
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
    end,
    lazy = false,
  },

  -- aider
  --{
  --  "GeorgesAlkhouri/nvim-aider",
  --  cmd = {
  --    "AiderTerminalToggle", "AiderHealth",
  --  },
  --  keys = {
  --    { "<leader>a/", "<cmd>AiderTerminalToggle<cr>",    desc = "Open Aider" },
  --    { "<leader>as", "<cmd>AiderTerminalSend<cr>",      desc = "Send to Aider",                  mode = { "n", "v" } },
  --    { "<leader>ac", "<cmd>AiderQuickSendCommand<cr>",  desc = "Send Command To Aider" },
  --    { "<leader>ab", "<cmd>AiderQuickSendBuffer<cr>",   desc = "Send Buffer To Aider" },
  --    { "<leader>a+", "<cmd>AiderQuickAddFile<cr>",      desc = "Add File to Aider" },
  --    { "<leader>a-", "<cmd>AiderQuickDropFile<cr>",     desc = "Drop File from Aider" },
  --    { "<leader>ar", "<cmd>AiderQuickReadOnlyFile<cr>", desc = "Add File as Read-Only" },
  --    -- Example nvim-tree.lua integration if needed
  --    { "<leader>a+", "<cmd>AiderTreeAddFile<cr>",       desc = "Add File from Tree to Aider",    ft = "NvimTree" },
  --    { "<leader>a-", "<cmd>AiderTreeDropFile<cr>",      desc = "Drop File from Tree from Aider", ft = "NvimTree" },
  --  },
  --  dependencies = {
  --    "folke/snacks.nvim",
  --    --- The below dependencies are optional
  --    "catppuccin/nvim",
  --    "nvim-tree/nvim-tree.lua",
  --  },
  --  config = true,
  --},

  -- avante
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      -- add any opts here
      -- for example
      provider = "openai",
      providers = {
        openai = {
          endpoint = "https://api.openai.com/v1",
          model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
          timeout = 30000,  -- Timeout in milliseconds, increase this for reasoning models
          extract_request_body = {
            temperature = 0,
            max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
          },
          --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
        },
      },
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
      "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",        -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
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
    config = function()
      require("lspsaga").setup {
        lightbulb = {
          enable = false,
        },
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
      "nvim-treesitter/nvim-treesitter",
    }
  },

  -- run tests and show results
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "fredrikaverpil/neotest-golang",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-python",
      --"nvim-neotest/neotest-go",
    },
    config = function()
      local golang_opts = {
        runner = "gotestsum",
        go_test_args = {
          "-v",
          "-race",
          "-count=1",
          "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
        },
      }

      require("neotest").setup({
        -- your neotest config here
        adapters = {
          require("neotest-golang")(golang_opts),
          require("neotest-python"),
          --require("neotest-go"),
        },
        status = { virtual_text = true },
        output = { open_on_run = true },
        quickfix = {
          open = function()
            vim.cmd("Trouble quickfix")
          end,
          enabled = true,
        },
      })
    end,
    keys = {
      { "<leader>ct", function() require("neotest").run.run() end, mode = "n", unpack(opt), },
    },
  },

  -- display coverage in sign column
  {
    "andythigpen/nvim-coverage",
    version = "*",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("coverage").setup({
        auto_reload = true,
      })
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
    tag = "0.1.8",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>",  mode = "n", unpack(opt) },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",   mode = "n", unpack(opt) },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",     mode = "n", unpack(opt) },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",   mode = "n", unpack(opt) },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", mode = "n", unpack(opt) },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",    mode = "n", unpack(opt) },
    },
    config = function()
      require("telescope").setup {
        defaults = {
          path_display = { "smart" },
          preview = {
            treesitter = {
              enable = false,
            },
          },
        },
      }
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
        custom_highlights = function(colors)
          local u = require("catppuccin.utils.colors")
          return {
            CursorLineNr = { bg = u.blend(colors.overlay0, colors.base, 0.75), style = { "bold" } },
            CursorLine = { bg = u.blend(colors.overlay0, colors.base, 0.45) },
            LspReferenceText = { bg = colors.surface2 },
            LspReferenceWrite = { bg = colors.surface2 },
            LspReferenceRead = { bg = colors.surface2 },
          }
        end,
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
        sync_root_with_cwd = true,
        actions = {
          change_dir = {
            enable = true,
            global = true,
          },
        },
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
    opts = {},
    cmd = "Trouble",
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics<cr>', mode = 'n', unpack(opt) },
    },
    dependencies = "nvim-tree/nvim-web-devicons",
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
  { 'tpope/vim-fugitive', },

  -- helm
  { 'towolf/vim-helm', },
})
