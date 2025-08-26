local opt = { noremap = true, silent = true }

return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  keys = {
    { "<leader>ff", "<cmd>FzfLua files<cr>",                            mode = "n", unpack(opt) },
    { "<leader>fg", "<cmd>FzfLua live_grep<cr>",                        mode = "n", unpack(opt) },
    { "<leader>fr", "<cmd>FzfLua combine pickers=buffers;oldfiles<cr>", mode = "n", unpack(opt) },
    { "<leader>f/", "<cmd>FzfLua grep_curbuf<cr>",                      mode = "n", unpack(opt) },
  },
}
