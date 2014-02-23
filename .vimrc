
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","
map <leader>tn :tabnext<cr>
map <leader>tp :tabprevious<cr>
" re-wrap to the end of the current paragraph
map <leader>ww gq}

" Set the timeout for key sequences to 1 second
set timeoutlen=1000

" How many commands to remember in history:
set history=1000

" Set to auto read when a file is changed from the outside
set autoread

" Set the colorscheme for dark backgrounds
set background=dark
colorscheme elflord


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn on the WiLd menu
set wildmenu
" Ignore some files:
set wildignore=*.o,*~

"Always show current position
set ruler

" Highlight search results
set hlsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" for html,css, and tex use 2 spaces for tabs
autocmd FileType html setlocal shiftwidth=2
autocmd FileType css setlocal shiftwidth=2
autocmd FileType tex setlocal shiftwidth=2

" don't expand tabs for makefiles
autocmd FileType make setlocal noexpandtab

set pastetoggle=<F2> "enter past mode
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l


" pdflatex compilation:
autocmd FileType tex setlocal makeprg=pdflatex\ '%'
command Bibtex execute "!bibtex $(echo '%'|sed 's/tex/aux/')"

syntax on

let s:extfname = expand("%:e")

" auto-wrap .tex files to 80 characters
if s:extfname ==? "tex"
	set textwidth=80
endif

"in code, use spaces instead of tabs:
if s:extfname ==? "f90" || s:extfname ==? "f95" || s:extfname ==? "f03" || s:extfname ==? "f08" || s:extfname ==? "cpp" || s:extfname ==? "c" || s:extfname ==? "m" || s:extfname ==? "html" || s:extfname ==? "css" || s:extfname ==? "tex"
    " Use spaces instead of tabs
    set expandtab
endif

if s:extfname ==? "f90" || s:extfname ==? "f95" || s:extfname ==? "f03" || s:extfname ==? "f08"
	let fortran_fixed_source=0
	let fortran_free_source=1
	set syntax=text
	set syntax=fortran
	set number
	set lbr
	set tw=110

	" The following maps <shift>-F to toggle between fixed and free format Fortran source. In case it is hit by mistake, <ctrl>-F is mapped to re-detect the syntax.
	nmap <S-F> :set syntax=fortran<CR>:let b:fortran_fixed_source=!b:fortran_fixed_source<CR>:set syntax=text<CR>:set syntax=fortran<CR>
	nmap <C-F> :filetype detect<CR>
elseif s:extfname ==? "f" || s:extfname ==? "f77"
	let fortran_fixed_source=1
	unlet! fortran_free_source
endif

