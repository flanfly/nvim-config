call plug#begin('~/.local/share/nvim/plugged')

" --- Coc ---
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'neovim/nvim-lspconfig'

" --- FZF and ripgrep ---
Plug 'jremmen/vim-ripgrep'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" --- Statusline ---
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" --- Git ---
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'mattn/webapi-vim'
Plug 'mattn/vim-gist'

" --- Language Ext. ---
Plug 'rust-lang/rust.vim'
Plug 'hashivim/vim-terraform'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'ledger/vim-ledger'
Plug 'towolf/vim-helm'
Plug 'lervag/vimtex'
Plug 'jparise/vim-graphql'

" TSX highlighting, tsserver is handled by CoC
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" --- Snippets ---
Plug 'honza/vim-snippets'
Plug 'andrewstuart/vim-kubernetes'

" --- JS coverage info ---
Plug 'retorillo/istanbul.vim'

" --- Misc ---
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'scrooloose/nerdtree'
Plug 'shougo/echodoc.vim'
Plug 'flanfly/vim-thar'
Plug 'unblevable/quick-scope'
Plug 'junegunn/vim-easy-align'
Plug 'shime/vim-livedown'
Plug 'preservim/tagbar'
Plug 'Pocco81/TrueZen.nvim'

call plug#end()

set laststatus=2
set enc=utf-8
set swb=useopen
set nomousehide
set autoindent
set nu
set hlsearch
set shiftwidth=2
set linespace=2
set tabstop=2
set et
set splitright
set splitbelow
set hidden
set mouse=a

tnoremap <C-Esc> <C-\><C-n>
nnoremap <C-p> :History<Cr>
" OSX
nnoremap <A-p> :History<Cr>

colorscheme thar

" Style Pmenu (completition popup)
hi Pmenu guibg=grey30 ctermbg=242
hi PmenuSel guibg=grey20 term=bold cterm=bold gui=bold

" GitGutter
let g:gitgutter_sign_added = '•'
let g:gitgutter_sign_modified = '•'
let g:gitgutter_sign_removed = '•'
let g:gitgutter_sign_removed_first_line = '•'
let g:gitgutter_sign_modified_removed = '•'
highlight GitGutterAdd ctermfg=2 guifg=springgreen
highlight GitGutterChange ctermfg=3 guifg=yellow
highlight GitGutterDelete ctermfg=5 guifg=indianred

" Persistent UNDO
if has('persistent_undo')      "check if your vim version supports it
  set undofile                 "turn on the feature  
  set undodir=~/.local/share/nvim/undo  "directory where the undo files will be stored
endif

" Coc
set shortmess+=c
set updatetime=300
let g:coc_global_extensions = [ 'coc-css', 'coc-go', 'coc-highlight', 'coc-html', 'coc-inline-jest', 'coc-json', 'coc-pyls', 'coc-rls', 'coc-snippets', 'coc-solargraph', 'coc-sql', 'coc-swagger', 'coc-tsserver', 'coc-vimtex', 'coc-yaml' ]

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

" Rust.vim
let g:rustfmt_autosave_if_config_present = 1

" Typescript/TSX
autocmd BufNewFile,BufRead *.tsx,*.jsx, set filetype=typescript.tsx

" Ripgrep.vim
let g:rg_highlight = 1
let g:rg_derive_root = 1
let g:rg_root_types = ['.git', 'package.json', 'Cargo.toml']
let g:rg_binary = '/usr/local/bin/rg'

" Vimtex
let g:tex_flavor = 'latex'

" Tagbar
let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }

" TrueZen 
map <C-w>z :TZFocus<CR>

" Fix :terminal
tnoremap <Esc> <C-\><C-n>
autocmd TermOpen * setlocal nonumber norelativenumber
autocmd TermOpen * startinsert
if has('nvim')
  let $EDITOR = 'nvr -cc split --remote-wait'
endif
autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
