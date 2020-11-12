"
" General behaviour
"


" Read if updated, write on leave, force utf-8
set autoread
set autowrite
set encoding=utf-8
set clipboard=unnamedplus
set hidden
set shortmess+=c
set showcmd
set nobackup
set nowritebackup
set mouse=a
set wildmenu
filetype plugin on


"
" Appearence
"


" Colorscheme
syntax enable
colorscheme one
set background=dark
let g:one_allow_italics = 1

" Column limit
set cc=80
highlight ColorColumn ctermbg=darkgrey

" highlight search
set hlsearch
set incsearch

" Show relative line numbers and keep current line number
set relativenumber
set number
set signcolumn=yes

" Give more space for displaying messages.
set cmdheight=2

" Status mode
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'Normal·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ "\<C-V>" : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ "\<C-S>" : 'S·Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}

" Set up status bar
set laststatus=2
set noshowmode
set statusline=
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}\  " The current mode
set statusline+=%1*\ %<%F%m%r%h%w\                       " File path, modified, readonly, helpfile, preview
set statusline+=%=                                       " Right Side
set statusline+=%{StatusDiagnostic()}\                       " Show diagnostic errors
set statusline+=%2*\ %y                                  " FileType
set statusline+=%3*│                                     " Separator
set statusline+=%1*\ %l:%c\ %p%%\                        " Pos info
set statusline+=%0*\ %n\                                 " Buffer number

au InsertEnter * hi statusline guifg=black guibg=#d7afff ctermfg=black ctermbg=white
au InsertLeave * hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=blue
hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=blue
hi User1 ctermfg=007 ctermbg=239 guibg=#4e4e4e guifg=#adadad
hi User2 ctermfg=007 ctermbg=236 guibg=#303030 guifg=#adadad
hi User3 ctermfg=236 ctermbg=236 guibg=#303030 guifg=#303030
hi User4 ctermfg=239 ctermbg=239 guibg=#4e4e4e guifg=#4e4e4e
hi PmenuSel ctermfg=black guifg=black
hi SpecialKey ctermfg=darkgrey guifg=darkgrey

" Remove background for transparency
hi NORMAL ctermbg=NONE
hi SignColumn ctermbg=NONE
hi CursorLineNr ctermbg=NONE


"
" Editor behaviour
"


" Indent and tab rules
set shiftwidth=4
set softtabstop=-1
set expandtab
set smarttab
set autoindent

" Show trailing whitspaces
set list listchars=trail:·

" Ignore compatibility with vi
set nocompatible

" Search
set ignorecase smartcase


"
" Mappings
"


" Map leader to space
let mapleader = "\<Space>"

" Save shortcut
nnoremap <c-s> :w<cr>

" Use leader-[np] to change tab
nmap <silent> <leader>n :tabnext<CR>
nmap <silent> <leader>p :tabprev<CR>

" Use leader-[hjkl] to select the active split
nmap <silent> <leader>h :wincmd h<CR>
nmap <silent> <leader>j :wincmd j<CR>
nmap <silent> <leader>k :wincmd k<CR>
nmap <silent> <leader>l :wincmd l<CR>

" Tab and Shift+Tab completion and cycling
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Move between errors/warnings
nmap <silent> <C-k> <Plug>(coc-diagnostic-prev)
nmap <silent> <C-j> <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>

" Auto close pairs and step over them
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
inoremap [ []<left>
inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
inoremap <expr> }  strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"


"
" Netrw setup
"


let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 3
let g:netrw_winsize = 10
let g:netrw_list_hide='\(^\|\s\s\)\zs\.\S\+'
let g:netrw_dirhistmax = 0


"
" Coc nvim diagnostic
"
"


function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, info['error'] . '✖')
  endif
  if get(info, 'warning', 0)
    call add(msgs, info['warning'] . '⚠')
  endif
  return join(msgs, ' '). ' ' . get(g:, 'coc_status', '')
endfunction
