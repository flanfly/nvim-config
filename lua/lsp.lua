-- Add additional capabilities supported by nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  print("attached")
  local opts = { noremap = false, silent = true }
  local map = function(mode, lhs, rhs) 
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
  end

  vim.g.mapleader = ' '

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  --map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  --map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  map("n","gd", "<cmd>Lspsaga goto_definition<CR>")
  map("n","gD", "<cmd>Lspsaga peek_definition<CR>")
  map("n","gh", "<cmd>Lspsaga finder<CR>")

  --map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  map("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>")

  map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  map('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  map("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
  map("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")
  map("n", "<Leader>cO", "<cmd>Lspsaga outline<CR>")
  map("n", "<Leader>ca", "<cmd>Lspsaga code_action<CR>")
  map("n", "<Leader>cr", "<cmd>Lspsaga rename<CR>")

  
  map('n', '<leader>x', '<cmd>lua vim.diagnostic.open_float()<CR>')
  map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
  map('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>')

  local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
  local event = "BufWritePre" -- or "BufWritePost"
  local async = event == "BufWritePost"
  if client.supports_method("textDocument/formatting") then
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

--vim.lsp.set_log_level(vim.log.levels.INFO)

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local lspconfig = require('lspconfig')
local util = require("lspconfig/util")
local servers = {
  bashls = true,
  cmake = true,
  dockerls = true,
  golangci_lint_ls = false,
  html = true,
  jsonls = true,
  bufls = true,
  yamlls = true,
  graphql = true,
  tsserver = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
  },
  rls = false,
  rust_analyzer = true,
  tailwindcss = true,
  svelte = true,
  solidity_ls_nomicfoundation = true,
  eslint = {
    cmd = { "eslint-language-server", "--stdio" },
  },
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
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = util.root_pattern("compile_commands.json", ".git"),
  },
  -- Golang (gopls)
  gopls = {
    cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod"},
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
      gopls = {
        experimentalPostfixCompletions = true,
        staticcheck = true,
      },
    },
  },
  -- Lua
  lua_ls = true,
}

-- luasnip setup
local luasnip = require 'luasnip'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- nvim-cmp setup
local lspkind = require 'lspkind'
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    keyword_length = 3,
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',
      maxwidth = 50,
      ellipsis_char = '...',
    })
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        local entry = cmp.get_selected_entry()
        if not entry then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          cmp.confirm()
        end
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp_signature_help" },
    { name = "nvim_lsp",  },
    { name = "luasnip" },
    { name = "treesitter" },
    { name = "path" },
    { name = "calc" },
  }, {
    { name = "buffer"},
  }),
}
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'cmdline_history' },
    { name = 'buffer' }
  }
})
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- default server config
local default_server_config = {
  on_attach = on_attach,
  capabilities = capabilities,
}
for name, cfg in pairs(servers) do
  local def = {}
  for k,v in pairs(default_server_config) do def[k] = v end

  -- default server config
   if type(cfg) == 'table' then
    -- merge server specific config
    for k,v in pairs(cfg) do def[k] = v end
  elseif cfg == false then
    -- skip this server
    goto continue
  end

  lspconfig[name].setup(def)
  ::continue::
end

prettier = require 'prettier'
prettier.setup({
  bin = 'prettier', -- or `'prettierd'` (v0.22+)
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
  cli_options = {
    -- https://prettier.io/docs/en/cli.html#--config-precedence
    config_precedence = "prefer-file", -- or "cli-override" or "file-override"
  },
})
