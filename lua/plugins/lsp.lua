-----------------------
-- LSP & autocompletion
-----------------------

local on_attach = function(client, bufnr)
  vim.notify(string.format("%s attached", client.name), vim.log.levels.INFO, { title = "LSP" })

  local opts = { noremap = false, silent = true }
  local map = function(mode, lhs, rhs)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
  end

  vim.g.mapleader = ' '

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  map("n", "gd", "<cmd>Lspsaga goto_definition<CR>")
  map("n", "gD", "<cmd>Lspsaga peek_definition<CR>")

  map("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>")

  map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  map('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  --map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  map("n", "gr", "<cmd>Lspsaga finder<CR>")
  --map("n", "gr", "<cmd>Telescope lsp_references<CR>")
  --map("n", "gr", "<cmd>FzfLua lsp_references<CR>")

  --map("n", "<Leader>cI", "<cmd>Lspsaga incoming_calls<CR>")
  --map("n", "<Leader>cO", "<cmd>Lspsaga outgoing_calls<CR>")
  map("n", "<Leader>cI", "<cmd>Telescope lsp_incoming_calls<CR>")
  map("n", "<Leader>cO", "<cmd>Telescope lsp_outgoing_calls<CR>")
  map("n", "<Leader>co", "<cmd>Lspsaga outline<CR>")
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  map("n", "<Leader>ca", "<cmd>Lspsaga code_action<CR>")
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  map("n", "<Leader>cr", "<cmd>Lspsaga rename<CR>")

  map('n', '<leader>x', '<cmd>lua vim.diagnostic.open_float()<CR>')
  map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
  map('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')

  local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
  local event = "BufWritePre" -- or "BufWritePost"
  local async = event == "BufWritePost"
  if client.supports_method("textDocument/formatting") then
    --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    vim.keymap.set("n", "<Leader>cf", function()
      vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
    end, { buffer = bufnr, desc = "[lsp] format" })

    -- format on save
    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
    vim.api.nvim_create_autocmd(event, {
      buffer = bufnr,
      group = group,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr, async = async })
      end,
      desc = "[lsp] format on save",
    })
  end

  if client.supports_method("textDocument/rangeFormatting") then
    vim.keymap.set("x", "<Leader>cf", function()
      vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
    end, { buffer = bufnr, desc = "[lsp] format" })
  end
end

-- server configs
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    'saghen/blink.cmp',
    "glepnir/lspsaga.nvim",
  },
  config = function()
    -- default server config
    vim.lsp.config("*", {
      on_attach = on_attach,
      --capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      },
    })

    -- server specific configs
    local servers = {
      bashls = {},
      cmake = {},
      docker_language_server = {},
      golangci_lint_ls = {},
      html = {},
      helm_ls = {
        filetypes = { "helm" },
        settings = {
          ['helm-ls'] = {
            yamlls = {
              enabled = true,
              enabledForFilesGlob = "*.{yaml,yml}",
              diagnosticsLimit = 50,
              showDiagnosticsDirectly = false,
              path = "yaml-language-server",
              config = {
                completion = true,
                hover = true,
              }
            }
          },
        },
      },
      jsonls = {},
      buf_ls = {},
      -- yamlls = {
      --  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
      --},
      graphql = {},
      ts_ls = {},
      rls = {},
      rust_analyzer = {},
      tailwindcss = {},
      svelte = {},
      solidity_ls_nomicfoundation = {},
      -- eslint = true,--{
      --  cmd = { "eslint-language-server", "--stdio" },
      --},
      terraformls = {
        cmd = { "terraform-ls", "serve" },
        filetypes = { "terraform", "terraform-vars", "tf", "hcl" },
        settings = {
          terraform = {
            lint = {
              enable = true,
              ignore = {
                "terraform_unused_declarations",
                "terraform_unused_providers",
                "terraform_unused_variables",
                "terraform_typed_variables",
              },
            },
            format = {
              enable = true,
              ignore = {
                "terraform_unused_declarations",
                "terraform_unused_providers",
                "terraform_unused_variables",
                "terraform_typed_variables",
              },
            },
          },
        },
      },
      tflint = {},
      -- Python
      pylsp = {
        cmd = { "pylsp" },
        filetypes = { "python" },
        single_file_support = true,
      },
      -- C/C++ (clangd)
      clangd = {
        cmd = {
          "clangd",
          "-j=4",
          "-completion-style=detailed",
          "-background-index",
          "-all-scopes-completion",
          "--suggest-missing-includes"
        },
      },
      -- Golang (gopls)
      gopls = {
        cmd = { "gopls", "serve" },
        settings = {
          gopls = {
            experimentalPostfixCompletions = true,
            staticcheck = true,
          },
        },
      },
      -- Lua for nvim
      lua_ls = {
        on_init = function(client)
          -- skip for non-nvim lua
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath('config') and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
                -- Depending on the usage, you might want to add additional paths here.
                -- "${3rd}/luv/library"
                -- "${3rd}/busted/library",
              }
              -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
              -- library = vim.api.nvim_get_runtime_file("", true)
            }
          })
        end,
        settings = {
          Lua = {},
        },
      },
    }

    local mkcaps = require('blink.cmp').get_lsp_capabilities

    for name, cfg in pairs(servers) do
      -- default server config
      if type(cfg) == 'table' then
        -- merge server specific config
        cfg.capabilities = mkcaps(cfg.capabilities)
        vim.lsp.config(name, cfg)
      elseif cfg == false then
        -- skip this server
        goto continue
      end

      vim.lsp.enable(name)
      ::continue::
    end
  end
}
--  ---- autocompletion
--  --{
--  --  "hrsh7th/nvim-cmp",
--  --  dependencies = {
--  --    -- Sources
--  --    "hrsh7th/cmp-buffer",
--  --    "hrsh7th/cmp-path",
--  --    "hrsh7th/cmp-cmdline",
--  --    "hrsh7th/cmp-calc",
--  --    "hrsh7th/cmp-nvim-lsp-signature-help",
--  --    "ray-x/cmp-treesitter",
--  --    "dmitmel/cmp-cmdline-history",
--  --    -- LSP source for nvim-cmp
--  --    "hrsh7th/cmp-nvim-lsp",
--  --    "onsails/lspkind.nvim",
--  --  },
--  --},
--  ---- code outline, menus for incoming/outgoing calls, code actions and references
--  --{
--  --  "glepnir/lspsaga.nvim",
--  --  config = function()
--  --    require("lspsaga").setup {
--  --      lightbulb = {
--  --        enable = false,
--  --      },
--  --      outline = {
--  --        keys = {
--  --          jump = "<CR>",
--  --          expand_collapse = " ",
--  --          quit = "<Esc>",
--  --        },
--  --      },
--  --      callhierarchy = {
--  --        keys = {
--  --          jump = "<CR>",
--  --          quit = "<Esc>",
--  --          expand_collapse = " ",
--  --        },
--  --      },
--  --      code_action = {
--  --        num_shortcut = true,
--  --        show_server_name = false,
--  --        keys = {
--  --          quit = "<Esc>",
--  --          exec = "<CR>",
--  --        },
--  --      }
--  --    }
--  --  end,
--  --  dependencies = {
--  --    "nvim-tree/nvim-web-devicons",
--  --    "nvim-treesitter/nvim-treesitter",
--  --  }
--  --},
--  ---- fancy lsp diagnostics window
--  ---- <leader>xx to open diagnostics
--  --{
--  --  "folke/trouble.nvim",
--  --  opts = {},
--  --  cmd = "Trouble",
--  --  keys = {
--  --    { '<leader>xx', '<cmd>Trouble diagnostics<cr>', mode = 'n', unpack(opt) },
--  --  },
--  --  dependencies = "nvim-tree/nvim-web-devicons",
--  --  config = function()
--  --    require("trouble").setup {
--  --      padding = false,
--  --      height = 5,
--  --      modes = {
--  --        diagnostics = {
--  --          auto_close = true,
--  --        },
--  --      },
--  --    }
--  --  end,
--  --}
