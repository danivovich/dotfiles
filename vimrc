call pathogen#runtime_append_all_bundles()

set tabstop=2
set smarttab
set shiftwidth=2
set autoindent
set expandtab
set hidden
set cursorline
set number
syntax enable
set background=dark
colorscheme solarized

set foldlevel=1

let mapleader = ","

set nocompatible

runtime macros/matchit.vim

" NERDTree Setup
map <leader>t :NERDTree<CR>
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

map <leader>n :CommandT<CR>

" don't leave backup files scattered about.
set updatecount=0
set nobackup
set nowritebackup

set nowrap            "no text wrapping
set selectmode=key    "shifted arrows for selection
set foldcolumn=0      "little space on the left.
set softtabstop=2
set ai                "auto indent

set hlsearch
set incsearch
set ignorecase
set smartcase

map <leader><space> :noh<CR>

" Map a shortcut to close a buffer
map <leader>. :BW<CR>

" Shortcut for viewing open buffers
map <leader>m :BufExplorer<CR>

let g:CommandTMaxHeight = 10

" use ,v to make a new vertical split, ,s for horiz, ,x to close a split
noremap <leader>v <c-w>v<c-w>l
noremap <leader>s <c-w>s<c-w>j
noremap <leader>x <c-w>c"

" use ctrl-h/j/k/l to switch between splits
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

filetype plugin indent on
let clj_highlight_builtins = 1

" json syntax
au BufRead,BufNewFile *.json set filetype=json

" options for test and markdown files
au BufRead,BufNewFile *.txt set formatoptions+=aw
au BufRead,BufNewFile *.txt set textwidth=80
au BufRead,BufNewFile *.txt set spell
au BufRead,BufNewFile *.md set formatoptions+=aw
au BufRead,BufNewFile *.md set textwidth=80
au BufRead,BufNewFile *.md set spell

" Super nice pipe alignment while defining cucumber tables
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction
 
" Custom stuff for Rails.vim 
autocmd User Rails Rnavcommand uploader app/uploaders -suffix=_uploader.rb -default=model()
autocmd User Rails Rnavcommand steps features/step_definitions -suffix=_steps.rb -default=web
autocmd User Rails Rnavcommand blueprint spec/blueprints -suffix=_blueprint.rb -default=model()
autocmd User Rails Rnavcommand factory spec/factories -suffix=_factory.rb -default=model()
autocmd User Rails Rnavcommand fabricator spec/fabricators -suffix=_fabricator.rb -default=model()
autocmd User Rails Rnavcommand feature features -suffix=.feature -default=cucumber
autocmd User Rails Rnavcommand support spec/support features/support -default=env

" whitespace killer http://sartak.org/2011/03/end-of-line-whitespace-in-vim.html
set list
set listchars=tab:\ \ ,trail:*
function! <SID>StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
nmap <silent> <Leader>w :call <SID>StripTrailingWhitespace()<CR>

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

