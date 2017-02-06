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

au BufNewFile,BufReadPost *.c set cindent expandtab sw=3 sts=2 autowrite
au BufNewFile,BufReadPost *.cpp set cindent expandtab sw=2 sts=2 autowrite
au BufNewFile,BufReadPost *.h set cindent expandtab sw=2 sts=2 autowrite
au BufNewFile,BufReadPost *.hpp set cindent expandtab sw=2 sts=2 autowrite
