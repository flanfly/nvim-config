return {
  'nvim-mini/mini.ai',
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  opts = function()
    local ai = require("mini.ai")
    return {
      n_lines = 999999,
      -- Set up custom text objects for Treesitter
      custom_textobjects = {
        -- 'f' for function. You can use any key you like.
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
        A = ai.gen_spec.treesitter({ a = "@assignment.outer", i = "@assignment.inner" }),
      },
    }
  end,
}
