----------------------------- Utils {{{
local util = { }

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

function util.opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= 'o' then scopes['o'][key] = value end
end

function util.map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function util.autocmd(event, triggers, operations)
  local cmd = string.format("autocmd %s %s %s", event, triggers, operations)
 vim.cmd(cmd)
end
-- }}}


----------------------------- packer.nvim Package Manager {{{
-- Auto install packer.nvim if not exists {{{
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim '..install_path) end
-- }}}
require('packer').startup(function(use)
  -- Packer can manage itself
  use { 'wbthomason/packer.nvim' }
  -- Themes
  use { 'sainnhe/sonokai' }
  -- Improved search highlighting
  use { 'qxxxb/vim-searchhi' }
  -- LSP
  use { 'neovim/nvim-lspconfig', run = { 'pnpm i -g pyright typescript typescript-language-server', }}
  -- Auto complete
  use { 'hrsh7th/nvim-cmp', requires = {{ 'hrsh7th/cmp-buffer' }, { 'hrsh7th/cmp-nvim-lsp' }} }
  -- Treesitter (fancy parsing of a single file)
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  -- Fuzzy finder
  use { 'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}} }
  -- Git decorations
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' }, tag = 'release' }
  -- Status line
  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons' }
  }
  -- comment stuff out
  use { 'tpope/vim-commentary' }
  -- yank/paste around closures
  use { 'tpope/vim-surround' }
  -- enable repeating supported plugin maps with "."
  use { 'tpope/vim-repeat' }
  -- align text
  use { 'junegunn/vim-easy-align' }
  -- match closure chars in insert mode
  use { 'windwp/nvim-autopairs' }
end)
-- }}}


----------------------------- Theme Settings {{{
util.opt('o', 'termguicolors', true)
vim.cmd 'colorscheme sonokai'
-- }}}


----------------------------- Editor Settings {{{
-- Indentation
local indent = 2
vim.cmd 'set nowrap'
vim.cmd 'filetype plugin indent on'
--util.opt('w', 'nowrap', true)
util.opt('b', 'expandtab', true)
util.opt('b', 'shiftwidth', indent)
util.opt('b', 'smartindent', true)
util.opt('b', 'tabstop', indent)

-- Syntax
vim.cmd 'syntax enable'
util.opt('o', 'number', true)
util.autocmd('Syntax', '*', 'syntax keyword Todo DROPME containedin=.*Comment') -- doesnt seem to work


-- Screen
util.opt('o', 'cmdheight', 2)
util.opt('o', 'confirm', true)
util.opt('o', 'ttyfast', true)
util.opt('o', 'mouse', 'a')

-- Search
util.opt('o', 'ignorecase', true)
util.opt('o', 'smartcase', true)
-- }}}


----------------------------- Mapping Settings {{{
-- Map leader to space
vim.g.mapleader = ','

-- ;w same as :w
util.map('n', ';', ':')

-- set paste is for paasting in a computer
util.map('v', '<C-c>', '"+y<CR>')

-- save with ctrl-s in all modes
util.map('n', '<C-S>', ':update<CR>', { noremap = true, silent = true })
util.map('v', '<C-S>', '<C-C>:update<CR>', { noremap = true, silent = true })
util.map('i', '<C-S>', '<C-O>:update<CR>', { noremap = true, silent = true })


-- Language
util.opt('o', 'spelllang', 'en_us')
-- }}}


----------------------------- Filetype Settings {{{
util.autocmd("FileType",     "lua,vim",   "setlocal foldmethod=marker")
-- }}}


----------------------------- Plugin Specific Settings {{{

-- {{{ nvim-lspconfig
local nvim_lsp = require('lspconfig')

-- Add additional capabilities supported by nvim-cmp (sets up autocompletion)
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function(client, bufnr)
  local function set_map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function set_opt(...) vim.api.nvim_buf_set_option(bufnr, ...) end


  -- Mappings.
  local opts = { noremap=true, silent=true }
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  set_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)


end


-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
  'pyright',
   -- TODO add deno
  'tsserver',
  'java_language_server',
}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = false,
    update_in_insert =  false,
  }
)
-- }}}

-- {{{ hrsh7th/nvim-cmp
util.opt('o', 'completeopt', 'menuone,noselect')
local cmp = require('cmp')
cmp.setup({
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    -- if autocomplete hasnt triggered yet, trigger it. Else, go to next suggestion
    ['<S-Space>'] = cmp.mapping(cmp.mapping.complete()),
    --['<Tab>'] = function(fallback)
    --  if cmp.visible() then
    --    cmp.select_next_item()
    --  else
    --    --fallback()
    --    cmp.complete()
    --  end
    --end,
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item()),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item()),

  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  },
  completion = {
    -- do not autocomplete willy nilly. We manually trigger it with <Tab>
    autocomplete = false
  },
})
-- }}}

-- {{{ qxxxb/vim-searchhi
util.map('n', 'n', '<Plug>(searchhi-n)', { noremap = false })
util.map('n', 'N', '<Plug>(searchhi-N)', { noremap = false })
util.map('n', '<Space>', '<Plug>(searchhi-clear-all)', { noremap = false })
-- }}}

-- {{{ nvim-treesitter
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  ensure_installed = {
    "vim",
    "toml",
    "json",
    "json5",
    "yaml",
    "html",
    "css",
    -- "javascript",
    "svelte",
    "typescript",
    "python",
    "java",
  }
}
-- }}}

-- {{{ telescope.vim
util.map('n', '<C-p>', ':Telescope find_files<CR>')
util.map('n', '<C-a>', ':Telescope live_grep<CR>')
util.map('n', '<C-h>', ':Telescope help_tags<CR>')
-- }}}

-- {{{ gitsigns.nvim
require('gitsigns').setup()
util.map('n', 'gd', ':Gitsigns diffthis<CR><C-w>w')
-- }}}

-- {{{ lualine.nvim
require('lualine').setup {
  options = {
    theme = 'everforest',
    icons_enabled = true,
  }
}
-- }}}

-- {{{ autopairs
require('nvim-autopairs').setup({})
require("nvim-autopairs.completion.cmp").setup({
  map_cr = true, --  map <CR> on insert mode
  map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
  auto_select = true, -- automatically select the first item
  insert = false, -- use insert confirm behavior instead of replace
  map_char = { -- modifies the function or method delimiter by filetypes
    all = '(',
    tex = '{'
  }
})
-- }}}

-- }}}
