require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  ensure_installed = {
    "c",
    "lua",
    "go",
    "beancount",
    "html",
    "hcl",
    "json",
    "svelte",
    "tsx",
    "markdown",
    "markdown_inline",
    "typescript",
    "yaml",
    "proto",
    "make",
    "javascript",
    "python",
    "gomod",
    "graphql",
    "dockerfile",
    "cpp",
    "bash"
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing (for "all")
  ignore_install = {},

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {
      "c",
      "lua",
      "go",
      "beancount",
      "html",
      "json",
      "tsx",
      "markdown",
      "markdown_inline",
      "typescript",
      "yaml",
      "rust",
      "proto",
      "make",
      "javascript",
      "python",
      "gomod",
      "graphql",
      "dockerfile",
      "cpp",
      "bash"
    },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = false,
    keymaps = {
      init_selection = "<leader>si",
      node_incremental = "<leader>sn",
      scope_incremental = "<leader>ss",
    },
  },
  indent = {
    enable = true,
  },
  refactor = {
    highlight_definitions = {
      enable = true,
      -- Set to false if you have an `updatetime` of ~100.
      clear_on_cursor_move = true,
    },
    highlight_current_scope = { enable = false },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "gtr",
      },
    },
  },
}

vim.cmd('set foldmethod=expr')
vim.cmd('set foldexpr=nvim_treesitter#foldexpr()')
vim.cmd('set foldlevelstart=99')
