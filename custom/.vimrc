set relativenumber    " relative line numbering

set ruler
set autoindent        " auto indent next line based on previous line
set expandtab         " insert spaces instead of tabs
set foldmethod=indent " folding type
set nowrap            " do not wrap lines
set shiftwidth=2      " indent/outdent width
set softtabstop=2     " spaces to insert when tab

set laststatus=2      " show status line

" identify when line length slops over (soft) limit - from Damian Conway
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)

" shady characters - from Damian Conway
exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
set list

" source: http://vim.wikia.com/wiki/Make_views_automatic
" create a view to save folds into
autocmd BufWinLeave *.* mkview
" reload previously saved folds
autocmd BufWinEnter *.* silent loadview

" syntax highlighting on
syntax on
" syntax highlighting theme
color pablo

" highlight dynamically as term is typed
set incsearch

" custom Josh coloring because silly
highlight Constant ctermfg=7
highlight Folded ctermbg=0 ctermfg=15
highlight Special ctermfg=7
highlight Statement ctermfg=7
highlight Statusline ctermbg=8 ctermfg=15

highlight SpecialKey ctermfg=8
