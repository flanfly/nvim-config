local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  local rtp_addition = vim.fn.stdpath('data') .. '/site/pack/*/start/*'
  if not string.find(vim.o.runtimepath, rtp_addition) then
    vim.o.runtimepath = rtp_addition .. ',' .. vim.o.runtimepath
  end

  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- PackerSync = PackerUpdate + PackerCompile
return require('packer').startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")
  -- Improve startup time
  use("lewis6991/impatient.nvim")
  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ':TSUpdate',
  }
  use { 'nvim-treesitter/nvim-treesitter-refactor' }
  -- LSP
  use { "neovim/nvim-lspconfig" }
  ---- LSP source for nvim-cmp
  use { "hrsh7th/cmp-nvim-lsp" }

  -- Snippets
  use {
    "L3MON4D3/LuaSnip",
    run = "make install_jsregexp",
    requires = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    }
  }

  -- Copilot
  use {
    'github/copilot.vim',
    setup = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.api.nvim_set_keymap("i", "<S-tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
      vim.api.nvim_set_keymap("i", "<M-down>", '<Plug>(copilot-next)', { silent = true, noremap = false })
      vim.api.nvim_set_keymap("i", "<M-up>", '<Plug>(copilot-previous)', { silent = true, noremap = false })
    end,
  }

  ---- Autocompletion
  use {
    "hrsh7th/nvim-cmp", 
    requires = {
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
  }

  use {
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
    requires = {
      "nvim-tree/nvim-web-devicons",
    }
  }

  use {
    'WhiteBlackGoose/magma-nvim-goose',
    run = ':UpdateRemotePlugins',
    config = function()
      vim.g.magma_image_provider = 'kitty'
      vim.g.magma_output_window_borders = false

      map('n', '<leader>r',  '<cmd>MagmaEvaluateOperator<cr>', opts)
      map('n', '<leader>rr', '<cmd>MagmaEvaluateLine<cr>', opts)
      map('x', '<leader>r', '<cmd>MagmaEvaluateVisual<cr>', opts)
      map('n', '<leader>rc', '<cmd>MagmaReevaluateCell<cr>', opts)
      map('n', '<leader>rd', '<cmd>MagmaDelete<cr>', opts)
      map('n', '<leader>ro', '<cmd>MagmaShowOutput<cr>', opts)
    end,
  }

  -- prettier
  use { 'MunifTanjim/prettier.nvim' }

  -- jinja2 / nunjucks
  use { 'Glench/Vim-Jinja2-Syntax' }

  -- Go development
  --use("fatih/vim-go")
  -- Graphql syntax
  use("jparise/vim-graphql")
  -- Display popup with possible keybindings
  use({
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end,
  })
  ---- Lazygit in Neovim
  --use("kdheepak/lazygit.nvim")
  ---- Git
  --use({
  --	"lewis6991/gitsigns.nvim",
  --	config = function()
  --		require("gitsigns").setup()
  --	end,
  --	requires = { "nvim-lua/plenary.nvim" },
  --})
  -- beancount
  use("nathangrigg/vim-beancount")
  -- Fuzzy filtering
  use({
    "nvim-telescope/telescope.nvim",
    config = function()
      require("telescope").setup()
    end,
    requires = { { "nvim-lua/plenary.nvim" } },
  })
  -- colorscheme
  use {
    'flanfly/vim-thar',
    config = function()
      vim.cmd('colorscheme thar')
    end,
  }
  -- status line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require("lualine").setup {
        options = {
          theme = 'seoul256'
        }
      }
    end,
  }
  -- file navigator
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    config = function()
      require("nvim-tree").setup {
        filters = {
          dotfiles = true,
        }
      }
    end,
  }
  -- edit matching parens, brackets, etc
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  -- hilight f/t targets
  use 'unblevable/quick-scope'
  -- fancy lsp diagnostics window
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        padding = false,
        height = 5,
        auto_open = true,
        auto_close = true,
      }
    end
  }
  -- zoom panels
  use 'Pocco81/TrueZen.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)
