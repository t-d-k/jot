
" save folding state
autocmd BufWinLeave *.jot mkview
autocmd BufNewFile,BufRead *.jot set filetype=jot
" call after read
autocmd BufWinEnter *.jot silent loadview
