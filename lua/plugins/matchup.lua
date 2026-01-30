return {
  'andymass/vim-matchup',
  opts = {
    treesitter = {
      stopline = 500,
    },
    matchparen = {
      deferred = 1,
      hi_surround_always = 1,
    },
  },
  init = function()
    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }

    -- map % to m
    map('n', 'm', '<plug>(matchup-%)', opts)
    map('x', 'm', '<plug>(matchup-%)', opts)
  end,
}
