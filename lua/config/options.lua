-- Scroll earlyopt
vim.o.scrolloff = 6
-- Always display the last status
vim.o.laststatus = 3
-- Tabs are two spaces
vim.o.shiftwidth = 2
vim.o.linespace = 2
vim.o.tabstop = 2
vim.o.expandtab = true
-- Allow clicks
vim.o.mouse = 'a'
-- Open new splits below and on the right
vim.o.splitright = true
vim.o.splitbelow = true
-- Don't hide the mouse while typing
vim.o.mousehide = false
-- Incremental live completion
vim.o.inccommand = "nosplit"
-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"
-- Enable highlight on search
vim.o.hlsearch = true
-- highlight match while typing search pattern
vim.o.incsearch = true
-- Make line numbers default
vim.wo.number = true
-- Do not save when switching buffers
vim.o.hidden = true
-- Enable break indent
vim.o.breakindent = true
-- Use swapfiles
vim.o.swapfile = true
-- Save undo history
vim.o.undofile = true
vim.o.undolevels = 1000
-- Faster scrolling
vim.o.lazyredraw = true
-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"
-- Decrease redraw time
vim.o.redrawtime = 200
-- Disable intro message
vim.opt.shortmess:append("I")
-- Disable ins-completion-menu messages
vim.opt.shortmess:append("c")
-- Take indent for new line from previous line
vim.o.autoindent = true
vim.o.smartindent = true
-- Number of command-lines that are remembered
vim.o.history = 10000
-- Use menu for command line completion
vim.o.wildmenu = true
-- Enable wrap
--vim.o.wrap = true
-- Wrap long lines at a blank
--vim.o.linebreak = true
-- Autom. read file when changed outside of Vim
vim.o.autoread = true
-- Show cursor line and column in the status line
vim.o.ruler = true
-- Show absolute line number in front of each line
vim.o.relativenumber = false
-- Ignore case when completing file names and directories.
vim.o.wildignorecase = true
-- beam cursor in insert mode, block cursor in normal mode
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
-- use tree-sitter for folding
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevelstart = 99
