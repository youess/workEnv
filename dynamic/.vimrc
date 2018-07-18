
" 安装插件
set nocompatible
filetype off

" 设置插件位置
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" git wrapper
Plugin 'tpope/vim-fugitive'

" tab功能拓展
"Plugin 'ervandew/supertab'
"let g:SuperTabDefaultCompletionType="context"


" nerdtree 和 nerd comment
Plugin 'scrooloose/nerdtree'
" 与easymotion冲突
nnoremap <F2> :NERDTreeToggle<CR>
let NERDTreeIgnore=['*.out', '*.obj', '*.exe']
Plugin 'scrooloose/nerdcommenter'

" 移动方便, ',,w'
Plugin 'easymotion/vim-easymotion'

" snippets
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

let g:UltiSnipsExpandTrigger="<C-z>"
let g:UltiSnipsJumpForwardTrigger="<C-f>"
let g:UltiSnipsJumpBackwardTrigger="<C-b>"

" .cpp和.h文件跳转
Plugin 'vim-scripts/a.vim'

" taglist
Plugin 'vim-scripts/taglist.vim'
nnoremap <silent><F5> :TlistToggle<CR>
let Tlist_Show_One_File=0        " 只显示当前文件
let Tlist_Exit_OnlyWindow=1      " 最后一个窗口就推出
let Tlist_Use_Right_Window=1     " 右侧显示窗口
let Tlist_File_Fold_Auto_Close=1 " 自动折叠

" ctrl + p
Plugin 'kien/ctrlp.vim'

" 删除最后留白
Plugin 'ntpeters/vim-better-whitespace'

" you complete me, 完整安装还需要切到bundle目录下进行./install.py
" --cpp,go等插件安装
Plugin 'Valloric/YouCompleteMe'

" json tools
Plugin 'elzr/vim-json'

" colorscheme
Plugin 'vim-scripts/256-jungle'

call vundle#end()
filetype plugin indent on

let g:ycm_python_binary_path = '/usr/bin/python3'

" 设置编译并运行c++程序快捷键
" map <F8> :!clang % && ./a.out <CR>

" 代码折叠
set foldmethod=indent
" set foldmethod=syntax
" 启动vim时关闭折叠代码
set nofoldenable

" 让vimrc配置变更立即生效, 编辑文件容易卡顿，建议不开启
" autocmd BufWritePost $MYVIMRC source $MYVIMRC

" 设置leader变量
let mapleader = ","

" 自动语法高亮
syntax on

" 检测文件类型
filetype on

" 设定tab长度为4
set tabstop=4

" 设定 << 和 >> 命令移动 宽度为4
set shiftwidth=4
set smarttab

" 覆盖文件 不备份
set nobackup

" 搜索 忽略大小写，但有一个或以上大写字母 仍大小写敏感
set ignorecase
set smartcase
" 高亮搜索文本
set hlsearch
" 取消高亮搜索文本
nmap <leader>hl :nohl<CR>

" 开启实时搜索功能
set incsearch
" 关闭兼容模式
set nocompatible
" vim自身命令行模式智能补全
set wildmenu

" zhi neng 自动缩进
set smartindent

" 更改J, K移动距离
"nmap J 5j
"nmap K 5k

" 窗口切换
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k

" 恢复撤销
noremap U <C-r>

" 设置编码
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8

" 突出显示当前行, 会容易导致vim卡顿
" set cursorline

" 启用鼠标, 可以利用鼠标移动编辑器里面的光标
set mouse-=a
set selection=exclusive
set selectmode=mouse,key

" 显示括号匹配
set showmatch

" 总是显示状态
set laststatus=2

" 配色
" 挑选配色网址: http://bytefluent.com/vivify/
colorscheme 256-jungle

" ctags
" ctrl + ] go to definition
" ctrl + T jump back from the definition
" ctrl + w ctrl + ] open definition in a horizontal split

if has("cscope")
	set csprg=/usr/bin/cscope
	set csto=1 " 先搜索tag文件, 然后cscope db
	set cst
	set nocsverb
	if filereadable("cscope.out")
		cs add cscope.out
	endif
	set csverb
endif

nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>

