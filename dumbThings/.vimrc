" ======================================================================
" vim配置
" mailto: denis_lton@hotmail.com
" Last Modified Date: 2016-08-22
" ======================================================================

" 定义默认的leader键
let g:mapleader = ','

" 适用于不同的平台
let g:iswindows = 0
let g:islinux = 0

if (has("win32") || has("win64") || has("win95") || has("win16") )
  let g:iswindows = 1
else
  let g:islinux = 1
endif

if (has("gui_running"))
  let g:isGUI = 1
else
  let g:isGUI = 0
endif

if ( g:iswindows && g:isGUI)

  " 去掉输入错误的提示声音
  set noeb

  " 关闭声音警报和屏闪
  set visualbell t_vb=
  au GuiEnter * set t_vb=

  " 防止菜单栏编码错误以及右键菜单
  set encoding=utf8
  set langmenu=zh_CN.UTF-8
  set imcmdline
  source $VIMRUNTIME/delmenu.vim
  source $VIMRUNTIME/menu.vim
  language messages utf-8

  " 解决gvim中提示框乱码
  language message zh_CN.UTF-8

  " 取消菜单，工具栏，滚动条
  set guioptions-=m
  set guioptions-=T
  set guioptions-=r
  set guioptions-=L

  " 在GUI模式中打开VIM就最大化
  au GUIEnter * simalt ~x

endif

" 配置自动生效
autocmd BufWritePost $MYVIMRC source $MYVIMRC

" ===================== Vundle插件管理区域(开始) =====================

set nocompatible
filetype off

if (g:iswindows && g:isGUI)
  set rtp+=$VIM/vimfiles/bundle/Vundle.vim
  call vundle#begin("$VIM/vimfiles/bundle")
endif

if g:islinux
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()
endif

Plugin 'VundleVim/Vundle.vim'

" ====================== 通用插件 ============================

" 删除脚本每行后面多余的空格
Plugin 'bronson/vim-trailing-whitespace'
map <leader><Space> :FixWhitespace<CR>


" 终端下和tmux配合直接使用ctrl-h,l,k,j等，不用ctrl+b触发
Plugin 'christoomey/vim-tmux-navigator'

" 自动括号补全
Plugin 'jiangmiao/auto-pairs'

" 状态栏显示
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" tab的功能拓展
Plugin 'ervandew/supertab'
let g:SuperTabDefaultCompletionType="context"

" 更加快速移动
Plugin 'Lokaltog/vim-easymotion'

" %匹配括号等
Plugin 'tmhedberg/matchit'

" 更加简单的注释
Plugin 'scrooloose/nerdcommenter'
" make comment with a space
let g:NERDSpaceDelims=0
let g:NERDCompactSexyComs=1
let g:NERDDefaultAlign="left"

" 搜索当前目录的所有文件
Plugin 'kien/ctrlp.vim'
let g:ctrlp_map='<leader>p'
let g:ctrlp_cmd='CtrlP'
let g:ctrlp_working_path_mode=0
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height=15
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_max=500
let g:ctrlp_follow_symlinks=1
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\tmp\*,*.swp,*.zip,*.exe  " Windows
let g:ctrlp_custom_ignore={
  \ 'dir': '\/]\.(git|hg|svn|rvm)$',
  \ 'file': '.(exe|so|dll|zip|tar|tar.gz)$',
  \}

" 多彩的配对符号
Plugin 'luochen1990/rainbow'
let g:rainbow_active = 1
let g:rainbow_conf = {
\   'guifgs': ['royalblue3', 'lightorange3', 'seagreen3', 'firebrick'],
\   'ctermfgs': ['lightgray', 'lightblue', 'lightmagenta', 'lightcyan'],
\   'operators': '_,_',
\   'parentheses': [['(',')'], ['\[','\]'], ['{','}']],
\   'separately': {
\       '*': {},
\       'lisp': {
\           'guifgs': ['royalblue3', 'lightorange3', 'seagreen3',                     'firebrick', 'lightorchid3'],
\           'ctermfgs': ['lightgray', 'lightblue', 'lightmagenta',                     'lightcyan', 'lightred', 'lightgreen'],
\       },
\       'html': {
\           'parentheses': [['(',')'], ['\[','\]'], ['{','}'],      ['<^>]*[^/]>\|<','</[^>]*>']],
\       },
\       'tex': {
\           'operators': '',
\           'parentheses': [['(',')'], ['\[','\]']],
\       },
\   }
\}

" minibuffer优化
Plugin 'fholgado/minibufexpl.vim'
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
" 解决FileExplorer窗口变小问题
let g:miniBufExplForceSyntaxEnable = 1
let g:miniBufExplorerMoreThanOne=2
let g:miniBufExplCycleArround=1
" 默认方向键左右可以切换buffer
nnoremap <TAB> :MBEbn<CR>
noremap <leader>bn :MBEbn<CR>
noremap <leader>bp :MBEbp<CR>
" 关闭minibuffer
noremap <leader>bd :MBEbd<CR>

" 源码浏览，配合ctags用
Plugin 'majutsushi/tagbar'
nmap <leader>tt :TagbarToggle<cr>
let g:tagbar_type_r = {
    \ 'ctagstype' : 'r',
    \ 'kinds'     : [
        \ 'f:Functions',
        \ 'g:GlobalVariables',
    \ ]
\ }

" 整合nerdtree和taglist在同一边
Plugin 'vim-scripts/winmanager'
let g:winManagerWindowLayout = "BufExplorer"
" 设置默认宽度
let g:winManagerWidth = 40
" nmap nw :NERDTreeToggle<CR> :TlistToggle<CR>
nmap nw :WMToggle<CR>

" 目录树
Plugin 'scrooloose/nerdtree'
map <leader>n :NERDTreeToggle<CR>
let NERDTreeHighlightCursorline=1
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.obj$', '\.o$', '\.so$', '\.egg$', '^\.git$', '^\.svn$', '^\.hg$', '\.exe$', '\.dll', '__pycache__' ]
" close vim if only NERDTree window exists.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" NERDTree 配置
let g:NERDTree_title="[NERDTree]"
function! NERDTree_Start()
  exe 'NERDTree'
endfunction
function! NERDTree_IsValid()
  return 1
endfunction

" 对目录树的不同类型文件进行高亮
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
" without vim-devicons
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExtensionHighlightColor = {}
let g:NERDTreeExtensionHighlightColor['R'] = '00FF00'

" 在单词两边添加东西
Plugin 'tpope/vim-surround'
" ysiw 插入光标所在单词
" ys3w 插入后3个单词周围
" yss 插入整行
" ds 删除delete
" cs 改变change
" 加强用 . 重复操作
Plugin 'tpope/vim-repeat'

" 对其:Tab\|, 按照|对齐，代码对齐
" Plugin 'godlygeek/tabular'
" define some shortcut
" if exists(":Tabularize")
  " nmap <Leader>t= :Tabularize /=<CR>
  " vmap <Leader>t= :Tabularize /=<CR>
  " nmap <Leader>t# :Tabularize /#<CR>
  " vmap <Leader>t# :Tabularize /#<CR>
  " nmap <Leader>t: :Tabularize /:\zs<CR>
  " vmap <Leader>t: :Tabularize /:\zs<CR>
" endif

" vim easy align plugin, use gaip*= to align '=', 按照分隔符对齐文字
" https://github.com/junegunn/vim-easy-align
Plugin 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" 自动补全
Plugin 'Shougo/neocomplcache.vim'
Plugin 'Shougo/neocomplete'
Plugin 'osyo-manga/neocomplcache-clang_complete'
let g:neocomplete#enable_ignore_case = 0
" 模板补全
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
let g:UltiSnipsExpandTrigger="<tab>"
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
" enable the menu and pydoc preview to get most useful information
set completeopt=menuone,longest,preview
" when there is a dot completion in python script, occuring freezing
let g:pymode_rope_lookup_project = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope = 0
let g:pymode_rope_guess_project = 0
" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" 快速选中函数定义中的代码
Plugin 'terryma/vim-expand-region'
map - <Plug>(expand_region_shrink)

" 多鼠标操作
Plugin 'terryma/vim-multiple-cursors'
let g:multi_cursor_use_default_mapping=0
" Default mapping, ctrl+m, alt+i
let g:multi_cursor_next_key='<C-m>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" 最近打开的文件
Plugin 'vim-scripts/mru.vim'
highlight link MRUFileName LineNr
map <leader>m :MRU<CR>

" 用来选择代码块非常的方便，如vai
Plugin 'michaeljsmith/vim-indent-object'

" indent指示颜色
Plugin 'nathanaelkane/vim-indent-guides'
" custommize the colorschema
let g:indent_guides_auto_colors = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" 读取大文件
Plugin 'vim-scripts/LargeFile'

" ====================== python程序插件 ======================

" python mode
Plugin 'klen/python-mode'
" 自动删除python脚本中多余的空格
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
" python语法检查工具
Plugin 'scrooloose/syntastic'
let g:syntastic_python_checkers = ['pylint']

" ===================== R整合为轻度IDE =====================

" Plugin 'jalvesaq/Nvim-R'

" R的IDE配置插件
"Plugin 'Vim-R-plugin'
" '_' 默认转换成 '<-'
"let vimrplugin_assign = 1
"let vimrplugin_listmethods = 1
"let vimrplugin_rcomment_string = "#"
"let vimrplugin_vsplit = 0
"let vimrplugin_applescript = 0
"let vimrplugin_indent_commented = 0
"let vimrplugin_listmethods = 1
"let vimrplugin_start_libs = 'base,stats,graphics,grDevices,utils,datasets,methods,ggplot2,mlr'
"let vimrplugin_rconsole_height = 12
"" completion of R function
"let vimrplugin_show_args = 1
"let vimrplugin_args_in_stline = 1
"" indent like python
"" set vim-r-plugin to
"let r_indent_align_args = 0
"" Set vim-r-plugin to mimics ess :
"let r_indent_ess_comments = 0
"let r_indent_ess_compatible = 0

" R的vim runtime环境更新
"Plugin 'jalvesaq/R-Vim-runtime'

" ===================== 前端补全工具 =====================
Plugin 'mattn/emmet-vim'

" ===================== c/c++ =====================
" c/c++模板工具类, 入门介绍
" http://www.thegeekstuff.com/2009/01/tutorial-make-vim-as-your-cc-ide-using-cvim-plugin/
Plugin 'vim-scripts/c.vim'
" .h和.c/.cpp之间来回切换
Plugin 'vim-scripts/a.vim'

" ===================== 特殊文件辅助显示 =====================

Plugin 'elzr/vim-json'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'plasticboy/vim-markdown'
let g:vim_markdown_no_default_key_mappings=1
" 即时markdown预览，需要和浏览器配合使用并且以来npm
" Plugin 'suan/vim-instant-markdown'
" csv file display，操作csv文件使用，配合easy-align插件可以很好显示csv并操作csv文件
Plugin 'chrisbra/csv.vim'
hi CSVColumnEven term=bold ctermbg=4 guibg=DarkBlue
hi CSVColumnOdd  term=bold ctermbg=5 guibg=DarkMagenta

" ==================== 颜色主题 =====================
Plugin 'tomasr/molokai'
Plugin 'altercation/vim-colors-solarized'

call vundle#end()
filetype plugin indent on

" ====================== 插件管理区域(结束) ====================

" 设置主题，只能在插件外设置
colorscheme desert
set background=dark

" ==============================================================================
" 通用的按键绑定设置
" ==============================================================================

" 更好的撤销方式
nnoremap U <C-r>

" 选择当前所有内容
map <leader>sa ggVG

" VIM配置文件快捷打开方式
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" 取消当前高亮显示
nmap <leader>hl :nohl<CR>

" 在插入模式中保持一些快捷键
cnoremap <C-j> <t_kd>
cnoremap <C-k> <t_ku>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
inoremap <C-j> <t_kd>
inoremap <C-k> <t_ku>
inoremap <C-a> <Home>
inoremap <C-e> <End>

" 在窗口移动快捷键
map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l

" shortcut for split the windows
map <leader>s :split<CR>
map <leader>vs :vsplit<CR>

" 退出当前窗口
map <leader>q :q<CR>

" 一键删除windows换行符
nmap <F5> :% s/\r//g<CR>


" ==============================================================================
" 基本配置
" ==============================================================================

" file coding format style
set encoding=utf-8                " vim internal format
set fileencoding=utf-8            " current file

" file format
set fileformat=unix
set fileformats=unix,dos,mac

" 实时搜索
set incsearch

" 高亮搜索
set hlsearch

" 忽略大小写
set ignorecase

" 语法高亮开启
syntax enable
" 允许用指定语法高亮配色方案替换默认方案
syntax on

" 显示光标当前位置
set ruler

" 是否要顯示 --INSERT-- 之類的字眼在左下角的狀態列
set showmode
" 显示最后一行的执行命令
set showcmd

" 显示相对行号，并且能够切换
set nu
set relativenumber number
au FocusLost * :set norelativenumber number
au FocusGained * :set relativenumber
autocmd InsertEnter * :set norelativenumber number
autocmd InsertLeave * :set relativenumber
function! ToggleNumber()
  if (&relativenumber==&number)
    set relativenumber! number!
  elseif (&number)
    set number!
  else
    set relativenumber!
  endif
    set number?
endfunc
nnoremap <leader>2 :call ToggleNumber() <CR>
set pastetoggle=<leader>5

" vim自身命令行模式智能补全
set wildmenu

" 忽略匹配的文件
set wildignore=*.swp,*.bak,*.pyc,*.class,*.out

" 自动重新加载文件如果外部修改了当前打开的文件
set autoread

" 高亮显示当前鼠标行
set cursorline
" set cursorcolumn

" 不备份文件
set nobackup
set noswapfile

" 自动缩进
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
if has("autocmd")
    " autocmd FileType r,css,html,javascript setlocal ts=2 sts=2 sw=2
    autocmd FileType py set ts=4 sts=4 sw=4
endif
set smarttab
set expandtab
set shiftround
set hidden
set wildmode=list:longest
set ttyfast
set magic
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" 根据文件后缀名进行文件识别
au BufRead,BufNewFile *{r,R,rnw,Rnw} set filetype=r
au BufRead,BufNewFile *.{ejs,handlebars,hbs} set filetype=html

" 光标不闪烁
set gcr=a:block-blinkon0

" auto change directory to current editing file dir
au BufRead, BufNewFile, BufEnter * cd %:p:h

" 设置标记一列的背景颜色和数字一行颜色一致
hi! link SignColumn   LineNr
hi! link ShowMarksHLl DiffAdd
hi! link ShowMarksHLu DiffChange

" 防止错误导致看不清行标
highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline

" 设置字体大小等
if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 18
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h18
  elseif has("gui_win32")
    set guifont=Consolas:h18:cANSI
  endif
endif
