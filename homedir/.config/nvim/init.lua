----------------------------- Utils {{{
local util = { }

local scopes = {o = vim.o, b = vim.bo, w = vim.wo, opt=vim.opt}

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
  use { 'mcchrish/zenbones.nvim', requires = 'rktjmp/lush.nvim' } -- light theme
  -- Improved search highlighting
  use { 'qxxxb/vim-searchhi' }
  -- expandable HTML shortcuts
  use { 'mattn/emmet-vim' }
  -- LSP
  use {
    'neovim/nvim-lspconfig',
  }
  -- Auto complete
  use { 'hrsh7th/nvim-cmp', requires = {'hrsh7th/cmp-nvim-lsp', 'saadparwaiz1/cmp_luasnip', 'L3MON4D3/LuaSnip', 'hrsh7th/cmp-path'} }
  -- Treesitter (fancy parsing of a single file)
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  -- Fuzzy finder
  use { 'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}} }
  -- File Browser
  use { 'kyazdani42/nvim-tree.lua', requires = { 'kyazdani42/nvim-web-devicons' } }
  -- Git decorations
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' }, tag = 'main' }
  -- Status line
  use { 'hoob3rt/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons' } }
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
  -- syntax highlighting for smali
  use { 'kelwin/vim-smali' }
end)
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

-- Folding
util.map('n', 'zt', ':%foldc<CR>za')
-- }}}


----------------------------- Theme Settings {{{
lualine = require('lualine')
function set_theme(mode)
  theme = mode
  vim.o.termguicolors = true
  if mode == 'light'
  then
    vim.g.zenbones_compat = 1
    vim.cmd 'set background=light'
    -- vim.cmd 'colorscheme neobones'
    -- vim.cmd 'colorscheme zenbones'
    vim.cmd 'colorscheme seoulbones'
    lualine.setup {
      options = {
        theme = 'sonokai',
        icons_enabled = true,
      }
    }
  else
    -- vim.cmd 'let g:sonokai_enable_italic = 0'
    -- vim.cmd 'let g:sonokai_disable_italic_comment = 1'
    vim.g.sonokai_style = 'default'
    vim.g.sonokai_better_performance = 1
    vim.g.sonokai_disable_italic_comment=1
    vim.cmd 'colorscheme sonokai'
    lualine.setup {
      options = {
        theme = 'everforest',
        icons_enabled = true,
      }
    }
  end
end

function toggle_theme()
  if theme == 'dark'
  then
    set_theme('light')
  else
    set_theme('dark')
  end
end

theme = 'dark'
set_theme(theme)
vim.keymap.set('n', '<leader>g', toggle_theme)


-- }}}


----------------------------- Editor Settings {{{
-- Indentation
local indent = 2
vim.cmd 'set nowrap'
vim.cmd 'filetype plugin indent on'
util.opt('b', 'expandtab', true)
util.opt('b', 'shiftwidth', indent)
util.opt('b', 'smartindent', true)
util.opt('b', 'tabstop', indent)

-- Whitespace
util.opt('o', 'list', true)
util.opt('o', 'listchars', 'tab:>.,trail:.,extends:#,nbsp:.')
-- set listchars=tab:>.,trail:.,extends:#,nbsp:.


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

-- Folding
util.opt('opt', 'foldmethod', 'expr')
util.opt('opt', 'foldexpr', 'nvim_treesitter#foldexpr()')
vim.cmd 'set nofoldenable'
vim.cmd 'set foldlevel=99'
-- }}}


----------------------------- Filetype Settings {{{
util.autocmd("FileType",            "lua,vim",                    "setlocal foldmethod=marker")
util.autocmd("FileType",            "lua,vim",                    "setlocal foldlevel=0")
util.autocmd("FileType",            "lua,vim",                    "setlocal foldenable")
util.autocmd("FileType",             "yaml",                       "setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0# indentkeys-=<:>")
util.autocmd("BufRead,BufNewFile",  "~/.Xresources.d/*",          "setfiletype xdefaults")
util.autocmd("BufRead,BufNewFile",  "Jenkinsfile,*.jenkinsfile",  "setfiletype groovy")
-- }}}


----------------------------- Plugin Specific Settings {{{

-- {{{ mason

local root_pattern = require('lspconfig.util').root_pattern

-- To appropriately highlight codefences returned from denols
vim.g.markdown_fenced_languages = { "ts=typescript" }

local servers = {
  rust_analyzer = { root_dir = root_pattern("Cargo.toml") },
  pyright       = {},
  -- tsserver      = { root_dir = root_pattern("package.json") },
  denols        = {
                  settings = {
                    enable = true,
                    lint = false,
                    unstable = true,
                  },
                  root_dir = root_pattern("deno.json", "deno.jsonc"),
                },
  -- tailwindcss   = { root_dir = root_pattern("svelte.config.js", "twind.config.ts") },
  svelte        = {},
  yamlls        = {
                  settings = {
                    yaml = {
                      schemaStore = {
                        enable = false
                      }
                    }
                  }
  },
  -- sumneko_lua   = {
  --                 settings = {
  --                   Lua = {
  --                     runtime = { version = 'LuaJIT' },
  --                     -- Get the language server to recognize the `vim` global
  --                     diagnostics = { globals = { 'vim' }},
  --                     -- Make the server aware of Neovim runtime files
  --                     workspace = {
  --                       -- library = api.nvim_get_runtime_file("", true),
  --                       library = {
  --                         [vim.fn.expand('$VIMRUNTIME/lua')] = true,
  --                         [vim.fn.stdpath('config') .. '/lua'] = true,
  --                       },
  --                     },
  --                     -- Do not send telemetry data containing a randomized but unique identifier
  --                     telemetry = { enable = false },
  --                   }
  --                 }
  -- }
}

-- require('mason').setup()
-- require('mason-lspconfig').setup({
--   ensure_installed = servers,
--   automatic_installation = false,
-- })
-- }}}

-- {{{ nvim-lspconfig

-- Add additional capabilities supported by nvim-cmp (sets up autocompletion)
local lspconfig = require('lspconfig')
-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>p', vim.lsp.buf.format, bufopts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
end


for lsp, lsp_settings in pairs(servers) do
  local settings = {
    on_attach = on_attach,
    -- flags = {
    --   debounce_text_changes = 150,
    -- },
    capabilities = capabilities,
  }
  -- merge per-lsp settings
  for k,v in pairs(lsp_settings) do
    settings[k] = v
  end
  lspconfig[lsp].setup(settings)
end

-- lspconfig["denols"].setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
--   root_dir = root_pattern("deno.json", "deno.jsonc"),
--   init_options = {
--     enable = true,
--     unstable = false,
--   }
-- })

-- debugging lsp means setting the following
-- vim.lsp.set_log_level("debug")
-- and calling
-- :LspInfo

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = false,
    signs = false,
    -- update_in_insert =  false,
  }
)
-- }}}

-- {{{ hrsh7th/nvim-cmp
local luasnip = require('luasnip')

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
    -- ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item()),
    -- ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item()),
    ['<Tab>'] = function (fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,

  },
  sources = {
    { name = 'path' },
    { name = 'cmdline' },
    { name = 'nvim_lsp', dup = 0 },
    { name = 'luasnip', dup = 0 },
    -- { name = 'buffer' },
  },
  -- completion = {
  --   -- do not autocomplete willy nilly. We manually trigger it with <Tab>
  --   -- autocomplete = false
  -- },
})
cmp.setup.filetype('yaml', {
  sources = cmp.config.sources {
    { name = 'buffer', keyword_length = 4 },
    { name = 'path' },
  }
})
-- cmp.setup.cmdline('/', {
--   sources = {
--     { name = 'buffer' }
--   }
-- })
-- cmp.setup.cmdline(':', {
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   })
-- })

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
    -- additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = true,
    disable = { "yaml" },
  },
  ensure_installed = {
    "vim",
    "toml",
    "json",
    "json5",
    "yaml",
    "html",
    "css",
    "javascript",
    "svelte",
    "typescript",
    "python",
    "java",
  }
}
-- }}}

-- {{{ telescope.vim
-- vim.cmd ':Telescope find_files hidden=true'
local telescope = require('telescope')

telescope.setup {
  pickers = {
    find_files = {
      hidden = true
    }
  },
  defaults = {
    file_ignore_patterns = {
      "^.git/",
    }
  }
}


util.map('n', '<C-p>', ':Telescope find_files<CR>')
util.map('n', '<C-a>', ':Telescope live_grep<CR>')
util.map('n', '<C-h>', ':Telescope help_tags<CR>')
-- }}}

-- {{{ nvim-tree.lua
-- vim.g.nvim_tree_show_icons = {
-- }
require('nvim-tree').setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
        git = false,
        folder = false,
        file = true,
        folder_arrow = true,
      },
      glyphs = {
        default = ' ',
        symlink = 's',
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "u",
          renamed = "➜",
          untracked = "★",
          deleted = "d",
          ignored = "◌"
        },
        folder = {
          arrow_open = ">",
          arrow_closed = "•",
          default = "d",
          open = "o",
          empty = "e",
          empty_open = "e",
          symlink = "s",
          symlink_open = "so",
        },
      }
    }
  },
  filters = {
    dotfiles = true,
  },

})
util.map('n', '<C-\\>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })


--}}}

-- {{{ gitsigns.nvim
require('gitsigns').setup()
util.map('n', 'gd', ':Gitsigns diffthis<CR><C-w>w')
-- }}}

-- {{{ lualine.nvim
-- }}}

-- {{{ autopairs
require('nvim-autopairs').setup({})
-- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
-- local cmp = require('cmp')
-- cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
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
