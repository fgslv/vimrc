" vim-plug required!
" installation: curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

set nocompatible
syntax on
filetype plugin indent on
set laststatus=2
set shiftwidth=2
set cursorline
set number
set belloff=all
set encoding=utf-8

"  disable scrollbar on the right side of the window
set guioptions=Ace

" TextEdit might fail if hidden is not set. (con.vim)
set hidden

" Some servers have issues with backup files, see #649 (coc.vim)
set nobackup
set nowritebackup

" Give more space for displaying messages. (coc.vim)
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience. (coc.vim)
set updatetime=300

" Don't pass messages to |ins-completion-menu|. (coc.vim)
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'

Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'vim-airline/vim-airline'
Plug 'jlanzarotta/bufexplorer'
Plug 'leafgarland/typescript-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

colorscheme gruvbox
set bg=dark

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" Buffers - explore/next/previous: Alt-F12, F12, Shift-F12.
nnoremap <silent> <M-F12> :BufExplorer<CR>
nnoremap <silent> <F12> :bn<CR>
nnoremap <silent> <S-F12> :bp<CR>

" Enable netrw to display 3 nesting folders
let g:netrw_banner = 0
let g:netrw_liststyle = 5
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 75

" Font configuration
if has("gui_kde")
  set guifont=Consolas/13/-1/5/50/0/0/0/0/0
elseif has("gui_gtk")
  set guifont=Consolas\ 13
elseif has("gui_running")
  if has("win32") || has("win64")
    set guifont=Consolas:h12
  else
    set guifont=-xos4-terminus-medium-r-normal--14-140-72-72-c-80-iso8859-1
  endif
endif

function! FormatJson()
python3 << EOF
import vim
import json
try:
  buf = vim.current.buffer
  json_content = '\n'.join(buf[:])
  content = json.loads(json_content)
  sorted_content = json.dumps(content, indent=2, sort_keys=True)
  buf[:] = sorted_content.split('\n')
except Exception as e:
  print(e)
EOF
endfunction

function! DumpDicom()
python3 << EOF
import vim
import pydicom

inFilename = vim.current.buffer.name
outFilename = vim.current.buffer.name+'.dump.txt'

ds = pydicom.dcmread(inFilename)
f = open(str(outFilename), 'w')
f.write(str(ds))
f.close()

vim.command(':e ' + outFilename)
EOF
endfunction

" Show callee
function! Csc()
  cscope find c <cword>
  copen
endfunction
command! Csc call Csc()

" Show definition
function! Csg()
  cscope find d <cword>
  copen
endfunction
command! Csg call Csg()

hi link Repeat Statement

function! HighlightRepeats() range
  let lineCounts = {}
  let lineNum = a:firstline
  while lineNum <= a:lastline
    let lineText = getline(lineNum)
    if lineText != ""
      let lineCounts[lineText] = (has_key(lineCounts, lineText) ? lineCounts[lineText] : 0) + 1
    endif
    let lineNum = lineNum + 1
  endwhile
  exe 'syn clear Repeat'
  for lineText in keys(lineCounts)
    if lineCounts[lineText] >= 2
      exe 'syn match Repeat "^' . escape(lineText, '".\^$*[]') . '$"'
    endif
  endfor
endfunction

command! -range=% HighlightRepeats <line1>,<line2>call HighlightRepeats()
