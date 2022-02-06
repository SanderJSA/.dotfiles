"
" Plug install
"


call plug#begin()
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'L3MON4D3/LuaSnip'
Plug 'tpope/vim-fugitive'
Plug 'rakr/vim-one'
"Plug 'vlime/vlime', {'rtp': 'vim/'}
call plug#end()


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
set noswapfile
set mouse=a
set wildmenu
set updatetime=300
filetype plugin on
let g:is_chicken = 1
au BufNewFile,BufRead *.sld setl filetype=scheme


"
" Appearence
"


" Colorscheme
syntax enable
set background=dark
let g:one_allow_italics = 1
colorscheme one

" Column limit
set cc=100
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
set statusline+=%2*\ %{FugitiveStatusline()}\            " Git status
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
hi Pmenu ctermfg=darkgrey guifg=darkgrey

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

" Replace grep with ripgrep
set grepprg=rg\ --vimgrep\ --smart-case\ --follow


"
" Mappings
"


" Map leader to space
let mapleader = "\<Space>"

" Save and exit shortcut
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>

" Use leader-[np] to change tab
nmap <silent> <leader>n :tabnext<CR>
nmap <silent> <leader>p :tabprev<CR>

" Use leader-[hjkl] to select the active split
nmap <silent> <leader>h :wincmd h<CR>
nmap <silent> <leader>j :wincmd j<CR>
nmap <silent> <leader>k :wincmd k<CR>
nmap <silent> <leader>l :wincmd l<CR>
nmap <silent> <leader>s <C-w>r

" File exploring 
nmap <silent> <leader>f :FZF<CR>
nmap <leader>dd :Lexplore %:p:h<CR>
nmap <Leader>da :Lexplore<CR>
nmap <leader>tf :!touch 

" Auto close pairs and step over them
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
inoremap <expr> }  strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"

" Open git status
nnoremap <leader>gs :G<cr>

" Clear search
nnoremap <silent> <esc><esc> :noh<return>


"
" Netrw setup
"


let g:netrw_keepdir = 0
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 3
let g:netrw_winsize = 30
let g:netrw_list_hide='\(^\|\s\s\)\zs\.\S\+,.*\.o$,.*\.d$'
let g:netrw_dirhistmax = 0


"
" LSP config
"


lua << EOF
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  local opts = { noremap=true, silent=true }

  -- Show documentation
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)

  -- LSP navigation
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

  -- Diagnostic actions 
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local servers = { "pyright", "clangd" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

require('lspconfig').rust_analyzer.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = { 
      checkOnSave = {
        command = "clippy",
        extraArgs={"--target-dir", "/tmp/rust-analyzer-check"}
      },
      assist = {
        importGranularity = "module",
        importPrefix = "by_self",
      },
      cargo = {
        loadOutDirsFromCheck = true
      },
      procMacro = {
        enable = true
      },
    }
  }
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false;
    update_in_insert = false,
  }
)

vim.fn.sign_define('LspDiagnosticsSignError', { text = "✖", texthl = "LspDiagnosticsDefaultError" })
vim.fn.sign_define('LspDiagnosticsSignWarning', { text = "⚠", texthl = "LspDiagnosticsDefaultWarning" })
vim.fn.sign_define('LspDiagnosticsSignHint', { text = "⚠" })

EOF
autocmd CursorHold * lua vim.diagnostic.open_float(0, {scope="line", focus=false})
autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()

highlight LspDiagnosticsDefaultError guifg=Red, ctermfg=Red
highlight LspDiagnosticsDefaultHint guifg=#FFCC00 ctermfg=Yellow
highlight LspDiagnosticsDefaultWarning guifg=#FFCC00 ctermfg=Yellow


function! StatusDiagnostic() abort
  let sl = ''
  if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    let sl .= luaeval("#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })") . '✖ '
    let sl .= luaeval("#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }) + #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })") . '⚠'
  endif
  return sl
endfunction

autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()


"
" Completion
"


set completeopt=menuone,noselect
lua << EOF
-- Compe setup
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  documentation = true;

  source = {
    nvim_lsp = true,
    luasnip = true,
    buffer = true,
    path = true,
    calc = true,
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
local luasnip = require 'luasnip'

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-n>'
  --elseif luasnip.expand_or_jumpable() then
  --  return t '<Plug>luasnip-expand-or-jump'
  elseif check_back_space() then
    return t '<Tab>'
  else
    return vim.fn['compe#complete']()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-p>'
  --elseif luasnip.jumpable(-1) then
  --  return t '<Plug>luasnip-jump-prev'
  else
    return t '<S-Tab>'
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

vim.api.nvim_set_keymap('i', '<cr>', 'compe#confirm({ "keys": "<cr>" })', { expr = true })
vim.api.nvim_set_keymap('i', '<c-space>', 'compe#complete()', { expr = true })
EOF
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })


"
" Treesitter config
"

lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "rust", "python", "c", "cpp", "bash" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
EOF
