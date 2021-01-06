colo ocean
set nu rnu
set so=10
set ch=5
set scl=yes:1
set nosmd
set cul
au BufEnter,InsertLeave * set rnu | hi StatuslineMode ctermfg=0 ctermbg=15
au BufLeave,InsertEnter * set nornu | hi StatuslineMode ctermfg=0 ctermbg=1

" mode
let g:currentmode={
    \ 'n'      : 'N',
    \ 'i'      : 'I',
    \ 'R'      : 'R',
    \ 'c'      : 'C',
    \ 'v'      : 'V',
    \ 's'      : 'S',
    \ 't'      : 'T',
    \ 'ce'     : 'E',
    \ 'cv'     : 'VE',
    \ 'V'      : 'V Line',
    \ '\<C-V>' : 'V Block',
    \ 'S'      : 'S Line',
    \ '\<C-S>' : 'S Block',
    \ 'Rv'     : 'V Replace',
    \ 'no'     : 'Pending',
    \ 'r'      : 'Prompt',
    \ 'rm'     : 'More',
    \ 'r?'     : 'Confirm',
    \ '!'      : 'Shell'
    \}

" statusline
set statusline=
set statusline+=%#StatuslineMode#
set statusline+=\ %{toupper(g:currentmode[mode()])}\ 
set statusline+=%#StatuslineColor#
set statusline+=\ %.20f
set statusline+=\ %m
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %3p%%\ 
set statusline+=%#StatuslineMode#
set statusline+=\ %3l:%-3c

" mappings
"ino " ""<left>
"ino ' ''<left>
"ino ( ()<left>
"ino [ []<left>
"ino { {}<left>
nn <F9> :w<CR>:!%:p<CR>

" plugins
call plug#begin()
Plug 'yggdroot/indentline'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

let g:indentLine_char = '┊'
let g:indentLine_setColors = 0
