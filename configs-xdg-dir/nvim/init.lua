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

local function merge(table1, table2)
  local combined = {}
  for key,val in pairs(table1)
  do
    combined[key]  = val
  end

  for key,val in pairs(table2)
  do
    combined[key]  = val
  end
  return combined
end

function util.t(str)
    -- Adjust boolean arguments as needed
    return vim.api.nvim_replace_termcodes(str, true, true, true)
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
  -- expandable HTML shortcuts
  use { 'mattn/emmet-vim' }
  -- LSP
  use { 'neovim/nvim-lspconfig', run = { 'pnpm i -g pyright typescript typescript-language-server vscode-langservers-extracted @tailwindcss/language-server svelte-language-server', }}
  -- Auto complete
  use { 'hrsh7th/nvim-cmp', requires = {{ 'hrsh7th/cmp-buffer' }, { 'hrsh7th/cmp-nvim-lsp' }, { 'saadparwaiz1/cmp_luasnip' }, { 'L3MON4D3/LuaSnip' }} }
  -- Treesitter (fancy parsing of a single file)
  use { 'nvim-treesitter/nvim-treesitter', requires= {'nvim-treesitter/playground'}, run = ':TSUpdate' }
  -- Fuzzy finder
  use { 'nvim-telescope/telescope.nvim', requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'} }
  -- Git decorations
  use { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim', tag = 'release' }
  -- Status line
  use { 'hoob3rt/lualine.nvim', requires = 'kyazdani42/nvim-web-devicons' }
  -- File tree explorer
  use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons' }
  -- comment stuff out
  use { 'tpope/vim-commentary' }
  -- yank/paste around closures
  use { 'tpope/vim-surround' }
  -- enable repeating supported plugin maps with "."
  use { 'tpope/vim-repeat' }
  -- align text
  use { 'junegunn/vim-easy-align' }
  -- match closure chars in insert mode
  use { 'windwp/nvim-autopairs', requires = { 'hrsh7th/nvim-cmp' } }
end)
-- }}}


----------------------------- Theme Settings {{{
util.opt('o', 'termguicolors', true)
vim.cmd 'let g:sonokai_disable_italic_comment = 1'
vim.cmd 'colorscheme sonokai'
-- }}}


----------------------------- Editor Settings {{{
-- Indentation
local indent = 2
vim.cmd 'set nowrap'
vim.cmd 'filetype plugin indent on'
--util.opt('w', 'nowrap', true)
util.opt('o', 'expandtab', true)
util.opt('o', 'shiftwidth', indent)
util.opt('b', 'shiftwidth', indent)
util.opt('b', 'smartindent', true)
util.opt('o', 'tabstop', indent)
util.opt('b', 'tabstop', indent)

-- Syntax
vim.cmd 'syntax enable'
util.opt('o', 'number', true)
util.autocmd('Syntax', '*', 'syntax keyword Todo DROPME containedin=.*Comment') -- doesnt seem to work

-- Whitespaces
util.opt('o', 'list', true)
util.opt('o', 'listchars', 'tab:>.,trail:.,extends:#,nbsp:.')

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
util.autocmd("FileType",               "lua,vim",   "setlocal foldmethod=marker")
util.autocmd("FileType",               "python",   "setlocal shiftwidth=2")
util.autocmd("BufRead,BufNewFile",     "Jenkinsfile",   "setfiletype groovy")
util.autocmd("BufRead,BufNewFile",     "*.jenkinsfile",   "setfiletype groovy")
-- }}}


----------------------------- Plugin Specific Settings {{{

-- {{{ nvim-lspconfig
-- see more logs when debgging issues:
-- vim.lsp.set_log_level("debug")

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

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
local sumneko_lua = {
  -- note this required installing sumneko_lua (https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone))
  cmd = {'/Users/andrew/Code/scratchwork/lua-language-server/bin/macOS/lua-language-server', '-E', '/Users/andrew/Code/scratchwork/lua-language-server/main.lua'},
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false },
    },

  }
}

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
  pyright = {},
  -- denols = {
  --   init_options = {
  --     enable = true,
  --     lint = false,
  --     unstable = true,
  --   }
  -- },
  -- tsserver = {},
  -- sumneko_lua = sumneko_lua,
  -- rust_analyzer = {},
  -- jsonls = {
  --   commands = {
  --     Format = {
  --       function()
  --         vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
  --       end
  --     }
  --   }
  -- },
  -- tailwindcss = {},
  -- svelte = {},
  -- tsserver = {},
  -- jdtls = {},
}
for lsp_identifier, lsp_options in pairs(servers) do
  local default_options = {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities
  }
  local options = merge(default_options, lsp_options)
  nvim_lsp[lsp_identifier].setup(options)
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- virtual_text = false,
    -- signs = false,
    update_in_insert =  false,
  }
)
util.autocmd("BufEnter",     "*",   ":lua vim.lsp.diagnostic.disable()")
local diagnostics_enabled = false
function toggle_diagnostics()
  if diagnostics_enabled
  then
    vim.lsp.diagnostic.disable()
    diagnostics_enabled = false
    print('lsp diagnostics turned off')
  else
    vim.lsp.diagnostic.enable()
    diagnostics_enabled = true
    print('lsp diagnostics turned on')
  end
end
util.map("n",     "<C-u>",   ":lua toggle_diagnostics()<CR>", { noremap = true, silent  = true })
-- util.map("n",     "<leader>o",   ":lua vim.lsp.diagnostic.disable()<CR>")

-- }}}

-- {{{ L3MON4D3/LuaSnip
require('luasnip')
-- }}}

-- {{{ hrsh7th/nvim-cmp
util.opt('o', 'completeopt', 'menuone,noselect')
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

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
    { name = 'luasnip' },
    -- { name = 'buffer' },
  },
  completion = {
    -- do not autocomplete willy nilly. We manually trigger it with <Tab>
    -- autocomplete = false
  },
})
-- }}}

-- {{{ qxxxb/vim-searchhi
util.map('n', 'n', '<Plug>(searchhi-n)', { noremap = false })
util.map('n', 'N', '<Plug>(searchhi-N)', { noremap = false })
-- util.map('n', '<C-L>')
function _G.toggle_search_highlight()
  print('testing func')
  if vim.g.searchhi_status == 'listen'
  then
    print('toggle on')
    -- util.t'<Plug>(searchhi-clear-all)'
  else
    print('toggle off')
    -- util.t':<C-U>set hlsearch<CR><Plug>(searchhi-update)'
  end
  -- return vim.g.searchhi_status == 'listen' and util.t'<Plug>(searchhi-clear-all)' or util.t':<C-U>set hlsearch<CR><Plug>(searchhi-update)'
end
-- util.map('n', '<Space>', 'v:lua.toggle_search_highlight()', { expr = true, noremap = true })
-- util.map('n', '<C-L>', "g:searchhi_status == 'listen' ? '<Plug>(searchhi-clear-all)' : ':<C-U>set hlsearch<CR><Plug>(searchhi-update)'", { expr = true, noremap = true })
-- nmap <expr> <C-L> g:searchhi_status == 'listen' ? '<Plug>(searchhi-clear-all)' : ':<C-U>set hlsearch<CR><Plug>(searchhi-update)'
-- vmap <expr> <C-L> g:searchhi_status == 'listen' ? '<Plug>(searchhi-v-clear-all)' : ':<C-U>set hlsearch<CR><Plug>(searchhi-v-update)'

util.map('n', '<Space>', '<Plug>(searchhi-clear-all)', { noremap = false })
-- local search_highlight_enabled = false
-- function toggle_search_highlight()
--   if search_highlight_enabled
--   then
--     -- clear all (from a function?)
--     search_highlight_enabled = false
--   else
--     -- show all (from a function?)
--     search_highlight_enabled = true
--   end
-- end
-- util.map('n', '<Space>', 'lua: toggle_search_highlight()<CR>', { noremap = false })
-- util.map('n', '<Space>', "g:searchhi_status == 'listen' ? '<Plug>(searchhi-clear-all)' : '<Plug>(searchhi-n)'")
-- nmap <expr> <C-L> g:searchhi_status == 'listen' ? '<Plug>(searchhi-clear-all)' : '<Plug>(searchhi-n)'


-- }}}

-- {{{ nvim-treesitter
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    disable = {
      -- "markdown"
    },
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = {
    -- "markdown",
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
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }

}
-- }}}

--- {{{ nvim-tree.lua
require'nvim-tree'.setup {}

util.map('n', '<C-\\>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
--}}}

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
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done())

-- require("nvim-autopairs.completion.cmp").setup({
--   map_cr = true, --  map <CR> on insert mode
--   map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
--   auto_select = true, -- automatically select the first item
--   insert = false, -- use insert confirm behavior instead of replace
--   map_char = { -- modifies the function or method delimiter by filetypes
--     all = '(',
--     tex = '{'
--   }
-- })
-- }}}

-- }}}
