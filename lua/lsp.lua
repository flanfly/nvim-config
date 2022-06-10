-- luasnip setup
local luasnip = require 'luasnip'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping(function(fallback)
      print("TAB")
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
       elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer"},
    { name = "cmdline"},
  },
}

cmp.setup.cmdline("/", {
  sources = cmp.config.sources({
    { name = "buffer" }
  }),
})

cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
  { name = "path" },
  { name = "cmdline", keyword_length = 3 },
  }),
})

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  print("attached")
  local opts = { noremap = false, silent = true }
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

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
  yamlls = true,
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
    cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod"},
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
      gopls = {
        experimentalPostfixCompletions = true,
        staticcheck = false,
      },
    },
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
    end,
  },
  -- Lua
  sumneko_lua = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim', 'use' }
        }
      }
    },
  },
}
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
    return
  end

  lspconfig[name].setup(def)
end
-- special case for ts-server
--local ts_server_config = {unpack(default_server_config)}
--ts_server_config['init_options'] = {
--  preferences = {
--    disableSuggestions = true,
--  },
--}
--require("typescript").setup {
--  server = ts_server_config
--}
