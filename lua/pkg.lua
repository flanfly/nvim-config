local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  local rtp_addition = vim.fn.stdpath('data') .. '/site/pack/*/start/*'
  if not string.find(vim.o.runtimepath, rtp_addition) then
    vim.o.runtimepath = rtp_addition .. ',' .. vim.o.runtimepath
  end

  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

map = vim.api.nvim_set_keymap
opts = { noremap = true, silent = true }

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

  -- Juptyer notebook sync
  use { "kiyoon/jupynium.nvim", run = "pip3 install --user ." }


  -- ChatGPT
  use({
    "jackMort/ChatGPT.nvim",
      config = function()
        require("chatgpt").setup({
          -- optional configuration
        })

        map("n", "<leader>t", "<cmd>ChatGPT<cr>", opts)
        map("n", "<leader><C-t>", "<cmd>ChatGPTActAs<cr>", opts)
        map("x", "<leader>T", "<cmd>ChatGPTEditWithInstructions<cr>", opts)
        map("n", "<leader>T", "<cmd>ChatGPTEditWithInstructions<cr>", opts)
      end,
      requires = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
      }
  }) 

  -- Copilot
  use {
    'github/copilot.vim',
    setup = function()
      map("i", "<S-tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
      map("i", "<M-down>", '<Plug>(copilot-next)', opts)
      map("i", "<M-up>", '<Plug>(copilot-previous)', opts)

      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
    end
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

      map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
      map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
      map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
      map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
      map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", opts)
      map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", opts)
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

      map("n", "<leader>to", "<cmd>NvimTreeOpen<cr>", opts)
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

      map('n', '<leader>xx', '<cmd>Trouble<cr>', opts)
    end,
  }
  -- zoom panels
  use { 
    'Pocco81/TrueZen.nvim',
    setup = function()
      map('n', '<C-z>', '<cmd>TZFocus<CR>', opts)
      map('t', '<C-z>', '<cmd>TZFocus<CR>', opts)
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)
