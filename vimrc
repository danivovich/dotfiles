set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

" Vundle setup
Plugin 'gmarik/Vundle.vim'

" Languages
Plugin 'vim-ruby/vim-ruby'
Plugin 'fatih/vim-go'
Plugin 'plasticboy/vim-markdown'
Plugin 'kchmck/vim-coffee-script'
Plugin 'elixir-lang/vim-elixir'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'pearofducks/ansible-vim'
Plugin 'glench/vim-jinja2-syntax'

" tpope section
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-cucumber'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-projectionist'

" testing help
Plugin 'tpope/vim-dispatch'

" utils
Plugin 'scrooloose/nerdcommenter'
Plugin 'coderifous/textobj-word-column.vim'
Plugin 'godlygeek/tabular'
Plugin 'sjl/gundo.vim'
Plugin 'ervandew/supertab'
Plugin 'junegunn/fzf'

" navigation
Plugin 'mileszs/ack.vim'
Plugin 'bufexplorer.zip'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'

" Themes
Plugin 'altercation/vim-colors-solarized'

call vundle#end()

filetype plugin indent on

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
set t_Co=16
set background=light
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

" ctrlp.vim
map <leader>f :CtrlP<CR>
map <leader>b :CtrlPBuffer<CR>

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
au FileType go set softtabstop=2 tabstop=2 shiftwidth=2 textwidth=79

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Running tests
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" In Place Running

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.py\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    if expand("%") != ""
      :w
    end
    if match(a:filename, '\.feature$') != -1
        exec ":!script/features " . a:filename
    else
        " First choice: project-specific test script
        if filereadable("script/test")
            exec ":!script/test " . a:filename
        " Fall back to the .test-commands pipe if available, assuming someone
        " is reading the other side and running the commands
        elseif filewritable(".test-commands")
          let cmd = 'rspec --color --format progress --require "~/lib/vim_rspec_formatter" --format VimFormatter --out tmp/quickfix'
          exec ":!echo " . cmd . " " . a:filename . " > .test-commands"

          " Write an empty string to block until the command completes
          sleep 100m " milliseconds
          :!echo > .test-commands
          redraw!
        " Fall back to a blocking test run with Bundler
        elseif filereadable("Gemfile")
            exec ":!bundle exec rspec --color " . a:filename
        " If we see python-looking tests, assume they should be run with Nose
        elseif strlen(glob("test/**/*.py") . glob("tests/**/*.py"))
            exec "!nosetests " . a:filename
        " Fall back to a normal blocking test run
        else
            exec ":!rspec --color " . a:filename
        end
    end
endfunction

map <leader>u :call RunTestFile()<cr>
map <leader>U :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>

" Dispatch Running

function! DispatchRunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.py\)$') != -1
    if in_test_file
        call DispatchSetTestFile()
    elseif !exists("t:dispatch_test_file")
        return
    end
    call DispatchRunTests(t:dispatch_test_file . command_suffix)
endfunction

function! DispatchRunNearestTest()
    let spec_line_number = line('.')
    call DispatchRunTestFile(":" . spec_line_number)
endfunction

function! DispatchSetTestFile()
    " Set the spec file that tests will be run for.
    let t:dispatch_test_file=@%
endfunction

function! DispatchRunTests(filename)
    " Write the file and run tests for the given filename
    if expand("%") != ""
      :w
    end
    if match(a:filename, '\.feature$') != -1
        exec ":Focus cucumber " . a:filename
    else
        exec ":Focus rspec --color " . a:filename
    end
    exec ":Dispatch"
endfunction

map <leader>t :call DispatchRunTestFile()<cr>
map <leader>T :call DispatchRunNearestTest()<cr>

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

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

let g:rails_projections = {
      \ "config/projections.json": {
      \   "command": "projections"
      \ },
      \ "spec/features/*_spec.rb": {
      \   "command": "feature",
      \   "template": "require 'spec_helper'\n\nfeature '%h' do\n\nend",
      \ },
      \ "features/*.feature" : {
      \   "command" : "feature"
      \ },
      \ "features/step_definitions/*_steps.rb" : {
      \   "command" : "steps"
      \ },
      \ "app/uploaders/*_uploader.rb" : {
      \   "command" : "uploader"
      \ },
      \ "app/reports/*.rb" : {
      \   "command" : "report"
      \ },
      \ "app/importers/*.rb" : {
      \   "command" : "import"
      \ },
      \ "app/exporters/*.rb" : {
      \   "command" : "export"
      \ },
      \ "app/jobs/*.rb" : {
      \   "command" : "worker"
      \ },
      \ "app/workers/*.rb" : {
      \   "command" : "worker"
      \ },
      \ "spec/factories/*.rb": {
      \   "command":   "factory",
      \   "affinity":  "collection",
      \   "alternate": "app/models/%i.rb",
      \   "related":   "db/schema.rb#%s",
      \   "test":      "spec/models/%i_test.rb",
      \   "template":  "FactoryGirl.define do\n  factory :%i do\n  end\nend",
      \   "keywords":  "factory sequence"
      \ },
      \ "spec/factories.rb": {
      \   "command":   "factory"
      \ }}

let g:rails_gem_projections = {
      \ "active_model_serializers": {
      \   "app/serializers/*_serializer.rb": {
      \     "command": "serializer",
      \     "affinity": "model",
      \     "test": "spec/serializers/%s_spec.rb",
      \     "related": "app/models/%s.rb",
      \     "template": "class %SSerializer < ActiveModel::Serializer\nend"
      \   }
      \ }}
