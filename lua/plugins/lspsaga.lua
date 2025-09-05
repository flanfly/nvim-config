local keys = {
  jump = "<CR>",
  expand_collapse = " ",
  quit = "<Esc>",
}

return {
  "glepnir/lspsaga.nvim",
  opts = {
    lightbulb = { enable = false, },
    outline = { keys = keys, },
    finder = {
      keys = {
        toggle_or_open = "<CR>",
        quit = "<Esc>",
      },
    },
    callhierarchy = { keys = keys, },
    code_action = {
      num_shortcut = true,
      show_server_name = false,
      keys = keys,
    }
  },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
  }
}
