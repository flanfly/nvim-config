return {
  "mfussenegger/nvim-lint",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      bash = { "shellcheck" },
      dockerfile = { "hadolint" },
    }

    lint.linters.markdownlint.args = {
      "--fix",
      "--disable",
      "MD013",
      "--",
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
