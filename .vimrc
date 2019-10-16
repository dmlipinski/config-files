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
map <leader>bn :bnext<cr>
map <leader>bp :bprevious<cr>
map <leader>n :nohlsearch<cr>
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" re-wrap to the end of the current paragraph
map <leader>ww gq}
vmap <leader>ww gq

" Set the timeout for key sequences to 10 seconds
set timeoutlen=10000

" How many commands to remember in history:
set history=10000

" Set to auto read when a file is changed from the outside
set autoread

" Set the colorscheme for dark backgrounds
set background=dark
" colorscheme elflord
colors deus


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

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2
set expandtab

" don't expand tabs for makefiles
autocmd FileType make setlocal noexpandtab

set pastetoggle=<F2> "enter past mode
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
set cindent
set cinoptions+=+2s
set cinoptions+=g1
set cinoptions+=h1

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

function! HasPaste()
        if &paste
            return 'paste'
        else
            return ''
        endif
endfunction

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ %l,%c


" pdflatex compilation:
autocmd FileType tex setlocal makeprg=pdflatex\ '%'
command Bibtex execute "!bibtex $(echo '%'|sed 's/tex/aux/')"

syntax on

let s:extfname = expand("%:e")

" syntax highlighting assumes .inc files are C++ format
autocmd BufNewFile,BufRead *.inc set filetype=cpp
autocmd BufNewFile,BufRead *.cxx set filetype=cpp

"in code, use spaces instead of tabs:
if s:extfname ==? "f90" || s:extfname ==? "f95" || s:extfname ==? "f03" || s:extfname ==? "f08" || s:extfname ==? "cpp" || s:extfname ==? "c" || s:extfname ==? "m" || s:extfname ==? "html" || s:extfname ==? "css" || s:extfname ==? "tex" || s:extfname ==? "cc" || s:extfname ==? "h" || s:extfname ==? "hpp" || s:extfname ==? "cxx" || s:extfname ==? "inc"
  " Use spaces instead of tabs
  set expandtab
  " auto-wrap to 80 characters
	set textwidth=80
	set number
	set formatoptions+=t
  set cc=+1
  " code folding
  set foldmethod=marker
  set foldmarker={,}
  let &foldlevel = max(map(range(1, line('$')), 'foldlevel(v:val)'))
  autocmd BufWinEnter * let &foldlevel = max(map(range(1, line('$')), 'foldlevel(v:val)'))
endif

if s:extfname ==? "f90" || s:extfname ==? "f95" || s:extfname ==? "f03" || s:extfname ==? "f08"
	let fortran_fixed_source=0
	let fortran_free_source=1
	set syntax=text
	set syntax=fortran
	set lbr
	set tw=110

	" The following maps <shift>-F to toggle between fixed and free format Fortran source. In case it is hit by mistake, <ctrl>-F is mapped to re-detect the syntax.
	nmap <S-F> :set syntax=fortran<CR>:let b:fortran_fixed_source=!b:fortran_fixed_source<CR>:set syntax=text<CR>:set syntax=fortran<CR>
	nmap <C-F> :filetype detect<CR>
elseif s:extfname ==? "f" || s:extfname ==? "f77"
	let fortran_fixed_source=1
	unlet! fortran_free_source
endif

"""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins via vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()

" Use release branch
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Or latest tag
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
" Or build from source code by use yarn: https://yarnpkg.com
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

" Denite plugin
Plug 'Shougo/denite.nvim', { 'do' : ':UpdateRemotePlugins' }

" Initialize plugin system
call plug#end()

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" Denite ideas from https://github.com/sodiumjoe/dotfiles/blob/master/vimrc#L242 and elsewhere.
" reset 50% winheight on window resize
augroup deniteresize
  autocmd!
  autocmd VimResized,VimEnter * call denite#custom#option('default',
        \'winheight', winheight(0) / 2)
augroup end

call denite#custom#option('default', {
      \ 'prompt': '❯'
      \ })

call denite#custom#var('file_rec', 'command',
      \ ['rg', '--files', '--glob', '!.git', ''])
call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts',
      \ ['--hidden', '--vimgrep', '--no-heading', '-S'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#map('insert', '<Esc>', '<denite:enter_mode:normal>',
      \'noremap')
call denite#custom#map('normal', '<Esc>', '<NOP>',
      \'noremap')

" ctrl-v and ctrl-h to open files in vertical and horizontal splits
call denite#custom#map('insert', '<C-v>', '<denite:do_action:vsplit>',
      \'noremap')
call denite#custom#map('normal', '<C-v>', '<denite:do_action:vsplit>',
      \'noremap')
call denite#custom#map('insert', '<C-h>', '<denite:do_action:split>',
      \'noremap')
call denite#custom#map('normal', '<C-h>', '<denite:do_action:split>',
      \'noremap')
call denite#custom#map('normal', 'dw', '<denite:delete_word_after_caret>',
      \'noremap')

" ctrl-n and ctrl-p to move down and up the denite menus
call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')

" ctrl-p to find files
nnoremap <C-p> :<C-u>Denite file_rec<CR>

" leader-s to find buffers
nnoremap <leader>s :<C-u>Denite buffer<CR>
nnoremap <leader><leader>s :<C-u>DeniteBufferDir buffer<CR>

" leader-8 to grep for current word
nnoremap <leader>8 :<C-u>DeniteCursorWord grep:. -mode=normal<CR>

" leader-/ to grep
nnoremap <leader>/ :<C-u>Denite grep:. -mode=normal<CR>
nnoremap <leader><leader>/ :<C-u>DeniteBufferDir grep:. -mode=normal<CR>
nnoremap <leader>d :<C-u>DeniteBufferDir file_rec<CR>
nnoremap <leader><leader>r :<C-u>Denite -resume -cursor-pos=+1<CR>

" leader-o to load custom menu
nnoremap <leader>o :<C-u>Denite menu<CR>

hi link deniteMatchedChar Special

" Add custom menus
let s:menus = {}

let s:menus.config_files = {
    \ 'description': 'Edit config files'
    \ }

" quick access to config files
let s:menus.config_files.file_candidates = [
    \ ['.aliases', '~/.aliases'],
    \ ['.zshenv', '~/.zshenv'],
    \ ['.zshrc', '~/.zshrc'],
    \ ['.vimrc', '~/.vimrc'],
    \ ['.i3conf', '~/.config/i3/config'],
    \ ['.i3status.conf', '~/.i3status.conf'],
    \ ['.ctags', '~/.ctags'],
    \ ['global .gitconfig', '~/.gitconfig'],
    \ ['global .gitignore', '~/.gitignore'],
    \ ['.muttrc', '~/.muttrc'],
    \ ['.npmrc', '~/.npmrc'],
    \ ['.mongojsrc.js', '~/.mongojsrc.js'],
    \ ['.psqlrc', '~/.psqlrc'],
    \ ['.pgpass', '~/.pgpass'],
    \ ['.pythonrc', '~/.pythonrc'],
    \ ['.tmux.conf', '~/.tmux.conf'],
    \ ['.tern-config', '~/.tern-config'],
    \ ['.vuerc', '~/.vuerc'],
    \ ['.xinitrc', '~/.xinitrc'],
    \ ['.Xmodmap', '~/.Xmodmap'],
    \ ['.taskbook.json', '~/.taskbook.json'],
    \ ]

" let s:menus.vim = {
"     \ 'description': 'Edit Vim config files'
"     \ }
" let s:menus.vim.file_candidates = [
"     \ ]

" let s:menus.vim.command_candidates = [
"     \ ['Split the window', 'vnew'],
"     \ ['Open zsh menu', 'Denite menu:zsh'],
"     \ ]

call denite#custom#var('menu', 'menus', s:menus)
