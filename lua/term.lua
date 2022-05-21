vim.cmd('autocmd TermOpen * setlocal nonumber norelativenumber')
vim.cmd('autocmd TermOpen * startinsert')
vim.env.EDITOR = 'nvr -cc split --remote-wait'
vim.cmd('autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete')
