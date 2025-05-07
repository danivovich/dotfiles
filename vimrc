set nocompatible

syntax on

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
set statusline=%<%f\ %h%w%m%r%y%=L:%l/%L\ (%p%%)\ C:%c
set t_Co=16
set background=dark
colorscheme neodark
let g:airline_theme='neodark'
let g:nord_cursor_line_number_background = 1

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

" fast nav
map <leader>j 15j<CR>
map <leader>k 15k<CR>

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

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

" Elixir file types
"au BufRead,BufNewFile *.ex,*.exs set filetype=elixir
"au BufRead,BufNewFile *.eex,*.heex,*.leex,*.sface,*.lexs set filetype=eelixir
"au BufRead,BufNewFile mix.lock set filetype=elixir

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

let g:mix_format_on_save = 1
let g:augment_workspace_folders = []

autocmd VimEnter * Copilot disable
