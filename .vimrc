execute pathogen#infect()

function! ResCur()
	if line("'\"") <= line("$")
		normal! g`"
		return 1
	endif
endfunction

augroup resCur
	autocmd!
	autocmd BufWinEnter * call ResCur()
augroup END

syntax on
set number
set splitright
set encoding=utf-8

au VimEnter * NERDTree
au VimEnter * wincmd p
au bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

au BufNewFile,BufReadPost *.c set cindent expandtab sw=3 sts=2 autowrite
au BufNewFile,BufReadPost *.cpp set cindent expandtab sw=2 sts=2 autowrite
au BufNewFile,BufReadPost *.h set cindent expandtab sw=2 sts=2 autowrite
au BufNewFile,BufReadPost *.hpp set cindent expandtab sw=2 sts=2 autowrite
