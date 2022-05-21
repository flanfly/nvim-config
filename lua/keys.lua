local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.g.mapleader = ' '

-- close quickfix win on <Esc>
vim.cmd('autocmd FileType qf nnoremap <buffer><silent> <esc> :quit<cr>')
-- close quickfix win on selection
vim.cmd('autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>')

-- fuzzy finder
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", opts)
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", opts)

-- nvim tree
map("n", "<leader>to", "<cmd>NvimTreeOpen<cr>", opts)

-- lazy git
map("n", "<leader>gg", "<cmd>LazyGit<CR>", opts)

-- terminal
map('t', '<Esc>', '<C-\\><C-n>', opts)
map('t', '<C-w>h', '<C-\\><C-N><C-w>h', opts)
map('t', '<C-w>j', '<C-\\><C-N><C-w>j', opts)
map('t', '<C-w>k', '<C-\\><C-N><C-w>k', opts)
map('t', '<C-w>l', '<C-\\><C-N><C-w>l', opts)

-- zoom
map('n', '<C-z>', '<cmd>TZFocus<CR>', opts)
map('t', '<C-z>', '<cmd>TZFocus<CR>', opts)

--- trouble
map('n', '<leader>xx', '<cmd>Trouble<cr>', opts)

-- lsp
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
map('n', '<leader>x', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
map('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- format go code
vim.cmd('autocmd BufWritePre *.go lua vim.lsp.buf.formatting()')
function org_imports(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.organizeImports"}}
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end
vim.cmd('autocmd BufWritePre *.go lua org_imports(1000)')
