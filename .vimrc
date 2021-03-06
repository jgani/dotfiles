set nocompatible " choose no compatibility with legacy vi
runtime macros/matchit.vim
runtime ftplugin/man.vim

filetype off
call pathogen#infect()
filetype plugin indent on

syntax enable
set encoding=utf-8
set modelines=0

set background=dark
let g:solarized_termcolors=256
set t_Co=256 " http://vim.wikia.com/wiki/256_colors_in_vim
colorscheme solarized

set number
set ruler       " show the cursor position all the time
set cursorline
set showcmd     " display incomplete commands
set undofile
set wildmenu
set wildmode=full

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode
set list
set listchars=tab:▸\ ,extends:❯,precedes:❮

let ruby_space_errors = 1
let c_space_errors = 1

let mapleader=","

"" Searching
set hlsearch     " highlight matches
set incsearch    " incremental searching
set showmatch    " show matches
set ignorecase   " searches are case insensitive...
set smartcase    " ... unless they contain at least one capital letter
nnoremap <leader><space> :noh<cr> " clear search

" Ack
nnoremap <leader>a :Ack 
nnoremap <leader>ft Vatzf
nnoremap <leader>v V`]
inoremap jj <ESC> " Quick escape

if has("autocmd")
  au BufNewFile,BufRead *.json set ft=javascript " treat JSON like JavaScript

  " Remember last location in file, but not for commit messages
  " see :help last-position-jump
  au BufReadPost * if &filetype != '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
endif

" provide some context when editing
set scrolloff=3

" http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>

nnoremap <leader><leader> <c-^>

" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

set noswapfile
set backupdir=~/.vim/backup
set undodir=~/.vim/backup
set directory=~/.vim/backup

" Rainbox Parentheses {{{
nnoremap <leader>R :RainbowParenthesesToggle<cr>
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16
" }}}

if has("statusline") && !&cp
  set laststatus=2  " always show the status bar

  " Start the status line
  set statusline=%t%(\ [%n%m]%)%(\ %H%R%W%)\ 

  " Add fugitive
  set statusline+=%{fugitive#statusline()}

  " Finish the statusline
  set statusline+=%(%c-%v,\ %l\ of\ %L,\ (%o)\ %P\ 0x%B\ (%b)%)
endif

" Hash rocket alignments {{{
command! -nargs=? -range Align <line1>,<line2>call AlignSection('<args>')
vnoremap <silent> <Leader>a :Align<CR>
function! AlignSection(regex) range
  let extra = 1
  let sep = empty(a:regex) ? '=' : a:regex
  let maxpos = 0
  let section = getline(a:firstline, a:lastline)
  for line in section
    let pos = match(line, ' *'.sep)
    if maxpos < pos
      let maxpos = pos
    endif
  endfor
  call map(section, 'AlignLine(v:val, sep, maxpos, extra)')
  call setline(a:firstline, section)
endfunction

function! AlignLine(line, sep, maxpos, extra)
  let m = matchlist(a:line, '\(.\{-}\) \{-}\('.a:sep.'.*\)')
  if empty(m)
    return a:line
  endif
  let spaces = repeat(' ', a:maxpos - strlen(m[1]) + a:extra)
  return m[1] . spaces . m[2]
endfunction
" }}}

" Syntax changes Ruby 1.8 -> 1.9 {{{
command! -range Ruby19ify <line1>,<line2>s/:\([^ ]\+\) \+=> \+/\1: /g | :noh
" }}}

" R plugin {{{
let vimrplugin_screenplugin = 0
" }}}

" From http://stevelosh.com/blog/2010/09/coming-home-to-vim/#using-the-leader
nnoremap <tab> % " move to matching bracket by using tab
vnoremap <tab> %
inoremap <F1> <ESC> " disable help, and make F1 behave like ESC
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR> " strip all trailing whitespace in the current file
" From http://vimcasts.org/episodes/the-edit-command/
map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR> " open file in the same directory as the currently active file
map <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR> " same as above but in split window
map <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>
