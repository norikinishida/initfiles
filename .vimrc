" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

"******************************************************************************

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

"******************************************************************************

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible


"******************************************************************************

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on " 構文ごとに文字色を変化させる
endif

"******************************************************************************

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark "暗い背景色に合わせた配色にする

"******************************************************************************

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"******************************************************************************

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

"******************************************************************************
"基本設定

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd	     	" 入力中のコマンドを表示
set showmatch		" 対応する括弧の強調
set ignorecase		" Do case insensitive matching
set smartcase		" 小文字のみで検索したときに大文字小文字を無視
set incsearch		" 検索ワードの最初の文字を入力した時点で検索を開始
"set autowrite		" Automatically save before commands like :next and :make
set hidden          " 保存されていないファイルがあるときでも別のファイルを開けるようにする
set mouse=a	 	    " Enable mouse usage (all modes)
set guifontset=a14,r14,k14
set linespace=1
"set paste
set textwidth=0
set tabstop=4 " タブ文字の表示幅
set autoindent " 改行時に前の行のインデントを継続
set expandtab "タブ入力を複数の空白に置き換える
"set noexpandtab
set shiftwidth=4 " インデントの幅
set smarttab " 行頭の余白内でTABを打つと，shiftwidthの数だけインデントする
set softtabstop=4
set backspace=indent,eol,start
"set columns=75
"set lines=55
set cmdheight=2
set guioptions+=a
set clipboard+=unnamed,autoselect
set number "行番号の表示
set ruler "ステータスラインの右側にカーソルの現在位置を表示
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%ceV%8P
if isdirectory(expand('~/.vim/bundle/vim-fugitive'))
    set statusline+=%{fugitive#statusline()} "ステータス行に現在のgitブランチを表示
endif
set laststatus=2
set title "ウィンドウのタイトルバーにファイルのパス情報等を表示
set wildmenu "コマンドモードの補完
set foldlevel=0
set directory=$HOME
set hlsearch "検索強調
nnoremap n nzz
nnoremap N Nzz
" set cursorline "カーソル行強調
" set colorcolumn=100 "列マーク
" set nowrap "折り返しなし
set noswapfile "スワップファイルなし
set nobackup "バックアップファイル"~"なし
" set list "不可視文字を表示する
set autoread
" set synmaxcol=180
set completeopt=menuone "補完のポップアップの制御

"******************************************************************************
" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

"******************************************************************************
"カラースキーム
"

syntax enable
set t_Co=256

" let g:solarized_termcolors=16
" let g:solarized_termtrans=0
" let g:solarized_degrade=0
" let g:solarized_bold=1
" let g:solarized_underline=1
" let g:solarized_italic=1
" let g:solarized_contrast="high"
" let g:solarized_visibility="normal"

" TODO, FIXME とか
" autocmd ColorScheme * highlight Todo ctermfg=198
autocmd ColorScheme * highlight IncSearch ctermbg=197

" colorscheme solarized
colorscheme cobalt

" *.edu.txt.depにJSONファイルの言語シンタックスを適用
autocmd BufNewFile,BufRead *.edu.txt.dep set filetype=json

"******************************************************************************
"挿入モードをステートラインの色で判別できるようにする

if !exists('g:hi_insert')
    let g:hi_insert= 'highlight StatusLine guifg=white guibg=black gui=none ctermfg=33 ctermbg=234 cterm=none'
endif

"if has('unix') && !has('gui_running')
"    inoremap <silent> <ESC> <ESC>
"    inoremap <silent> <C-[> <ESC>
"endif

if has('syntax')
    augroup InsertHook
        autocmd!
        autocmd InsertEnter * call s:StatusLine('Enter')
        autocmd InsertLeave * call s:StatusLine('Leave')
    augroup END
endif

let s:slhlcmd= ''
function! s:StatusLine(mode)
    if a:mode== 'Enter'
        silent! let s:slhlcmd= 'highlight ' . s:GetHighlight('StatusLine')
        silent exec g:hi_insert
    else
        highlight clear StatusLine
        silent exec s:slhlcmd
    endif
endfunction

function! s:GetHighlight(hi)
    redir => hl
    exec 'highlight ' .a:hi
    redir END
    let hl= substitute(hl, '[\r\n]', '', 'g')
    let hl= substitute(hl, 'xxx', '', '')
    return hl
endfunction

"******************************************************************************
" カーソル下のsyntax情報を取得する

function! s:get_syn_id(transparent)
  let synid = synID(line("."), col("."), 1)
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction
function! s:get_syn_attr(synid)
  let name = synIDattr(a:synid, "name")
  let ctermfg = synIDattr(a:synid, "fg", "cterm")
  let ctermbg = synIDattr(a:synid, "bg", "cterm")
  let guifg = synIDattr(a:synid, "fg", "gui")
  let guibg = synIDattr(a:synid, "bg", "gui")
  return {
        \ "name": name,
        \ "ctermfg": ctermfg,
        \ "ctermbg": ctermbg,
        \ "guifg": guifg,
        \ "guibg": guibg}
endfunction
function! s:get_syn_info()
  let baseSyn = s:get_syn_attr(s:get_syn_id(0))
  echo "name: " . baseSyn.name .
        \ " ctermfg: " . baseSyn.ctermfg .
        \ " ctermbg: " . baseSyn.ctermbg .
        \ " guifg: " . baseSyn.guifg .
        \ " guibg: " . baseSyn.guibg
  let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  echo "link to"
  echo "name: " . linkedSyn.name .
        \ " ctermfg: " . linkedSyn.ctermfg .
        \ " ctermbg: " . linkedSyn.ctermbg .
        \ " guifg: " . linkedSyn.guifg .
        \ " guibg: " . linkedSyn.guibg
endfunction
command! SyntaxInfo call s:get_syn_info()

"******************************************************************************
"エンコードとか文字環境まわり

set termencoding=utf-8
set encoding=utf-8
set fileencoding=utf-8
set ffs=unix
if exists('&ambiwidth')
	set ambiwidth=double
endif

"******************************************************************************
" キーバインド

"escは遠い
inoremap jj <Esc>
inoremap kk <Esc>

"矢印キーの無効
inoremap <LEFT> <Nop>
inoremap <RIGHT> <Nop>
inoremap <DOWN> <Nop>
inoremap <UP> <Nop>
inoremap <PageDown> <Nop>
inoremap <PageUp> <Nop>
nnoremap <LEFT> <Nop>
nnoremap <RIGHT> <Nop>
nnoremap <DOWN> <Nop>
nnoremap <UP> <Nop>
nnoremap <PageDown> <Nop>
nnoremap <PageUp> <Nop>

" 補完キー"ctrl^n"は押しにくい
inoremap <C-t> <C-n>

" タブ操作
nnoremap <C-Right> :tabnew <Return>
nnoremap <C-Left> :tabclose <Return>
nnoremap <C-Up> gt
nnoremap <C-Down> gT
inoremap <C-Right> <Esc>:tabnew<Return>
inoremap <C-Left> <Esc>:tabclose<Return>
inoremap <C-Up> <Esc>gt
inoremap <C-Down> <Esc>gT

"******************************************************************************
" makeコマンド設定

autocmd filetype python :set makeprg=python\ %

"******************************************************************************
"Go言語設定

if $GOROOT != ''
    set rtp+=$GOROOT/misc/vim
endif

" gocode
set rtp+=$GOROOT/misc/vim

" golint
exe "set rtp+=".globpath($GOPATH, "src/github.com/golang/lint/misc/vim")

" 自動補完
auto BufWritePre *.go Fmt

"******************************************************************************
" 自作コマンド

" Beamer の frame のテンプレート
cmap bframe r!cat ~/.vim/mybeamertemplate_frame.tex
cmap bitem r!cat ~/.vim/mybeamertemplate_itemize.tex
cmap benum r!cat ~/.vim/mybeamertemplate_enumerate.tex
cmap balign r!cat ~/.vim/mybeamertemplate_align.tex
cmap bblock r!cat ~/.vim/mybeamertemplate_block.tex
cmap bfigure r!cat ~/.vim/mybeamertemplate_figure.tex
cmap btable r!cat ~/.vim/mybeamertemplate_table.tex
cmap bcols r!cat ~/.vim/mybeamertemplate_columns.tex

" Pythonのdocstring自動補完
cmap pydoc r!cat ~/.vim/docstringtemplate.txt

"******************************************************************************
"vundle プラグイン管理

set nocompatible               " be iMproved
filetype off                   " required!

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif
call neobundle#begin(expand('/home/norikinishida/.vim/bundle/'))

" インストールするプラグイン
NeoBundleFetch 'Shougo/neobundle.vim' "NeoBundle自身
"--------------------------
" VimShell
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/vimshell'

" ファイルオープンを便利に
NeoBundle 'Shougo/unite.vim'

" 自動補完
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neosnippet'
NeoBundle "Shougo/neosnippet-snippets"
if neobundle#is_installed('neocomplete')
    " vim起動時にneocompleteを有効にする
    let g:neocomplete#enable_at_startup = 1
    " ?
    let g:neocomplete#enable_ignore_case = 1
    " smartcase有効化．大文字が入力されるまで大文字小文字の区別を無視する
    let g:neocomplete#enable_smart_case = 1
    " ?
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    " ?
    let g:neocomplete#keyword_patterns._ = '\h\w*'
elseif neobundle#is_installed('neocomplcache')
    " vim起動時にneocompleteを有効にする
    let g:neocomplcache_enable_at_startup = 1
    " ?
    let g:neocomplcache_enable_ignore_case = 1
    " smartcase有効化．大文字が入力されるまで大文字小文字の区別を無視する
    let g:neocomplcache_enable_smart_case = 1
    " ?
    if !exists('g:neocomplcache_keyword_patterns')
        let g:neocomplcache_keyword_patterns = {}
    endif
    " ?
    let g:neocomplcache_keyword_patterns._ = '\h\w*'
    let g:neocomplcache_enable_camel_case_completion = 0
    let g:neocomplcache_enable_underbar_completion = 1
endif
" タブキーで補完候補の選択．
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" バックスペースで補完のポップアップを閉じる
if neobundle#is_installed('neocomplete')
    inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"
elseif neobundle#is_installed('neocomplcache')
    inoremap <expr><BS> neocomplcache#smart_close_popup()."<C-h>"
endif
" ?
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" 括弧の補完
NeoBundle 'Townk/vim-autoclose'

" 複数行のコメントアウト
NeoBundle 'tomtom/tcomment_vim'

" 複数行のコメントアウト
NeoBundle "tyru/caw.vim.git"
nmap <C-i> <Plug>(caw:i:toggle)
vmap <C-i> <Plug>(caw:i:toggle)

" 構文エラーチェックと表示
" NeoBundle 'scrooloose/syntastic'

" 全角と半角の空白文字を可視化
NeoBundle "bronson/vim-trailing-whitespace"

" インデントの可視化
NeoBundle "Yggdroot/indentLine"
" let g:indentLine_char = "|"
" \textbf{}や\textit{}がバグるから*.texだけ無効にする
let g:indentLine_fileTypeExclude = ["tex"]
" let g:indentLine_setConceal = 0
let g:indentLine_color_term = 238

" インデントの可視化 (代替)
" NeoBundle 'nathanaelkane/vim-indent-guides'
" let g:indent_guides_enable_on_vim_startup = 1
" let g:indent_guides_start_level = 2
" let g:indent_guides_guide_size = 1
" let g:indent_guides_auto_colors = 0
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=0
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=0

" A pack of general purpose utility functions
NeoBundle 'L9'

" 特定の変数名や関数名だけハイライトする
NeoBundle 't9md/vim-quickhl'
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)

" ディレクトリのツリー表示
" NeoBundle 'scrooloose/nerdtree'

" grepによるファイル検索
NeoBundle 'vim-scripts/grep.vim'
" Rgrepコマンド

" ファイル検索
NeoBundle 'https://github.com/wincent/command-t.git'

" ファイル検索
NeoBundle 'FuzzyFinder'

" " 多機能セレクタ
" NeoBundle "ctrlpvim/ctrlp.vim"
" NeoBundle "tacahiroy/ctrlp-funky"
" NeoBundle "suy/vim-ctrlp-commandline"
" " マッチングウィンドウ．下部に表示，大きさ20行で固定，検索結果100件．
" let g:ctrlp_match_window = "order:ttb,min:20,max:20,results:100"
" " .(ドット)から始まるファイルも検索対象に
" let g:ctrlp_show_hidden = 1
" " ファイル検索のみ使用
" let g:ctrlp_types = ["fil"]
" " CtrlPの拡張としてfunkyとcommandlineを使用
" let g:ctrlp_extensions = ["funky", "commandline"]
" " CtrlPCommandLineの有効化
" command! CtrlPCommandLine call ctrlp#init(ctrlp#commandline#id())
" " CtrlPFunkyの有効化
" let g:ctrlp_funky_matchtype = "path"
" " How to Use
" " CtrlPの起動: Ctrl+P
" " 検索モードの切り替え: Ctrl+F
" " 下方向のカーソル移動: Ctrl+J
" " 上方向のカーソル移動: Ctrl+K
" " 検索結果の選択(バッファ): Enter
" " 検索結果の選択(水平分割): Ctrl+X
" " CtrlPの終了: Esc
"
"" Git用
NeoBundle 'tpope/vim-fugitive'
" Gstatus : git status
" Gwrite : 現在開いているソースをgit add
" Gcommit : git commit
" Gread : 現在開いているソースの直前のコミット時のソースを表示
" Gmove dst/path : 現在開いているソースをgit mv
" Gremove : 現在開いているソースをgit rm
" Gblame : 現在開いているソースをgit blame
" Gdiff : 現在開いているソースの変更点をvimdiffで表示

" \rで実行
NeoBundle 'thinca/vim-quickrun'

" カーソル位置のコードをコンソールに送信
NeoBundle 'jpalardy/vim-slime'

" ANSI colorを表示
NeoBundle 'vim-scripts/AnsiEsc.vim'

" Google's Protocol Buffersのsyntax highlighting
NeoBundle 'uarun/vim-protobuf'

" Go言語用の何か?
NeoBundle 'Blackrush/vim-gocode'

" Scale
NeoBundle 'derekwyatt/vim-scala'

" HTML/CSSの入力を効率化
NeoBundle 'mattn/emmet-vim'

" Add MacPorts support to vim
NeoBundle 'https://svn.macports.org/repository/macports/contrib/mpvim/'

" JSON用
NeoBundle 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0

" TypeScript
NeoBundle 'leafgarland/typescript-vim'
autocmd BufRead,BufNewFile *.ts set filetype=typescript

"--------------------------
call neobundle#end()

filetype plugin indent on     " required!
filetype indent on

NeoBundleCheck "未インストールのプラグインがある場合，インストールするか訊く

" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..
