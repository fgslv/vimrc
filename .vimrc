set nocompatible
syntax on
filetype plugin indent on
set laststatus=2
set shiftwidth=2
set cursorline
set number
set belloff=all

call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'

Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'vim-airline/vim-airline'
Plug 'jlanzarotta/bufexplorer'

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
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
augroup ProjectDrawer
  autocmd!
  autocmd VimEnter * :Vexplore
augroup END

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
