vim.cmd('autocmd TermOpen * setlocal nonumber norelativenumber')
vim.cmd('autocmd TermOpen * startinsert')
vim.env.EDITOR = 'nvr --servername "$NVIM" -cc split --remote-wait'
vim.env.GIT_EDITOR = 'nvr --servername "$NVIM" -cc split --remote-wait'
vim.cmd('autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete')
