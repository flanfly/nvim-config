return {
  'saghen/blink.cmp',
  dependencies = { 'L3MON4D3/LuaSnip', version = 'v2.*' },
  version = '1.*',
  opts = {
    keymap = {
      preset = 'none',

      ['<Tab>'] = { 'accept', 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['Esc'] = { 'cancel', 'fallback' },
      ['K'] = { 'show_signature', 'hide_signature', 'fallback' }
    },
    snippets = { preset = 'luasnip' },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
      documentation = { auto_show = false },
      list = { selection = { auto_insert = false } },
      menu = {
        draw = {
          columns = {
            { "label",     "label_description", gap = 1 },
            { "kind_icon", "kind" }
          },
        },
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    signature = { enabled = true },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    cmdline = {
      keymap = { preset = 'inherit' },
      completion = { menu = { auto_show = true } },
    },
  },
  opts_extend = { "sources.default" }
}
