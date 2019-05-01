"---------------------------- Vim-Plug Package Manager {{{

call plug#begin('~/.vim/plugged')
"Themes {{{
Plug 'junegunn/seoul256.vim'
" Plug 'sickill/vim-monokai'
"Plug 'jnurmine/Zenburn'
"Plug 'Lokaltog/vim-distinguished'
"}}}
"Syntax improvements {{{
Plug 'chr4/nginx.vim'
"Plug 'sheerun/vim-polyglot'
Plug 'mustache/vim-mustache-handlebars'
Plug 'docker/docker', {'rtp': '/contrib/syntax/vim'}
Plug 'othree/html5.vim'
Plug 'elzr/vim-json'
Plug 'hail2u/vim-css3-syntax'
" Plug 'hdima/python-syntax'
Plug 'cespare/vim-toml'
Plug 'leafo/moonscript-vim'
"Plug 'amadeus/vim-css'
" Plug 'fleischie/vim-styled-components'
" Plug 'pangloss/vim-javascript'
" Plug 'mxw/vim-jsx'
" Plug 'jelera/vim-javascript-syntax'
" Plug 'othree/javascript-libraries-syntax.vim', {'for': 'javascript'}
Plug 'othree/yajs.vim'
" Plug 'othree/es.next.syntax.vim'
" Plug 'Quramy/vim-js-pretty-template' DROPME
" Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
Plug 'HerringtonDarkholme/yats.vim'
Plug 'plasticboy/vim-markdown'
Plug 'ap/vim-css-color'
Plug 'vim-scripts/phpfolding.vim', { 'for': 'php' }
" Plug 'Vimjas/vim-python-pep8-indent'
Plug 'jparise/vim-graphql'
Plug 'kchmck/vim-coffee-script'
"}}}
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-commentary'
Plug 'scrooloose/NERDtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-vinegar'
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
Plug 'gregsexton/MatchTag'
Plug 'suan/vim-instant-markdown', {'do': 'npm -g i instant-markdown-d'}
Plug 'vimwiki/vimwiki'
Plug 'vim-scripts/SyntaxAttr.vim'
" Plug 'editorconfig/editorconfig-vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
" Plug 'leafgarland/typescript-vim'
Plug 'Chiel92/vim-autoformat', {'do': 'npm -g i js-beautify'}
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-clang'
Plug 'carlitux/deoplete-ternjs', {'do': 'npm -g i tern'}
" Plug 'wokalski/autocomplete-flow'
Plug 'zchee/deoplete-jedi'
" Plug 'padawan-php/deoplete-padawan', { 'do': 'composer install' }
Plug 'derekwyatt/vim-scala'
" Plug 'ensime/ensime-vim', {'do': ':UpdateRemotePlugins'}
Plug 'sonph/onehalf', {'rtp': 'vim/'}
" Plug 'w0rp/ale', { 'for': 'javascript' }
Plug 'mileszs/ack.vim'
Plug 'timakro/vim-searchant'
Plug 'wakatime/vim-wakatime'
" Plug 'python-mode/python-mode', { 'branch': 'develop', 'do': 'git submodule update --init --recursive' }
" Plug 'francoiscabrol/ranger.vim'
" Plug 'rbgrouleff/bclose.vim'
Plug 'prettier/vim-prettier', {'do': 'npm install'}
call plug#end()
"}}}


"---------------------------- Theme Settings {{{

set t_Co=256
colorscheme seoul256
"colorscheme onehalflight
"colorscheme xoria256
"colorscheme monokai
"colorscheme zenburn
"colorscheme distinguished
"let g:airline_theme='onehalfdark'
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

"Language
set spelllang=en_us

"set omnifunc=syntaxcomplete#Complete
"}}}


"---------------------------- Mapping Settings {{{

let mapleader = ','

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
" nnoremap <silent> <Space> :set hlsearch! hlsearch?<CR>

"folds
" set foldenable
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
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>
inoremap <C-j> <C-O><C-W><C-J>
inoremap <C-k> <C-O><C-W><C-K>
inoremap <C-l> <C-O><C-W><C-L>
inoremap <C-h> <C-O><C-W><C-H>
"navigate wrapped text normally
imap <silent> <Down> <C-o>gj
imap <silent> <Up>   <C-o>gk
nmap <silent> <Down> gj
nmap <silent> <Up>   gk

noremap <S-j> vaw
"}}}


"---------------------------- Filetype Settings {{{

"Add missing filetypes
autocmd BufRead,BufNewFile ~/.Xresources.d/*                            setfiletype xdefaults
autocmd BufRead,BufNewFile docker-*.yml                                 setfiletype docker-compose
autocmd BufRead,BufNewFile test-project.txt                             setfiletype Dockerfile
autocmd BufRead,BufNewFile .eslintrc,.tern-project,.babelrc,.prettierrc setfiletype json
autocmd BufRead,BufNewFile *.js.flow                                    setfiletype javascript
autocmd BufRead,BufNewFile build.sbt                                    setfiletype scala
autocmd BufRead,BufNewFile *.template                                   setfiletype mustache
autocmd BufRead,BufNewFile supervisord.conf                             setfiletype dosini
autocmd BufRead,BufNewFile Jenkinsfile                                  setfiletype groovy

"Spellcheck
autocmd FileType           markdown,plaintex,tex,text                   setlocal spell

"Special formatting
autocmd FileType           markdown,yaml,plaintex,tex,text              setlocal wrap linebreak nolist
autocmd FileType           sh,bash,c,cpp                                setlocal textwidth=180
autocmd FileType           javascript                                   setlocal backupcopy=yes
autocmd Filetype           html,xml                                     setlocal listchars-=tab:>.
autocmd FileType           make                                         setlocal noexpandtab
autocmd FileType           python                                       setlocal shiftwidth=2
autocmd FileType           markdown                                     setlocal com=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,b:-
autocmd FileType           vim                                          setlocal foldmethod=marker
autocmd FileType           vimwiki                                      setlocal syntax=markdown
autocmd FileType           *                                            let g:AutoPairsMapSpace=1
autocmd FileType           markdown                                     let g:AutoPairsMapSpace=0
autocmd Filetype           php                                          :EnableFastPHPFolds

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
nmap <silent> <C-Right> <Plug>(ale_previous_wrap)
nmap <silent> <C-Left> <Plug>(ale_next_wrap)
" }}}

"editorconfig-vim {{{

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
"}}}

"vim-markdown-preview {{{

let vim_markdown_preview_toggle=3
let vim_markdown_preview_github=1
"}}}

"vim-markdown {{{
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_override_foldtext=1
let g:vim_markdown_folding_level=2
"}}}

"deoplete {{{

"Debugging
" call g:deoplete#enable_logging('DEBUG', $HOME. '/deoplete-debug.txt')

"Activate deoplete
let g:deoplete#enable_at_startup = 1
" autocmd FileType javascript,c let g:deoplete#enable_at_startup = 1

"Auto complete paths relative to working file
let g:deoplete#file#enable_buffer_path=1

"Remove doc from top window
set completeopt-=preview

"Navigate suggestions with tab
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

" only use autocompletes specific to a language
call deoplete#custom#option('ignore_sources', {
  \'_':        ['buffer','around'],
  \'text':     [],
  \'markdown': [],
  \'vimwiki':  [],
  \'tex':      [],
  \'vim':      [],
  \})

"Deoplete Plugins
"----------------
"deoplete-ternjs {{{

let g:deoplete#sources#ternjs#types = 1
let g:deoplete#sources#ternjs#case_insensitive = 1
let g:deoplete#sources#ternjs#docs = 1
"}}}

"deoplete-clang {{{

let g:deoplete#auto_complete_start_length = 1
let g:deoplete#sources#clang#libclang_path = "/usr/lib/libclang.so"
let g:deoplete#sources#clang#clang_header = "/usr/lib/clang"
" }}}

"deoplete-jedi {{{

let g:python3_host_prog = '/usr/local/bin/python3'
"}}}
"}}}

"nvim-typescript {{{
let g:nvim_typescript#diagnostics_enable = 0
autocmd BufRead,BufWrite *.ts TSGetDiagnostics
"}}}

"ensime-vim {{{

" let ensime_server_v2=1
"}}}

"vim-instant-markdown {{{

let g:instant_markdown_autostart = 0
noremap <leader>mm :InstantMarkdownPreview<CR>
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

autocmd FileType python let b:prettier_ft_default_args = {
 \ 'parser': 'python',
 \ }
autocmd FileType php let b:prettier_ft_default_args = {
 \ 'parser': 'php',
 \ }
"}}}

"vim-js-pretty-template {{{

" call jspretmpl#register_tag('sql', 'sql')
" call jspretmpl#register_tag('gql', 'graphql')
"}}}

"vim-searchant {{{
" let g:searchant_current = 0
let g:searchant_map_stop=0
function ToggleSearchant()
  let l:search_is_highlighted=&hlsearch
  if search_is_highlighted
    echo "nohlsearch"
    set nohlsearch
    :execute "normal \<Plug>SearchantStop"
  else
    echo "hlsearch"
    set hlsearch
  endif
endfunction
nnoremap <silent> <Space> :call ToggleSearchant()<CR>
" nnoremap <silent> <Space> :set hlsearch! hlsearch?<CR>
"}}}

"}}}
