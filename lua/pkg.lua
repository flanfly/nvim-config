local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  local rtp_addition = vim.fn.stdpath('data') .. '/site/pack/*/start/*'
  if not string.find(vim.o.runtimepath, rtp_addition) then
    vim.o.runtimepath = rtp_addition .. ',' .. vim.o.runtimepath
  end

  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

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
  use({
    "neovim/nvim-lspconfig",
    after = { "nvim-cmp"},
  })
  -- LSP source for nvim-cmp
  use("hrsh7th/cmp-nvim-lsp")
  -- Setup and fixes for ts-server w/ LSP
  use {
    "jose-elias-alvarez/typescript.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  }
  -- Completion & Snippets
  use("hrsh7th/cmp-nvim-lua")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-cmdline")
  use("L3MON4D3/LuaSnip")
  use("saadparwaiz1/cmp_luasnip")
  -- Autocompletion
  use({
    "hrsh7th/nvim-cmp",
    after = {
      "LuaSnip",
      "cmp_luasnip",
      "cmp-nvim-lua",
      "cmp-nvim-lsp",
      "cmp-buffer",
      "cmp-path",
      "cmp-cmdline",
    },
  })
  -- Go development
  --use("fatih/vim-go")
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
