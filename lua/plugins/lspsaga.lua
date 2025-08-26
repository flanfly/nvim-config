local keys = {
  jump = "<CR>",
  expand_collapse = " ",
  quit = "<Esc>",
}

return {
  "glepnir/lspsaga.nvim",
  config = function()
    require("lspsaga").setup {
      lightbulb = { enable = false, },
      outline = { keys = keys, },
      finder = { keys = keys, },
      callhierarchy = { keys = keys, },
      code_action = {
        num_shortcut = true,
        show_server_name = false,
        keys = keys,
      }
    }
  end,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
  }
}
