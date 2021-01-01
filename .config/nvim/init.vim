augroup numbertoggle
  autocmd!
  autocmd BufEnter,InsertLeave * set relativenumber
  autocmd BufLeave,InsertEnter * set norelativenumber
augroup END
augroup numbertoggle
colorscheme ocean
set number relativenumber
set scrolloff=10
set noshowmode
"set cursorline
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
set statusline=
set statusline+=\ %{toupper(g:currentmode[mode()])}
set statusline+=\ %f
set statusline+=\ %m
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
nnoremap <F9> :w<CR>:!%:p<CR>
