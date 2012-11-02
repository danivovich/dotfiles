call pathogen#runtime_append_all_bundles()

set nocompatible
set encoding=utf-8

set tabstop=2
set smarttab
set shiftwidth=2
set autoindent
set expandtab
set hidden
set cursorline
set number
set scrolloff=3
syntax enable
set laststatus=2
"set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
set statusline=%<%f\ %h%w%m%r%y%=L:%l/%L\ (%p%%)\ C:%c
set t_Co=256
set background=dark
colorscheme solarized

" don't leave backup files scattered about.
set updatecount=0
set nobackup
set nowritebackup
set noswapfile

set nowrap            "no text wrapping
set selectmode=key    "shifted arrows for selection
set foldcolumn=0      "little space on the left.
set softtabstop=2
set ai                "auto indent

set hlsearch
set incsearch
set ignorecase
set smartcase
set foldlevel=1

command! W :w

let mapleader = ","

" fast nav
map <leader>j 15j<CR>
map <leader>k 15k<CR>

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

" NERDTree Setup
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

" CommandT
map <leader>f :CommandT<CR>
map <leader>b :CommandTBuffer<CR>
let g:CommandTMaxHeight = 10

" gundo config
nnoremap <leader>r :GundoToggle<CR>
let g:gundo_preview_height = 30

" Map ,e and ,v to open files in the same directory as the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

" ways to clear the search highlighting
map <leader><space> :nohlsearch<CR>

" fast switching between two recent buffers
nnoremap <leader><leader> <C-^>

" Map a shortcut to close a buffer
map <leader>. :bd<CR>

" Shortcut for viewing open buffers
map <leader>m :BufExplorer<CR>

" use ,v to make a new vertical split, ,s for horiz, ,x to close a split
noremap <leader>v <c-w>v<c-w>l
noremap <leader>s <c-w>s<c-w>j
noremap <leader>x <c-w>c"

" use ctrl-h/j/k/l to switch between splits
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" go hardcore on not using the arrow keys for nav
map <Left> :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up> :echo "no!"<cr>
map <Down> :echo "no!"<cr>

filetype plugin indent on
let clj_highlight_builtins = 1

au FileType make set noexpandtab

" json syntax
au BufRead,BufNewFile *.json set filetype=json

function s:setupWrapping()
  set formatoptions+=aw
  set textwidth=80
  set spell
endfunction

" options for test and markdown files
au BufRead,BufNewFile *.{txt} call s:setupWrapping()

au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru,Guardfile} set ft=ruby

au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

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
autocmd User Rails Rnavcommand report app/reports
autocmd User Rails Rnavcommand import app/importers
autocmd User Rails Rnavcommand export app/exporters

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Running tests
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! RunTests(filename)
  " Write the file and run tests for the given filename
  :w
  if match(a:filename, '\.feature$') != -1
    if filereadable("Gemfile")
      exec ":!bundle exec cucumber " . a:filename
    else
      exec ":!cucumber " . a:filename
    end
  else
    if filereadable("Gemfile")
      exec ":!bundle exec rspec --color " . a:filename
    else
      exec ":!rspec --color " . a:filename
    end
  end
endfunction

function! SetTestFile()
  " Set the spec file that tests will be run for.
  let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  " Run the tests for the previously-marked file.
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
  if in_test_file
    call SetTestFile()
  elseif !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
  let spec_line_number = line('.')
  call RunTestFile(":" . spec_line_number . " -b")
endfunction

map <leader>u :call RunTestFile()<cr>
map <leader>U :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>

let g:turbux_command_prefix = 'bundle exec' " default: (empty)

" whitespace killer http://sartak.org/2011/03/end-of-line-whitespace-in-vim.html
set list
set listchars=tab:\ \ ,trail:·
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

" Enable syntastic syntax checking
let g:syntastic_enable_signs=1
let g:syntastic_quiet_warnings=1
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': ['cucumber', 'cpp'] }

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

