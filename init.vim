set mouse=a  " enable mouse
set encoding=utf-8
set number relativenumber
set noswapfile
set scrolloff=7

set expandtab
set autoindent
set fileformat=unix
filetype indent on      " load filetype-specific indent files

inoremap jk <esc>
set cursorline
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz 
set helplang=ru


call plug#begin('~/.vim/plugged')

Plug 'neovim/nvim-lspconfig', { 'tag': 'v0.1.3' }
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'windwp/nvim-autopairs'
Plug 'onsails/lspkind-nvim'

" git
Plug 'tpope/vim-fugitive'

" Autoformatting
Plug 'sbdchd/neoformat'
Plug 'neomake/neomake'
Plug 'tpope/vim-surround'

" Color
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'p00f/nvim-ts-rainbow'

" Bars
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'majutsushi/tagbar'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'kyazdani42/nvim-web-devicons'

" html
Plug 'mattn/emmet-vim'

" MarkDown
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

" Search
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" color schemas
Plug 'morhetz/gruvbox'  " colorscheme gruvbox
Plug 'mhartington/oceanic-next'  " colorscheme OceanicNext
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'ayu-theme/ayu-vim'
Plug 'luisiacc/gruvbox-baby', {'branch': 'main'}

" For JS/JSX
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'

" footer 
Plug 'nvim-lualine/lualine.nvim'

" PYTHON
Plug 'fisadev/vim-isort'
Plug 'mitsuhiko/vim-jinja'

" Sreenshot
Plug 'kristijanhusak/vim-carbon-now-sh'

" Debugger
Plug 'puremourning/vimspector', {
  \ 'do': 'python3 install_gadget.py --enable-vscode-cpptools'
  \ }

call plug#end()

let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-cpptools', 'CodeLLDB' ]

autocmd FileType python,markdown set tabstop=4
autocmd FileType python,markdown set softtabstop=4
autocmd FileType pytho,markdownn set shiftwidth=4
autocmd FileType c,cpp set tabstop=2
autocmd FileType c,cpp set softtabstop=2
autocmd FileType c,cpp set shiftwidth=2

nnoremap ,<space> :nohlsearch<CR>
" StatusLine
lua << END
require('lualine').setup {
    options = {
        -- ... your lualine config,
        theme = "gruvbox-baby",
        -- ... your lualine config,
    }
}
END
autocmd InsertLeave * if &readonly==0 && filereadable(bufname('%')) | silent update | endif

" Screenshot
let g:carbon_now_sh_options =
\ { 'ln': 'true',
  \ 'fm': 'monokai',
  \ 'wt': 'none' }


" Autoformatting
let g:neoformat_enabled_python = ['autopep8', 'yapf']
"let g:neoformat_verbose  =  1
let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_open_list = 2
" html
let g:user_emmet_leader_key='<C-L>'

lua << EOF
--settings url: https://github.com/luisiacc/gruvbox-baby/blob/main/lua/gruvbox-baby/theme.lua
local c = require("gruvbox-baby.colors").config()
config_gruvbox = require("gruvbox-baby.config")
vim.g.gruvbox_baby_highlights = {
    Normal = { bg = "#2b2b2b" },
    SpecialKey = { fg = c.soft_green },
    IndentBlanklineChar = { fg = '#4f5353' },
    IndentBlanklineSpaceChar = { fg = '#4f5353' },
    IndentBlanklineContextChar = { fg = '#365050' },
    tsparameter = { fg = '#69d1fb' },
    TSVariable = { fg = "#ebdbb2" },
    pythonTSVariable = { fg = c.foreground, bg = c.NONE, style = "NONE" },
    CursorLine = { bg = "#494240" },
    Visual = { bg = "#504945" },
}
vim.cmd[[colorscheme gruvbox-baby]]


vim.o.completeopt = 'menuone,noselect'
-- vertical line in code
vim.opt.list = true
vim.opt.listchars:append("space:•")
vim.opt.listchars:append("eol:↴")

require("indent_blankline").setup {
    show_end_of_line = true,
    space_char_blankline = " ",
}



-- luasnip setup
local luasnip = require 'luasnip'

-- tabnine
local tabnine = require('cmp_tabnine.config')
tabnine:setup({
	max_lines = 1000;
	max_num_results = 20;
	sort = true;
	run_on_every_keystroke = true;
	snippet_placeholder = '..';
	ignored_file_types = { -- default is not to ignore
		-- uncomment to ignore in lua:
		-- lua = true
	};
})

-- nvim-cmp setup
local cmp = require 'cmp'
local lspkind = require('lspkind')


local source_mapping = {
	buffer = "[Buffer]",
	nvim_lsp = "[LSP]",
	nvim_lua = "[Lua]",
	cmp_tabnine = "[TN]",
	path = "[Path]",
}

cmp.setup {
  formatting = {
		format = function(entry, vim_item)
			vim_item.kind = lspkind.presets.default[vim_item.kind]
			local menu = source_mapping[entry.source.name]
			if entry.source.name == 'cmp_tabnine' then
				if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
					menu = entry.completion_item.data.detail .. ' ' .. menu
				end
				vim_item.kind = ''
			end
			vim_item.menu = menu
			return vim_item
		end
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }), 
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<tab>'] = function(fallback)
      if cmp.visible() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), '')
      elseif luasnip.expand_or_jumpable(1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
      else
        fallback()
      end
    end,
    ['<S-tab>'] = function(fallback)
      if cmp.visible() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), '')
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
    { name = 'cmp_tabnine' },
    { name = 'path' },
    { name = 'buffer' },
  },
}



require("nvim-autopairs").setup(
    {
        disable_filetype = {"TelescopePrompt", "vim"}
    }
)
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({map_char = {tex = ""}}))

EOF

" Search
nnoremap ff <cmd>Telescope find_files<cr>
nnoremap fg <cmd>Telescope live_grep<cr>
nnoremap fb <cmd>Telescope buffers<cr>
nnoremap fh <cmd>Telescope help_tags<cr>
nnoremap fj :Telescope <cr>

nmap  <F8> :TagbarToggle <CR> 
nnoremap tn :tabnew<CR>:NERDTree<CR>
nnoremap tt :terminal<CR><Insert>
nnoremap tc :tabclose<CR>
" Formatting
map  <F2> :Neoformat <CR> :w <CR> 
map  <F3> :Neomake <CR>
map <F4> :NeomakeClean <CR>
map <lo> :lopen <CR>

map <F6> :LspRestart <CR>

" carbon
map <F7> :CarbonNowSh <CR>

lua << EOF


local nvim_lsp = require('lspconfig')
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
--  buf_set_keymap('n', '<F6>', '<cmd>w<CR><cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR><cmd>edit!<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders)))<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- nvim-treesitter
require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = { "c", "lua", "python" },

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  ignore_install = { "javascript" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    disable = { "rust" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true
  },
}

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'clangd', 'html' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

EOF



" Delete buffer while keeping window layout (don't close buffer's windows).
" Version 2008-11-18 from http://vim.wikia.com/wiki/VimTip165
if v:version < 700 || exists('loaded_bclose') || &cp
  finish
endif
let loaded_bclose = 1
if !exists('bclose_multiple')
  let bclose_multiple = 1
endif

" Display an error message.
function! s:Warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

" Command ':Bclose' executes ':bd' to delete buffer in current window.
" The window will show the alternate buffer (Ctrl-^) if it exists,
" or the previous buffer (:bp), or a blank buffer if no previous.
" Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
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

vnoremap z<SPACE> :<c-u>let temp_variable=@"<CR>gvy:<c-u>let @/='\V<C-R>=escape(@",'/\')<CR>'<CR>:let @"=temp_variable<CR>:<c-u>set hlsearch<CR>
map gn :bn<cr>
map gp :bp<cr>
map gw :Bclose<cr>


autocmd FileType python,c,cpp set colorcolumn=80

autocmd FileType python if !empty(expand(glob("pyproject.toml"))) | map <buffer> <F5> :w<CR>:tabnew %<CR>:terminal poetry run python %<CR><Insert> | endif
autocmd FileType python if !empty(expand(glob("pyproject.toml"))) | imap <buffer> <F5> <esc>:w<CR>:tabnew %<CR>:terminal poetry run python %<CR><Insert> | endif
autocmd FileType python if empty(expand(glob("pyproject.toml"))) | map <buffer> <F5> :w<CR>:tabnew %<CR>:terminal python %<CR><Insert> | endif
autocmd FileType python if empty(expand(glob("pyproject.toml"))) | imap <buffer> <F5> <esc>:w<CR>:tabnew %<CR>:terminal python %<CR><Insert> | endif

autocmd FileType python vmap <buffer> cc :norm i#<CR>
autocmd FileType python vmap <buffer> uc :norm ^x<CR>


autocmd FileType c map <buffer> <F5> :w<CR>:tabnew %<CR>:terminal gcc % -std=c99 -o comp_file -lm -g -O0; ./comp_file<CR><Insert>
autocmd FileType c imap <buffer> <F5> :w<CR>:tabnew %<CR>:terminal gcc % -std=c99 -o comp_file -lm -g -O0; ./comp_file<CR><Insert>

autocmd FileType c vmap <buffer> cc :norm i//<CR>
autocmd FileType c vmap <buffer> uc :norm ^x^x<CR>



autocmd FileType vim vmap <buffer> cc :norm i--<CR>
autocmd FileType vim vmap <buffer> uc :norm ^x^x<CR>

" NERDTree
set autochdir
autocmd  VimEnter * NERDTree 
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Debugger
noremap 1<SPACE> <Plug>VimspectorContinue
noremap 2<SPACE> :VimspectorReset<CR>
noremap 3<SPACE> <Plug>VimspectorToggleBreakpoint
noremap 4<SPACE> <Plug>VimspectorRunToCursor
noremap <F9> <Plug>VimspectorStepOver
noremap <F10> <Plug>VimspectorStepInto
