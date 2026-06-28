" Базовые настройки редактора
set mouse=a  
set encoding=utf-8
set number
set cursorline
set noswapfile
set scrolloff=7

set fileformat=unix
filetype indent on      

" Отступы по умолчанию. Для Python ниже есть отдельная настройка на 4 пробела.
set smartindent
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2
set autoindent

" Новые split-окна открываются снизу и справа
set splitbelow
set splitright

" Быстрый выход из insert mode
inoremap jk <esc>

" Leader key для пользовательских сочетаний
let mapleader = ","

" Плагины vim-plug
call plug#begin('~/.vim/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'ray-x/lsp_signature.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'

" color schemas
Plug 'morhetz/gruvbox'  " colorscheme gruvbox
Plug 'shaunsingh/nord.nvim' " colorscheme nord
Plug 'ayu-theme/ayu-vim' " colorscheme ayu-themes
Plug 'elvessousa/sobrio'
Plug 'webhooked/kanso.nvim'

Plug 'xiyaowong/nvim-transparent'
Plug 'preservim/nerdtree'

" Навигация по дереву файлов NERDTree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-b> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

Plug 'Pocco81/auto-save.nvim'
Plug 'justinmk/vim-sneak'

" Включить поддержку буфера обмена
set clipboard=unnamedplus

vnoremap <C-c> "+y

" JS/JSX/TS
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'maxmellon/vim-jsx-pretty'
" TS from here https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
Plug 'nvim-lua/plenary.nvim'

Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install --frozen-lockfile --production',
  \ 'for': ['javascript', 'typescript', 'typescriptreact', 'javascriptreact', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }

Plug 'bmatcuk/stylelint-lsp'

Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Convenient floating terminal window
" Plug 'voldikss/vim-floaterm'

Plug 'lspcontainers/lspcontainers.nvim'

" Подключение плагина автоматического закрытия скобок
Plug 'm4xshen/autoclose.nvim'

" Плагины для веб разработки
Plug 'mattn/emmet-vim'

call plug#end()

" Подключение дополнительных настроек от Диджитализируй

" Встроенный файловый проводник netrw
let g:netrw_banner = 0 " hide banner above files
let g:netrw_liststyle = 3 " tree instead of plain view
let g:netrw_browse_split = 3 " vertical split window when Enter pressed on file

" Автоформатирование frontend-файлов через prettier после сохранения
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0

" Disable quickfix window for prettier
let g:prettier#quickfix_enabled = 0

" Turn on vim-sneak
let g:sneak#label = 1

" Подключение цветовой схемы
colorscheme kanso

" Автозакрытие HTML тегов
let g:user_emmet_install_global = 0
let g:user_emmet_leader_key='<C-Z>'
let g:user_emmet_mode='i'

" HTML-сниппеты для emmet-vim
let g:user_emmet_settings = {
  \ 'html': {
  \   'snippets': {
  \     'tags': {
  \       'a': '<a href=""></a>',
  \       'img': '<img src="" alt="">',
  \       'input': '<input type="" name="" id="">',
  \       'link': '<link rel="stylesheet" href="">',
  \       'script': '<script src=""></script>',
  \       'meta': '<meta name="" content="">',
  \       'br': '<br>',
  \       'hr': '<hr>',
  \     },
  \   },
  \ },
  \}

augroup user_emmet
  autocmd!
  autocmd FileType html,css EmmetInstall
augroup END

" Настройка autocomplete nvim 
lua << EOF
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
-- Я подключил автоматическую работу autocomplete
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-o>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
      elseif luasnip.expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
      elseif luasnip.jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

local nvim_lsp = require('lspconfig')

-- Общие keymap'ы и настройки для всех LSP-серверов
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }

  -- Keymaps for LSP
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', opts)

  -- LSP Signature (подсказки аргументов функций)
  require "lsp_signature".on_attach({
      bind = true,
      floating_window = true,
      floating_window_above_cur_line = true,
      floating_window_off_x = 20,
      doc_lines = 10,
      hint_prefix = '👻 '
    }, bufnr)
end

-- Настройка автоматического закртытия скобок
require("autoclose").setup()

-- Дополнительные настройки конфига от Диджитализируй 

-- TS setup
local buf_map = function(bufnr, mode, lhs, rhs, opts)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
        silent = true,
    })
end

nvim_lsp.ts_ls.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        local ts_utils = require("nvim-lsp-ts-utils")
        ts_utils.setup({})
        ts_utils.setup_client(client)
        buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
        buf_map(bufnr, "n", "gi", ":TSLspRenameFile<CR>")
        buf_map(bufnr, "n", "go", ":TSLspImportAll<CR>")
        on_attach(client, bufnr)
    end,
})

-- Stylelint format after save
require'lspconfig'.stylelint_lsp.setup{
  settings = {
    stylelintplus = {
      --autoFixOnSave = true,
      --autoFixOnFormat = true,
    }
  }
}

-- Остальные LSP-серверы. Для них сохраняем отключенный hover из старого конфига.
local servers = { 'pyright', 'rust_analyzer', 'html' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = function(client, bufnr)
      client.server_capabilities.hoverProvider = false
      on_attach(client, bufnr)
    end,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF


" Закрытие буфера без разрушения текущей раскладки окон
if v:version >= 700 && !&cp
let loaded_bclose = 1
if !exists('bclose_multiple')
  let bclose_multiple = 1
endif

" Сообщение об ошибке для команды :Bclose
function! s:Warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

" :Bclose закрывает буфер, но оставляет окно открытым.
function! s:Bclose(bang, buffer)
  if empty(a:buffer)
    let btarget = bufnr('%')
  elseif a:buffer =~ '^\d\+$'
    let btarget = bufnr(str2nr(a:buffer))
  else
    let btarget = bufnr(a:buffer)
  endif
  if btarget < 0
    call s:Warn('No matching buffer for '.a:buffer)
    return
  endif
  if empty(a:bang) && getbufvar(btarget, '&modified')
    call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
    return
  endif
  " Numbers of windows that view target buffer which we will delete.
  let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
  if !g:bclose_multiple && len(wnums) > 1
    call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
    return
  endif
  let wcurrent = winnr()
  for w in wnums
    execute w.'wincmd w'
    let prevbuf = bufnr('#')
    if prevbuf > 0 && buflisted(prevbuf) && prevbuf != btarget
      buffer #
    else
      bprevious
    endif
    if btarget == bufnr('%')
      " Numbers of listed buffers which are not the target to be deleted.
      let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
      " Listed, not target, and not displayed.
      let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
      " Take the first buffer, if any (could be more intelligent).
      let bjump = (bhidden + blisted + [-1])[0]
      if bjump > 0
        execute 'buffer '.bjump
      else
        execute 'enew'.a:bang
      endif
    endif
  endfor
  execute 'bdelete'.a:bang.' '.btarget
  execute wcurrent.'wincmd w'
endfunction
command! -bang -complete=buffer -nargs=? Bclose call <SID>Bclose(<q-bang>, <q-args>)
endif

" Навигация по буферам
nnoremap <silent> <Leader>bd :Bclose<CR>

nnoremap gn :bn<cr>
nnoremap gp :bp<cr>
nnoremap gw :Bclose<cr>

" Запуск текущего файла по Ctrl+h для учебных/скриптовых языков
augroup user_run_current_file
  autocmd!
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 colorcolumn=88
  autocmd FileType python nnoremap <buffer> <C-h> :w<CR>:exec '!python3.11' shellescape(@%, 1)<CR>
  autocmd FileType python inoremap <buffer> <C-h> <esc>:w<CR>:exec '!python3.11' shellescape(@%, 1)<CR>
  autocmd FileType c nnoremap <buffer> <C-h> :w<CR>:exec '!gcc' shellescape(@%, 1) '-o out; ./out'<CR>
  autocmd FileType c inoremap <buffer> <C-h> <esc>:w<CR>:exec '!gcc' shellescape(@%, 1) '-o out; ./out'<CR>
  autocmd FileType go nnoremap <buffer> <C-h> :w<CR>:exec '!go run' shellescape(@%, 1)<CR>
  autocmd FileType go inoremap <buffer> <C-h> <esc>:w<CR>:exec '!go run' shellescape(@%, 1)<CR>
  autocmd FileType sh nnoremap <buffer> <C-h> :w<CR>:exec '!bash' shellescape(@%, 1)<CR>
  autocmd FileType sh inoremap <buffer> <C-h> <esc>:w<CR>:exec '!bash' shellescape(@%, 1)<CR>
augroup END

" set relativenumber
" set rnu

let g:transparent_enabled = v:true

tnoremap <Esc> <C-\><C-n>

" Telescope bindings
nnoremap ,f <cmd>Telescope find_files<cr>
nnoremap ,g <cmd>Telescope live_grep<cr>

" Go to next or prev tab by H and L accordingly
nnoremap H gT
nnoremap L gt

" Autosave plugin

lua << EOF
require("auto-save").setup(
    {
    }
)
EOF

" Telescope fzf plugin
lua << EOF
require('telescope').load_extension('fzf')
EOF

" Создание React-компонента, если локальный скрипт существует
if filereadable('/Users/alexeygoloburdin/code/lms/frontend/createcomponent.py')
  command CreateComponent :terminal '/Users/alexeygoloburdin/code/lms/frontend/createcomponent.py'
endif

" White colors for LSP messages in code
set termguicolors
hi DiagnosticError guifg=White
hi DiagnosticWarn  guifg=White
hi DiagnosticInfo  guifg=White
hi DiagnosticHint  guifg=White
