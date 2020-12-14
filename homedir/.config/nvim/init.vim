"---------------------------- Vim-Plug Package Manager {{{

call plug#begin('~/.config/nvim/plugged')
"Themes {{{
Plug 'junegunn/seoul256.vim'
" Plug 'sickill/vim-monokai'
" Plug 'jnurmine/Zenburn'
" Plug 'Lokaltog/vim-distinguished'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
"}}}
"Syntax improvements {{{
Plug 'chr4/nginx.vim'
"Plug 'sheerun/vim-polyglot'
Plug 'mustache/vim-mustache-handlebars'
Plug 'docker/docker', {'rtp': '/contrib/syntax/vim'}
" Plug 'othree/html5.vim'
" Plug 'elzr/vim-json'
" Plug 'hail2u/vim-css3-syntax'
Plug 'hdima/python-syntax'
Plug 'cespare/vim-toml'
Plug 'leafo/moonscript-vim'
" Plug 'chrisbra/Colorizer'
"Plug 'amadeus/vim-css'
"Plug 'fleischie/vim-styled-components'
"Plug 'pangloss/vim-javascript'
" Plug 'mxw/vim-jsx'
" Plug 'jelera/vim-javascript-syntax', {'for': 'javascript'}
"Plug 'othree/javascript-libraries-syntax.vim', {'for': 'javascript'}
" Plug 'othree/yajs.vim', {'for': 'javascript'}
" Plug 'othree/es.next.syntax.vim', {'for': 'javascript'}
" Plug 'Quramy/vim-js-pretty-template'
" Plug 'leafgarland/typescript-vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'cdata/vim-tagged-template'
Plug 'plasticboy/vim-markdown'
Plug 'vim-latex/vim-latex'
" Plug 'Vimjas/vim-python-pep8-indent'
" Plug 'Epitrochoid/marko-vim-syntax'
Plug 'evanleck/vim-svelte'
Plug 'tjvr/vim-nearley'
"}}}
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/NERDtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'scrooloose/nerdcommenter'
" Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'junegunn/vim-easy-align'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-airline/vim-airline'
" Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'suy/vim-context-commentstring'
Plug 'mattn/emmet-vim'
Plug 'gregsexton/MatchTag', { 'for': 'html' }
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'vimwiki/vimwiki'

Plug 'vim-scripts/SyntaxAttr.vim'
"
" Plug 'editorconfig/editorconfig-vim'
" Plug 'Chiel92/vim-autoformat'

" Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins' }
" Plug 'zchee/deoplete-clang'
" Plug 'carlitux/deoplete-ternjs', {'do': 'npm -g i tern', 'for': 'javascript'}
" " Plug 'wokalski/autocomplete-flow'
" Plug 'zchee/deoplete-jedi'
" " Plug 'padawan-php/deoplete-padawan', { 'do': 'composer install' }
" Plug 'sebastianmarkow/deoplete-rust', { 'do': 'cargo install racer' }
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
" ncm2 completion sources
" Plug 'ncm2/ncm2-tern',  {'do': 'npm install', 'for': 'javascript'}
" Plug 'ncm2/ncm2-path'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fannheyward/coc-deno'



" Plug 'Shougo/denite.nvim'
" Plug 'rust-lang/rust.vim', { 'do': 'rustup component add rustfmt' }
" Plug 'derekwyatt/vim-scala'
" Plug 'ensime/ensime-vim', {'do': ':UpdateRemotePlugins'}
" Plug 'w0rp/ale', { 'for': 'javascript' }
Plug 'mileszs/ack.vim'
Plug 'timakro/vim-searchant'
" Plug 'wakatime/vim-wakatime'
Plug 'lambdalisue/suda.vim'
" Plug 'python-mode/python-mode', { 'branch': 'develop', 'do': 'git submodule update --init --recursive' }
" Plug 'francoiscabrol/ranger.vim'
" Plug 'rbgrouleff/bclose.vim'
Plug 'prettier/vim-prettier', {'do': 'npm i -g prettier prettier-plugin-svelte svelte'}
Plug 'jparise/vim-graphql'
call plug#end()
"}}}


"---------------------------- Theme Settings {{{

set t_Co=256
colorscheme seoul256
" colorscheme onehalflight
" colorscheme xoria256
" colorscheme monokai
" colorscheme zenburn
" colorscheme distinguished
let g:airline_theme='onehalfdark'
"}}}


"---------------------------- Editor Settings {{{

"Line breaks
set nowrap
set textwidth=110
set backspace=indent,eol,start

"Syntax
set number
syntax enable
filetype plugin on
filetype plugin indent on
autocmd Syntax * syntax keyword Todo DROPME containedin=.*Comment

"Indentation
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
set autoindent

"Whitespaces
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.

"Search
set ignorecase
set smartcase

"Screen
set winheight=30 " split sizing
set cmdheight=2 "command line height 2 lines
set confirm
set ttyfast
set diffopt+=vertical
if has('mouse') | set mouse=a | endif

"System
set wildmode=longest:full,full
set nocompatible
set title " set terminal title
set shell=$SHELL
set history=1000 " change history to 1000
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupcopy=yes


"Language
set spelllang=en_us

"set omnifunc=syntaxcomplete#Complete
"}}}


"---------------------------- Mapping Settings {{{

let mapleader = ','

vnoremap p "_dP

"disables 'c' alias
nnoremap s     <nop>
nnoremap <S-s> <nop>
"disables Ex mode
nnoremap Q <nop>

";w same as :w
nnoremap ; :

"writing to read-only files
cnoremap w!! w !sudo tee > /dev/null %

"save with ctrl-s in all modes
noremap  <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>
"exit without saving
nnoremap <s-x> :cq!<CR>

"set paste is for pasting in a computer
vnoremap <C-c> "+y<CR>

"search using visual selection
noremap g/ y/<C-R>"<CR>

"toggle search highlighting
"TODO replace with searchant
" nnoremap <silent> <Space> :set hlsearch! hlsearch?<CR>

" syn keyword   cTodo   contained    TODO FIXME NOTE
syntax keyword Todo    NOTE    contained

"folds
let g:search_in_folds=1
function! ToggleFoldSearch()
  if g:search_in_folds
    set foldopen-=search
    let g:search_in_folds=0
    echo "set foldopen-=search"
  else
    set foldopen+=search
    let g:search_in_folds=1
    echo "set foldopen+=search"
  endif
endfunction
nnoremap f/ :call ToggleFoldSearch()<CR>

"pageup/pagedown now move half a page
nnoremap <PageDown> <C-d>
nnoremap <PageUp>   <C-u>
" faster switching between splits
nnoremap ê <C-W><C-J>
nnoremap ë <C-W><C-K>
nnoremap ì <C-W><C-L>
nnoremap è <C-W><C-H>
inoremap ê <C-O><C-W><C-J>
inoremap ë <C-O><C-W><C-K>
inoremap ì <C-O><C-W><C-L>
inoremap è <C-O><C-W><C-H>
"navigate wrapped text normally
imap <silent> <Down> <C-o>gj
imap <silent> <Up>   <C-o>gk
nmap <silent> <Down> gj
nmap <silent> <Up>   gk
"}}}


"---------------------------- Filetype Specific Settings {{{

"Add missing filetypes
autocmd BufRead,BufNewFile ~/.Xresources.d/*,.Xresources.d/*            setfiletype xdefaults
autocmd BufRead,BufNewFile docker-*.yml                                 setfiletype docker-compose
autocmd BufRead,BufNewFile test-project.txt                             setfiletype Dockerfile
autocmd BufRead,BufNewFile .eslintrc,.tern-project,.babelrc,.prettierrc setfiletype json
autocmd BufRead,BufNewFile *.json                                       setfiletype javascript
autocmd BufRead,BufNewFile *.js.flow                                    setfiletype javascript
autocmd BufRead,BufNewFile build.sbt                                    setfiletype scala
autocmd BufRead,BufNewFile *.template                                   setfiletype mustache
autocmd BufRead,BufNewFile supervisord.conf                             setfiletype dosini
autocmd BufRead,BufNewFile Jenkinsfile                                  setfiletype groovy
autocmd BufRead,BufNewFile template.sql.ts                              setfiletype javascript


"Spellcheck
autocmd FileType           markdown,plaintex,tex,text                   setlocal spell

"Special formatting
autocmd FileType           markdown,yaml,plaintex,tex,text              setlocal wrap linebreak nolist
autocmd FileType           sh,bash,c,cpp                                setlocal textwidth=180
autocmd FileType           javascript                                   setlocal backupcopy=yes
autocmd Filetype           html,xml                                     setlocal listchars-=tab:>.
autocmd FileType           make                                         setlocal noexpandtab
autocmd FileType           python                                       setlocal shiftwidth=4
autocmd FileType           markdown                                     setlocal com=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,b:-
autocmd FileType           vim,conf,typescript                          setlocal foldmethod=marker
autocmd FileType           vimwiki                                      setlocal syntax=markdown
autocmd FileType           *                                            let g:AutoPairsMapSpace=1
autocmd FileType           markdown                                     let g:AutoPairsMapSpace=0
autocmd FileType           xdefaults                                    setlocal commentstring=!\ %s
autocmd FileType           typescript                                   setlocal commentstring=//\ %s
autocmd FileType           nearley                                      setlocal textwidth=0 wrapmargin=0
autocmd FileType           json                                         syntax match Comment +\/\/.\+$+

"}}}


"---------------------------- Plugin Settings {{{


"netrw {{{

let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 25
let g:netrw_wiw = 30
let g:netrw_browse_split = 0

let g:netrw_is_open=0
function! ToggleNetrw()
  if g:netrw_is_open
    let i = bufnr("$")
    while (i >= 1)
        if (getbufvar(i, "&filetype") == "netrw")
            silent exe "bwipeout " . i 
        endif
        let i-=1
    endwhile
    let g:netrw_is_open=0
  else
    let g:netrw_is_open=1
    silent Lexplore
  endif
endfunction
" noremap <C-\> :call ToggleNetrw()<CR>
" }}}

"NERDTree {{{

"close NERDTree after a file is opened
let g:NERDTreeQuitOnOpen=0
let NERDTreeChDirMode=1
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.git$', '\.idea$', '\~$', '__pycache__', '\.egg-info$', '\.eggs$']
autocmd BufRead,BufNewFile $HOME let NERDTreeShowHidden=0
nnoremap <C-\> :NERDTreeToggle<CR>
inoremap <C-\> <C-O>:NERDTreeToggle<CR>
vnoremap <C-\> <C-C>:NERDTreeToggle<CR>

"let g:NERDTreeUseSimpleIndicator = 1

"
"nerdcommenter config
let NERDSpaceDelims=1

"vim-commentary
" let g:context#commentstring#table['javascript.jsx'] = {
      " \ 'jsComment' : '// %s',
      " \ 'jsImport' : '// %s',
      " \ 'jsxStatment' : '// %s',
      " \ 'jsxRegion' : '{/*%s*/}',
" \}
"}}}

"vim-airline {{{

let g:airline_powerline_fonts=2
"let g:airline_left_sep=''
"let g:airline_right_sep=''
"let g:airline_theme='base16'
":AirlineRefresh
"}}}

"vim-easy-align {{{

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
"}}}

"vim-autoformat {{{

"autocmd BufWrite *.html,*.css,*.scss,*.js,*.json,*.sh,*.pl,*.hs,*.c,*.cpp,*.h,*.tex  :Autoformat
noremap <C-S-f> :Autoformat<CR>
inoremap <C-S-f> <C-O>:Autoformat<CR>
"javascript folding
"folding settings
"set foldmethod=indent   "fold based on indent
"set foldnestmax=10      "deepest fold is 10 levels
"set nofoldenable        "dont fold by default
"set foldlevel=1         "this is just what i use
"}}}

"vim-javascript {{{

let g:javascript_plugin_flow=1
"}}}

"vim-json {{{

let g:vim_json_syntax_conceal = 0
"}}}

"ale {{{

let g:ale_linters = {
\  'javascript': ['standard']
\}
" Only run linters on file save
let g:ale_lint_on_text_changed = 'never'
" if you don't want linters to run on opening a file
let g:ale_lint_on_enter = 0
autocmd FileType javascript noremap <C-f> :silent !standard --fix %<CR>
 ":cannot call alelint after because async function ALELint<CR>
" autocmd FileType javascript noremap <C-S-f> :ALELint<CR>
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" }}}

"editorconfig-vim {{{

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
"}}}

"iamcco/markdown-preview.nvim {{{
nmap <leader>mm <Plug>MarkdownPreview
"}}}

"vim-markdown-preview {{{

" let vim_markdown_preview_toggle=3
" let vim_markdown_preview_github=1
"}}}

"vim-markdown {{{
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_override_foldtext=1
let g:vim_markdown_folding_level=2
"}}}

""deoplete {{{

""Debugging
"" call g:deoplete#enable_logging("DEBUG", $HOME. "/deoplete-debug.txt")

""Activate deoplete
"let g:deoplete#enable_at_startup = 1
"" autocmd FileType javascript,c let g:deoplete#enable_at_startup = 1

""Auto complete paths relative to working file
"let g:deoplete#file#enable_buffer_path=1

""Remove doc from top window
"set completeopt-=preview

""Navigate suggestions with tab
"inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
"inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

"" only use autocompletes specific to a language
"call deoplete#custom#option('ignore_sources', {
"  \'_':        ['buffer','around'],
"  \'text':     [],
"  \'markdown': [],
"  \'vimwiki':  [],
"  \'tex':      [],
"  \'vim':      [],
"  \'sh':       [],
"  \})

""Deoplete Plugins
""----------------
""deoplete-ternjs {{{

"let g:deoplete#sources#ternjs#types = 1
"let g:deoplete#sources#ternjs#case_insensitive = 1
"let g:deoplete#sources#ternjs#docs = 1
""}}}

""deoplete-clang {{{

"let g:deoplete#auto_complete_start_length = 1
"let g:deoplete#sources#clang#libclang_path = "/usr/lib/libclang.so"
"let g:deoplete#sources#clang#clang_header = "/usr/lib/clang"
"" }}}

""deoplete-jedi {{{

""}}}
""}}}

"ncm2/ncm2 {{{

" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

" suppress the annoying 'match x of y', 'The only match' and 'Pattern not found' messages
set shortmess+=c

" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new
" line.
" inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

" Use <TAB> to select the popup menu:
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" MOVED: to coc.vim configuration


"}}}

"deoplete-rust {{{
let g:deoplete#sources#rust#racer_binary='/home/andrew/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path='/home/andrew/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu//lib/rustlib/src/rust/src'
"}}}

"ensime-vim {{{

" let ensime_server_v2=1
"}}}

"vimwiki {{{

let vimwiki_list = [{
    \'path': '~/Dropbox/Notes/vimwiki/',
    \ 'syntax': 'markdown',
    \ 'ext': '.md',
    \ 'nested_syntaxes': {
        \'python': 'python',
        \'cpp': 'cpp',
        \'sh': 'sh',
        \'javascript': 'javascript'
    \}
\}]
autocmd BufRead,BufNewFile ~/vwiki/diary/diary.md :VimwikiDiaryGenerateLinks
nnoremap <leader>v <Plug>TaskList
let g:vimwiki_table_mappings = 0
let g:vimwiki_folding='custom'
let g:vimwiki_conceallevel=0
"}}}

"ctrlp.vim {{{

"only show files that are not ignored by git
" slower!!
let g:ctrlp_user_command = ['.gitignore', 'cd %s && ag --ignore-dir=.git --follow --hidden -g .']
let g:ctrlp_root_markers = ['build.sbt', 'package.json', '.projectroot']
let g:ctrlp_working_path_mode = 0

"if exists("g:ctrlp_user_command")
"unlet g:ctrlp_user_command
"endif
"set wildignore+=*/tmp/*,*.so,*.swp,*.zip
"let g:ctrlp_custom_ignore = '\v[\/]\.minecraft$'
"let g:ctrlp_custom_ignore = {
"\ 'dir':  '\v\.(git|hg|svn|minecraft)$',
"\ 'file': '\v\.(exe|so|dll)$',
"\ }
"}}}

"ack.vim {{{

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

"}}}

"vim-prettier {{{

let g:prettier#exec_cmd_path = "~/.npm-packages/bin/prettier"

autocmd FileType python let b:prettier_ft_default_args = {
 \ 'parser': 'python',
 \ }
autocmd FileType php let b:prettier_ft_default_args = {
 \ 'parser': 'php',
 \ }
"}}}

"vim-searchant {{{
" let g:searchant_current = 0
let g:searchant_map_stop=0
function ToggleSearchant()
  let l:search_is_highlighted=&hlsearch
  if search_is_highlighted
    echo "nohlsearch"
    " :call <SID>Stop()
    " :execute "normal \<Plug>SearchantStop"
    :set nohlsearch
  else
    echo "hlsearch"
    set hlsearch
  endif
endfunction
nmap <Space> <Plug>SearchantToggle
" nnoremap <silent> <Space> <Plug>ToggleSearchant
" nnoremap <silent> <Space> :call s:Stop()<CR> :nohlsearch<CR>
" nnoremap <silent> <Space> :set hlsearch! hlsearch?<CR>
"}}}

"vim-latex {{{

" let g:Tex_FoldedEnvironments='tabularx,itemize'
let g:Tex_FoldedMisc='preamble,<<<'
"}}}

"vim-typescript {{{
let g:typescript_indent_disable = 1

"}}}

"nvim-typescript {{{
let g:nvim_typescript#diagnostics_enable = 0
autocmd BufWrite *.ts TSGetDiagnostics
"}}}

"vim-tagged-template {{{
let g:taggedtemplate#tagSyntaxMap = {
  \ "html":    "html",
  \ "md":      "markdown",
  \ "css":     "css",
  \ "graphql": "graphql",
  \ "gql":     "graphql",
  \ "sql":     "sql"}
autocmd FileType javascript,javascript.jsx,typescript : call taggedtemplate#applySyntaxMap()
"}}}

"coc.vim {{{

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" type './' or '../' and the <tab> to get autocompleted paths


" " Always show the signcolumn, otherwise it would shift the text each time
" " diagnostics appear/become resolved.
" if has("patch-8.1.1564")
"   " Recently vim can merge signcolumn and number column into one
"   set signcolumn=number
" else
"   set signcolumn=yes
" endif

"}}}


"}}}
"}}}
