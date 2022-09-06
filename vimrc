set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Languages
Plug 'vim-ruby/vim-ruby'
Plug 'fatih/vim-go'
" Plug 'plasticboy/vim-markdown'
Plug 'kchmck/vim-coffee-script'
Plug 'elixir-lang/vim-elixir'
Plug 'rust-lang/rust.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'pearofducks/ansible-vim'
Plug 'glench/vim-jinja2-syntax'
Plug 'hashivim/vim-terraform'

" tpope section
Plug 'tpope/vim-rake'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'

" testing help
Plug 'tpope/vim-dispatch'

" utils
Plug 'scrooloose/nerdcommenter'
Plug 'coderifous/textobj-word-column.vim'
" Plug 'godlygeek/tabular'
Plug 'sjl/gundo.vim'
Plug 'ervandew/supertab'
Plug 'junegunn/fzf'
Plug 'dense-analysis/ale'

" navigation
Plug 'mileszs/ack.vim'
Plug 'jlanzarotta/bufexplorer'
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'

" Themes
Plug 'altercation/vim-colors-solarized'

call plug#end()

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
set laststatus=2
"set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
set statusline=%<%f\ %h%w%m%r%y%=L:%l/%L\ (%p%%)\ C:%c
set t_Co=16
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
set nofoldenable

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


" Optional, configure as-you-type completions
set completeopt=menu,menuone,preview,noselect,noinsert

let g:ale_linters = {}
let g:ale_linters.scss = ['stylelint']
let g:ale_linters.css = ['stylelint']
let g:ale_linters.elixir = ['elixir-ls', 'credo']
let g:ale_linters.ruby = ['rubocop', 'ruby', 'solargraph']

let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace']}
"let g:ale_fixers.javascript = ['eslint', 'prettier']
let g:ale_fixers.html = ['prettier']
let g:ale_fixers.scss = ['stylelint']
let g:ale_fixers.css = ['stylelint']
"let g:ale_fixers.elm = ['format']
let g:ale_fixers.ruby = ['rubocop']
let g:ale_ruby_rubocop_executable = 'bundle'
"let g:ale_fixers.elixir = ['mix_format']
let g:ale_fixers.xml = ['xmllint']

" Required, tell ALE where to find Elixir LS
let g:ale_elixir_elixir_ls_release = expand("~/Code/elixir-ls/rel")
let g:ale_elixir_elixir_ls_config = {'elixirLS': {'dialyzerEnabled': v:false}}
let g:ale_sign_column_always = 1
let g:ale_elixir_credo_strict = 1

let g:ale_completion_enabled = 1
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
let g:ale_linters_explicit = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1

noremap <Leader>ad :ALEGoToDefinition<CR>
nnoremap <leader>af :ALEFix<cr>
noremap <Leader>ar :ALEFindReferences<CR>

"Move between linting errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>
