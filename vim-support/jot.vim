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
	" Improve navigation on wrapped lines
	" using softwrapped lines 
	noremap j gj
	noremap k gk

	setlocal foldenable
	"setlocal foldmethod=indent
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

" ==================== fold at headings not just indented lines for neatness
	" most functions below taken from the vim outliner plugin
		
	setlocal foldexpr=JotFoldLevel(v:lnum)
	setlocal foldmethod=expr
	" loadview must happen after foldmethod set or tries to find folds with defaults 
	" this generates 'no fold found' errors. why?
	silent! loadview

	" Ind(line) 
		" Determine the indent level of a line.
		" Courtesy of Gabriel Horner
		function! Ind(line)
			return indent(a:line)/&tabstop
		endfunction

	" IsParent(line) 
		" Return 1 if this line is a parent
		function! IsParent(line)
			return Ind(a:line) < Ind(a:line+1)
		endfunction
	
	" IsEndIndent(line) 
		" Return 1 if this line has a line below it at a lower indent
		function! IsEndIndent(line)
			return Ind(a:line) > Ind(a:line+1)
		endfunction

	" MyFoldLevel(line)
		function! JotFoldLevel(line)
			if IsParent(a:line)
				return ">" . (Ind(a:line)+1)
			else
				" no need to mark ends and creates probs
				" if IsEndIndent(a:line)
					"return "<" . Ind(a:line)
				"else
					return Ind(a:line)
		endfunction

	
" vim600: set foldmethod=indent foldlevel=10:
