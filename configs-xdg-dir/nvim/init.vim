"------------------------------------------------------------
"Vim-Plug Package Manager
call plug#begin('~/.vim/plugged')
Plug 'junegunn/seoul256.vim'
"Plug 'sickill/vim-monokai'
"Plug 'jnurmine/Zenburn'
"Plug 'Lokaltog/vim-distinguished'
Plug 'ctrlpvim/ctrlp.vim'
"Plug 'rking/ag.vim'
Plug 'scrooloose/NERDtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-vinegar'
"Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-airline/vim-airline'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'chr4/nginx.vim'
"Plug 'scrooloose/syntastic'
"Plug 'bigfish/vim-js-context-coloring'
"Plug 'sheerun/vim-polyglot'
Plug 'mustache/vim-mustache-handlebars'
Plug 'ekalinin/Dockerfile.vim'
Plug 'othree/html5.vim'
Plug 'mxw/vim-jsx'
Plug 'elzr/vim-json'
Plug 'flowtype/vim-flow', {'for': 'javascript'}
"Plug 'thiderman/vim-supervisord'
"Plug 'stephenway/postcss.vim'
"Plug 'cakebaker/scss-syntax.vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'hdima/python-syntax'
Plug 'leafo/moonscript-vim'
"Plug 'amadeus/vim-css'
"Plug 'fleischie/vim-styled-components'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'pangloss/vim-javascript'
"Plug 'jelera/vim-javascript-syntax', {'for': 'javascript'}
"Plug 'othree/javascript-libraries-syntax.vim', {'for': 'javascript'}
"Plug 'moll/vim-node', { 'for': 'javascript' }
"Plug 'guileen/vim-node-dict'
"Plug 'othree/yajs.vim', {'for': 'javascript'}
"Plug 'maksimr/vim-jsbeautify', {'for': 'javascript'}
"Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
" Plug 'ternjs/tern_for_vim', {'do': 'yarn install'}
"Plug 'Valloric/YouCompleteMe', {'do': './install.py --tern-completer', 'for': ['javascript', 'html', 'css', 'c++']}
"autocmd! User YouCompleteMe if !has('vim_starting') | call youcompleteme#Enable() | endif
"Plug 'ramitos/jsctags',{'do': 'npm install'}
Plug 'mattn/emmet-vim'
Plug 'gregsexton/MatchTag'
"Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'tpope/vim-markdown'
Plug 'suan/vim-instant-markdown', {'do': 'yarn global add instant-markdown-d'}
Plug 'vimwiki/vimwiki'
"nnoremap <leader>v <Plug>TaskList
Plug 'junegunn/vim-easy-align'
"Plug 'wavded/vim-stylus', { 'for': ['stylus', 'markdown'] }
Plug 'tpope/vim-repeat'
Plug 'vim-scripts/SyntaxAttr.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'Chiel92/vim-autoformat', {'do': 'yarn global add js-beautify'}
"Plug 'wesQ3/vim-windowswap' "Swap your windows without ruining your layout
"Plug 'majutsushi/tagbar'
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins' }

"Plug 'wokalski/autocomplete-flow'
" For func argument completion
"Plug 'Shougo/neosnippet'
"Plug 'Shougo/neosnippet-snippets'

Plug 'zchee/deoplete-clang'
Plug 'carlitux/deoplete-ternjs', {'do': 'yarn global add tern'}
Plug 'zchee/deoplete-jedi'
Plug 'derekwyatt/vim-scala'
Plug 'ensime/ensime-vim', {'do': ':UpdateRemotePlugins'}
"Plug 'neomake/neomake', {'do': 'yarn global add eslint_d eslint babel-eslint eslint-plugin-flowtype'}
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'w0rp/ale', { 'for': 'javascript' }
Plug 'mileszs/ack.vim'
Plug 'timakro/vim-searchant'
Plug 'wakatime/vim-wakatime'
Plug 'Vimjas/vim-python-pep8-indent'
call plug#end()

"------------------------------------------------------------
"Theme Settings

set t_Co=256
colorscheme seoul256
"colorscheme onehalflight
"let g:airline_theme='onehalfdark'
"colorscheme xoria256
"colorscheme monokai
"colors zenburn
"colorscheme distinguished

"-----------------------------------------------------------
"Editor Settings
set nocompatible
set number
set nowrap
"set scrolloff=3
set ignorecase
set smartcase
set backspace=indent,eol,start
set nostartofline
set autoindent
set wildmenu
set showcmd
set wildmode=list:longest
set shell=$SHELL
set title " set terminal title
"set regexpengine=1
":syntax enable

"set encoding=utf8

"set term=ansi
syntax on
" highlight searchs
"set hlsearch
"set incsearch
" always display status
set laststatus=2
" asks to save unsaved changes
set confirm
" can select text with mouse
if has('mouse')
    set mouse=a
endif
if has('mouse_sgr')
  set ttymouse=sgr
endif

"" command line height 2 lines
set cmdheight=2
" indentation settings
set shiftwidth=2
set tabstop=2
" see who edited a command last:
" :verbose set tabstop?
set softtabstop=2
set expandtab
"autocmd BufRead,BufNewFile makefile setlocal noexpandtab
autocmd FileType make setlocal noexpandtab
autocmd BufRead,BufNewFile makefile set nonu
"autocmd BufRead,BufNewFile makefile setlocal shiftwidth=4 tabstop=4 noexpandtab
" show whitespaces
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.
autocmd filetype html,xml set listchars-=tab:>.
autocmd filetype txt set wrap linebreak nolist
" faster update (ms) for gitgutter and others
"set updatetime=250
" split sizing
set winheight=30
"set winminheight=5
" auto update changes to .vimrc


set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

set history=1000 " change history to 1000
set textwidth=110

"faster screen redraw
set ttyfast
set diffopt+=vertical
"filetype indent plugin on
filetype plugin on
set nocompatible
"set omnifunc=syntaxcomplete#Complete


"-----------------------------------------------------------
"Mapping Settings

let mapleader = ','
" ;w same as :w
nnoremap ; :
" disables Ex mode
nnoremap Q <nop>
" disable c 'delete then insert' motion
"nnoremap c <nop>
" writing to read-only files
cmap w!! w !sudo tee > /dev/null %

" move through wrapped text
nnoremap  <buffer> <silent> k gk
nnoremap  <buffer> <silent> j gj

" save with ctrl-s in all modes
noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>
" open subshell with shift+s
nnoremap <s-s> :sh<CR>
" disable old shift+s command
"nmap <s-s> <Nop>
" exit without saving
nmap <s-x> :q!<CR>
" copy to system clipboard
set pastetoggle=<F11>
" set paste is for pasteing in a computer
map <C-c> "+y<CR>
" search using visual selection
noremap // y/<C-R>"<CR>
" toggle search highlighting with space
" nnoremap <silent> <Space> :set hlsearch! hlsearch?<CR>
" nnoremap <silent> <Space> <Plug>SearchantStop
" pageup/pagedown now move half a page
nnoremap <PageDown> <C-d>
nnoremap <PageUp> <C-u>
nnoremap <c-e> 2<c-e>
nnoremap <c-y> 2<c-y>
" reload .vimrc (to see changes outside .vimrc
"nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>ev :Explore ~/.vim/settings<CR>jj
nnoremap <leader>sv :source $MYVIMRC<CR>
" faster switching between splits
nnoremap ê <C-W><C-J>
nnoremap ë <C-W><C-K>
nnoremap ì <C-W><C-L>
nnoremap è <C-W><C-H>
inoremap ê <C-O><C-W><C-J>
inoremap ë <C-O><C-W><C-K>
inoremap ì <C-O><C-W><C-L>
inoremap è <C-O><C-W><C-H>
" move through wrapped text normally
" imap <silent> <Down> <C-o>gj
" imap <silent> <Up> <C-o>gk
" nmap <silent> <Down> gj
" nmap <silent> <Up> gk
" associate proper syntaxes with files
au BufNewFile,BufRead .bash_aliases call SetFileTypeSH("bash")
autocmd BufNewFile,BufRead .babelrc call SetFileTypeSH("json")
"au BufNewFile,BufRead ~/.Xresources/urxvt-unicode call SetFileTypeSH("xdefaults")
autocmd BufNewFile,BufRead ~/.Xresources.d/* setfiletype xdefaults
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" Abbreviations
abbr funciton function
abbr teh the
abbr tempalte template
abbr fitler filter
"------------------------------------------------------------
"Language Settings

"Spellcheck
"let blacklist = ['docker-prod.yml']
autocmd BufRead,BufNewFile *.md,*.tex setlocal spell spelllang=en_us
"autocmd BufRead,BufNewFile * if index(blacklist, &ft) > 0 | setlocal spell spelllang=en_us

"Wrap words
autocmd BufRead,BufNewFile *.md,*.yml,*.tex set wrap linebreak nolist
autocmd BufRead,BufNewFile *.sh,*.c,*.cpp set textwidth=180
autocmd BufRead,BufNewFile *.js,*.jsx set backupcopy=yes
"Add missing filetypes
autocmd BufRead,BufNewFile docker-*.yml set filetype=docker-compose
autocmd BufRead,BufNewFile docker-*.yml set nowrap
autocmd BufRead,BufNewFile test-project.txt set filetype=Dockerfile
autocmd BufRead,BufNewFile .eslintrc,.tern-project set filetype=json
autocmd BufRead,BufNewFile *.js.flow set filetype=javascript
autocmd BufRead,BufNewFile build.sbt set filetype=scala
autocmd BufRead,BufNewFile *.template set filetype=mustache


autocmd BufRead,BufNewFile *.md set com=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,b:-

"javascript syntax
"autocmd FileType javascript syntax keyword jsBuiltins watch require
"setlocal iskeyword+=$
"highlight link  jsFuncCall  jsFuncName
"highlight jsBuiltins        ctermfg=216(216) ctermbg=none
"syntax case match
"syntax match   jsFuncCall         /\k\+\%(\s*(\)\@=/
"""autocmd FileType javascript syntax
"highlight jsFuncCall        ctermfg=182(182) ctermbg=none
"highlight jsBuiltins        ctermfg=216(216) ctermbg=none
"let g:javascript_ignore_javaScriptdoc=1
"set foldmethod=syntax
"set conceallevel=1
"set concealcursor=nvic

"" vim-javascript conceal settings.
"let g:javascript_conceal_function = "λ"
"let g:javascript_conceal_this = "@"
"let g:javascript_conceal_return = "<"
"let g:javascript_conceal_prototype = "#"


autocmd BufNewFile,BufRead *.js,*.jsx,*.json,*.yml setlocal shiftwidth=2 
autocmd BufNewFile,BufRead *.js,*.jsx.*.json,*.yml setlocal tabstop=2
autocmd BufNewFile,BufRead *.js,*.jsx.*.json,*.yml setlocal softtabstop=2


" don't hide quotes in json files

""jsBeautify
"nmap <c-f> :call JsBeautify()<cr>



"netrw file browser config
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 25
"nnoremap <C-\> :Lexplore<CR>
"inoremap <C-\> <C-O>:Lexplore<CR>
"vnoremap <C-\> <C-C>:Lexplore<CR>

"------------------------------------------------------------
"Plugin Specific Settings

"NERDTree config
"close NERDTree after a file is opened
let g:NERDTreeQuitOnOpen=0
let NERDTreeChDirMode=1
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.git$', '\.idea$', '\~$']
autocmd BufRead,BufNewFile $HOME let NERDTreeShowHidden=0
nnoremap <C-\> :NERDTreeToggle<CR>
inoremap <C-\> <C-O>:NERDTreeToggle<CR>
vnoremap <C-\> <C-C>:NERDTreeToggle<CR>

""nerdtree-git-plugin config
""let g:NERDTreeIndicatorMapCustom = {
            ""\ "Modified"  : "~",
            ""\ "Staged"    : "+",
            ""\ "Untracked" : "*",
            ""\ "Renamed"   : "»",
            ""\ "Unmerged"  : "═",
            ""\ "Deleted"   : "-",
            ""\ "Dirty"     : "x",
            ""\ "Clean"     : "ø",
            ""\ "Unknown"   : "?"
            ""\ }
"let g:NERDTreeUseSimpleIndicator = 1

"
"nerdcommenter config
let NERDSpaceDelims=1


"airline config
let g:airline_powerline_fonts=1
"let g:airline_left_sep=''
"let g:airline_right_sep=''
"let g:airline_theme='base16'
":AirlineRefresh

"YouCompleteMe config
"set omnifunc=syntaxcomplete#Complete
"let g:ycm_add_preview_to_completeopt=0
"let g:ycm_confirm_extra_conf=0
"set completeopt-=preview
"let g:ycm_server_use_vim_stdout = 1
"let g:ycm_server_log_level = 'debug'
"let g:ycm_semantic_triggers = {
            "\   'css': [ 're!^\s{4}', 're!:\s+' ],
            "\ }


" rainbow_parentheses
"autocmd filetype c :RainbowParenthesis
"augroup rainbow_lisp
  "autocmd!
  "autocmd FileType c RainbowParentheses
"augroup END
let g:rainbow#max_level = 16
let g:rainbow#pairs = [['{', '}']]


" vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

"node dictionary
"au FileType javascript set dictionary+=$HOME/.vim/plugged/vim-node-dict/dict/node.dict

"Autoformat config
"autocmd BufWrite *.html,*.css,*.scss,*.js,*.json,*.sh,*.pl,*.hs,*.c,*.cpp,*.h,*.tex  :Autoformat
noremap <C-S-f> :Autoformat<CR>
inoremap <C-S-f> <C-O>:Autoformat<CR>
"javascript folding
"folding settings
"set foldmethod=indent   "fold based on indent
"set foldnestmax=10      "deepest fold is 10 levels
"set nofoldenable        "dont fold by default
"set foldlevel=1         "this is just what i use

"javascript-vim config
let g:javascript_plugin_flow=1

"vim-flow
let g:flow#enable = 0"

"neomake config
"autocmd! BufWritePost *.html,*.css,*.scss,*.js,*.json,*.yml,*.sh Neomake
"let g:neomake_javascript_enabled_makers = ['eslint_d', 'flow']
"let g:neomake_javascript_enabled_makers = ['eslint_d']

let g:jsx_ext_required = 0

"let g:neomake_javascript_enabled_makers = ['babel-eslint']
"let g:neomake_javascript_eslint_maker = {
            "\ 'args': ['--no-color', '--format'],
            "\ 'errorformat': '%f: line %l\, col %c\, %m'
            "\ }
" neomake
nmap <Leader><Space>o :lopen<CR>      " open location window
nmap <Leader><Space>c :lclose<CR>     " close location window
nmap <Leader><Space>, :ll<CR>         " go to current error/warning
nmap <Leader><Space>n :lnext<CR>      " next error/warning
nmap <Leader><Space>p :lprev<CR>      " previous error/warning


let g:vim_json_syntax_conceal = 0
let g:neomake_logfile='/tmp/error.log'

" ale
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

"editorconfig config
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

"vim-markdown-preview config
let vim_markdown_preview_toggle=3
let vim_markdown_preview_github=1

"SyntaxAttr.vim config
map -a        :call SyntaxAttr()<CR>


":nnoremap <F10> zi
"function ForceFoldmethodIndent()
"if &foldenable
"se foldmethod=indent
"endif
"endfunction

"nnoremap <c-f> :normal zi^M|call ForceFoldmethodIndent()^M
"inoremap <c-f> ^O:normal zi^M|call ForceFoldmethodIndent()^M

" deoplete config
" Activate deoplete
let g:deoplete#enable_at_startup = 1

" Start autocompletion right away
" let g:deoplete#auto_complete_start_length = 1

" init variables
let g:deoplete#sources = {}

let g:deoplete#sources.javascript = ['buffer', 'tern']
let g:deoplete#sources#ternjs#types = 1
let g:deoplete#sources#ternjs#docs = 1
let g:deoplete#sources#ternjs#filter = 0
let g:deoplete#sources#ternjs#guess = 0
" autocmd FileType javascript,c let g:deoplete#enable_at_startup = 1
set completeopt-=preview
let g:deoplete#file#enable_buffer_path=1
" auto complete paths relative to working file
"set autochdir
"let g:deoplete#sources={} 
"let g:deoplete#sources._=['buffer', 'member', 'tag', 'file', 'omni', 'ultisnips'] 
"let g:deoplete#omni_patterns={} 
"let g:deoplete#omni_patterns.scala='[^. *\t]\.\w*'


"autocmd FileType javascript setlocal omnifunc=tern#Complete
"if !exists('g:deoplete#omni#input_patterns')
  "let g:deoplete#omni#input_patterns = {}
"endif
"autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" omnifuncs
"augroup omnifuncs
  "autocmd!
  "autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  ""autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  ""autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  "autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  "autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
"augroup end


" Deoplete Plugins
" deoplete-clang
let g:deoplete#auto_complete_start_length = 1
let g:deoplete#sources#clang#libclang_path = "/usr/lib/libclang.so"
let g:deoplete#sources#clang#clang_header = "/usr/lib/clang"
" deoplete-ternjs
" only runs when the cwd has a .tern-project in the root
"let g:tern_request_timeout = 1
"let g:tern_show_signature_in_pum = '0'  " This do disable full signature type on autocomplete

" let g:tern#command = ["tern"]
" let g:tern#arguments = ["--persistent"]



"if exists('g:plugs["tern_for_vim"]')
"let g:term_map_keys=1

  "let g:tern_show_argument_hints = 'on_hold'
  "let g:tern_show_signature_in_pum = 1
  "set completeopt-=preview

"endif

 "deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
" tern
autocmd FileType javascript nnoremap <silent> <buffer> gb :TernDef<CR>
"let tern#is_show_argument_hints_enabled=1
"set noshowmode
"autocmd BufEnter * set updatetime=4000
"autocmd BufEnter *.js set updatetime=200

" disable autocomplete
"let g:deoplete#disable_auto_complete = 1
"if has("gui_running")
    "inoremap <silent><expr><C-Space> deoplete#mappings#manual_complete()
    "nnoremap <silent><expr><C-S-Space> let g:deoplete#disable_auto_complete = 0
"else
    "inoremap <silent><expr><C-@> deoplete#mappings#manual_complete()
"endif
"autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS

"ensime config
" let ensime_server_v2=1



"vim-instant-markdown
let g:instant_markdown_autostart = 0
noremap <leader>mm :InstantMarkdownPreview<CR>

"vimwiki
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

"ctrlp config
"only show files that are not ignored by git
let g:ctrlp_user_command = ['.gitignore', 'cd %s && ag --hidden -g .']
let g:ctrlp_root_markers = ['build.sbt', 'package.json']

"if exists("g:ctrlp_user_command")
"unlet g:ctrlp_user_command
"endif
"set wildignore+=*/tmp/*,*.so,*.swp,*.zip
"let g:ctrlp_custom_ignore = '\v[\/]\.minecraft$'
"let g:ctrlp_custom_ignore = {
"\ 'dir':  '\v\.(git|hg|svn|minecraft)$',
"\ 'file': '\v\.(exe|so|dll)$',
"\ }

" ack.vim
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
