local opt = { noremap = true, silent = true }

return {
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
}
