" Language:Jot
" Maintainer:tdk
" Last Change:2020 Apr 02

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

let b:undo_ftplugin = "setl et< sts< fo< com< cms< inc<"


" ============== open jot files as foldable outlines ==============
" set viewdir to writable dir on Windows -  by default is in vim program dir
if filewritable(fnamemodify(&viewdir,':h')) != 2
	set viewdir=$HOME/vimfiles/view
	if !isdirectory($HOME."/vimfiles")
		call mkdir($HOME."/vimfiles", "p")
	endif
endif

"Set space to toggle a fold
nnoremap <space> za

" has no effect unless spaces are used as indents: let g:indent_guides_guide_size = 1
let indent_guides_start_level = 2
let indent_guides_soft_pattern = '\t'

set encoding=utf-8
" Remove right sidebars
" set guioptions-=r
" Remove left sidebars
" set guioptions-=L
" ensure new files are opened with all folds open 
execute ":silent! %foldopen!"
silent loadview
" Improve navigation on wrapped lines
" using softwrapped lines 
noremap j gj
noremap k gk

setlocal foldenable
setlocal foldmethod=indent
setlocal breakindent
setlocal showbreak=>> 
" linebreak = with set wrap on this will wrap but only cutting 
" the line on whitespace and not in the middle of a word.
setlocal linebreak

" indent next line to current level
setlocal autoindent
" options to ensure lines start with tabs
setlocal noexpandtab
setlocal copyindent
setlocal preserveindent
setlocal softtabstop=0
" setlocal shiftwidth=4
" setlocal tabstop=4

" puts a nice border with +'s in, and indent level.
" can also use >=2 to get vertical lines showing indent
setlocal foldcolumn=1
" check indent guides plugin loaded first
if exists('g:loaded_indent_guides') 
	setlocal wrap nolist
	IndentGuidesEnable
else
	setlocal listchars=tab:\¦\  " for simple guidelines. may need to use | if ascii only term
	setlocal wrap list
endif


