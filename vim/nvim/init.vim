" ps. 21/8/17 10:34,nvim在mac下有行错位的问题,那就重启终端

"""""""""""common set begin
" syntax enable会保留当前的颜色设置
" syntax on将覆盖以前所做的颜色配置
syntax on
syntax enable

"vim首先在当前目录里寻找tags文件，如果没有找到tags文件，或者没有找到对应的目标，就到父目录中查找，一直向上递归。因为tags文件中记录的路径总是相对于tags文件所在的路径,需要注意的是，第一个命令里的分号是必不可少的
set tags=tags;
"这个选项不能打开,否则每当打开一个文件后,就会自动切换到文件所在的目录
"set autochdir

"set t_ut= " 防止vim背景颜色错误
"set showmatch " 高亮匹配括号
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
"setlocal hls
set hls " hlsearch
set magic
set autoread "有 Vim 之外的改动时自动重读文件
" 把默认的未命名寄存器与系统剪贴板关联上,这样y，d，s，x等操作就和系统剪贴版关联上了
" [参考stackoverflow之Paste in insert
" mode](https://stackoverflow.com/questions/2861627/paste-in-insert-mode)
" 在插入模式下,有三类从系统剪切板粘贴的方法:
" 1. <C-r>+ ps. 插入模式默认自动缩进,代码会被格式化
" 2. <C-o>p 或 <C-o>P ps. 感觉还是这种方法最高效
" 3. <esc> p i
set clipboard^=unnamed,unnamedplus

" 滚动屏幕,滚屏
" 自动回绕
"set wrapscan
"set nowrap

set number
set relativenumber
set nobackup
set nowritebackup
"vim打开一个文件时，都会产生一个.swp的隐藏文件（即文件名.开头的），这个文件是一个临时交换文件，用来备份缓冲区中的内容，用于保存数据。
"当文件非正常关闭（比如直接关闭终端或者电脑断电等）时，文件不会被删除，可用此文件来恢复；当正常关闭时，此文件会被删除。
set swapfile
"set cursorcolumn
" 若是有行错位等的问题,可以考虑重启终端, ps. 这是在mac的情况下
" 在tty的情况下,cursorline会有行错乱的问题
set cursorline
set nocompatible " 去除VI一致性
set errorbells "这样当错误发生的时候将会发出 bi 的一声
set visualbell "代替 bell 的将是屏幕的闪烁
" 表示一个tab显示出来是多少个空格
set tabstop=4
" 在编辑的时候（比如按退格或tab键）一个 tab 是多少个空格
" 方便在开启了et后使用退格（backspace）键，每次退格将删除X个空格
set softtabstop=4
" 每一级缩进是多少个空格
set shiftwidth=4
" 将tab扩展成空格
"开启后要输入TAB，需要Ctrl-V<TAB>
set expandtab
" 根据文件中其他地方的缩进空格个数来确定一个 tab 是多少个空格
" 开启时，在行首按TAB将加入sw个空格，否则加入ts个空格
set smarttab
":retab! "将文档中既有的<Tab>转成<space>
" 会以字符的形式显示tab
set list
"set autoindent
" smartindent貌似要比autoindent高级一点
set smartindent
" 下面这句相当于: filetype on + plugin on + indent on
" 在启用了下面这一句后,cindent/autoindent/smartindent就没多大用处了,这三者只是vim系统自带的
filetype plugin indent on   " 打开文件类型检测功能,[开启文件类型检测](https://blog.easwy.com/archives/advanced-vim-skills-filetype-on/)
set ic " ignorecase
" 只能在 ignorecase 开启的时候使用，目的是在忽略大小写的大局下，根据搜索模式，动态地抑制 ignorecase 的功能，使大小写策略恢复到默认的区分大小写的搜索
" 在忽略大小写的搜索下，搜索模式使用大写还是小写已经无关紧要，而输入全小写 的搜索模式更加简单。在这种情况下，如果搜索模式中出现了大写字符，smartcase 会判断用户想使用区分大小写的搜索
set smartcase
set autoread
set hidden " 允许在有未保存的修改时切换缓冲区,此时的修改由vim负责保存
" Give more space for displaying messages.
set cmdheight=1
" 这个选项不能设置,否则coc-references当只有两条引用的时候,就会出现没有preview的bug
" 参考: [New window creation issues (for jump to definition etc) with noequalalways (E36) #3012](https://github.com/neoclide/coc.nvim/issues/3012)
"set noequalalways
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
set updatetime=300
set tabpagemax=15
set showtabline=2   " 总是显示标签页
set foldenable

" 自定义快捷键的方式有6种:<leader>,<localleader>,ctrl,alt,g开头,z开头.
" 其他方式开头的快捷键方式就不要考虑了,因为可能会造成冲突,而且现有的这6种方式应该是足够了.
" 优先考虑<leader>,若是快捷键有冲突或命令不怎么常用,则用<localleader>
" <leader>和<localleader>以按键的便捷程度为依据去定义快捷键.
let mapleader = "\<Space>"
let localmapleader = "\<Bslash>"

let g:python3_host_prog = 'python'
let g:iswindows = 0
let g:ismac = 0
let g:iswsl = 0
let g:islinux = 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
elseif has('mac')
    let g:ismac = 1
else
    if filereadable('/mnt/c/Windows/explorer.exe') && stridx(tolower(expand('$path')), "/mnt/c/windows") >= 0
        let g:iswsl = 1
    endif
    let g:islinux = 1
endif
"得到当前脚本所在目录
"   1: Get the absolute path of the script
"   2: Resolve all symbolic links
"   3: Get the folder of the resolved absolute file
if has('nvim')
    let s:path = fnamemodify(resolve(expand('<sfile>:p')),':h')
else
    if g:iswindows
        let s:path = resolve(expand('~/vimfiles'))
    else
        let s:path = resolve(expand('~/.vim'))
    endif
endif

if g:iswsl
    " 如果想要删除变量,那么就键入`:unlet[!] g:clipboard`, 如果试图删除一个不存在的变量，那么Vim就会报错；而如果使用!标记，则不会显示错误信息
    " win32yank.exe在nvim所在目录,需要把它拷贝到wsl中: copy /mnt/c/tool/Neovim/bin/win32yank.exe /usr/local/bin/win32yank
    let g:clipboard = {
            \'name' : 'win32yank-wsl',
            \'copy' : {
            \     '+' : 'win32yank -i --crlf',
            \     '*' : 'win32yank -i --crlf'
            \},
            \'paste' : {
            \    '+' : 'win32yank -o --lf',
            \    '*' : 'win32yank -o --lf'
            \},
            \'cache_enabled' : 1
            \}
endif
nnoremap <silent><expr> <leader>le <SID>useLemonade(1)
nnoremap <silent><expr> <leader>lu <SID>useLemonade(0)
function! s:useLemonade(isUse)
    if a:isUse == 1
        if exists('g:clipboard')
            let g:clipboardOld_ = g:clipboard
        endif
        let g:clipboard = {
                \'name' : 'useLemonade',
                \'copy' : {
                \     '+' : 'lemonade copy',
                \     '*' : 'lemonade copy'
                \},
                \'paste' : {
                \    '+' : 'lemonade paste',
                \    '*' : 'lemonade paste'
                \},
                \'cache_enabled' : 1
                \}
        echo "useLemonade"
    else
        if exists('g:clipboardOld_')
            let g:clipboard = g:clipboardOld_
            echo "use clipboardOld"
        else
            unlet g:clipboard
            echo "unlet g:clipboard"
        endif
    endif
    call provider#clipboard#Executable()
endfunction

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" coc建议的配置,可是我不喜欢,我喜欢signcolumn=auto
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
"if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  "set signcolumn=number
"else
  "set signcolumn=yes
"endif
set signcolumn=auto
"""""""""""common set end

"""""""""""common user map or command begin
"保存修改, gs原来的含义是sleep 1秒钟,5gs是sleep 5秒钟
nnoremap <silent><nowait> gs :<C-u>w<CR>
nnoremap <nowait> <leader>/ :<C-u>let @/=''<CR>

" 原先的}和{只能跳转到空白行(只能有换行符的行)
" } - move ahead one paragraph (to the next empty line without any whitespace)
" { - move back one paragraph (to the next empty line without any whitespace)
" 参考自: [重新映射键以移动到下一个非空行（反之亦然）](https://stackoverflow.com/questions/40498194/vim-remap-key-to-move-to-the-next-non-blank-line-and-vice-versa)
"xnoremap <silent><nowait> } /^\s*$<CR>  " 这种方式不好,会高亮污染
"xnoremap <silent><nowait> } :<C-u>normal! gv<C-r>=search('\c^\s*$', 'W')<CR>gg<CR>  " 这种方式不好,只能定位一次,可能是因为在visual模式下的搜索是从选择的首行开始的
"nnoremap <silent><nowait> } :<C-u>call search('^\s*$', 'W')<CR>
"xnoremap <expr><silent><nowait> } <SID>findBlankLine(1)
"onoremap <expr><silent><nowait> } <SID>findBlankLine(1)
"nnoremap <silent><nowait> { :<C-u>call search('^\s*$', 'bW')<CR>
"xnoremap <expr><silent><nowait> { <SID>findBlankLine(0)
"onoremap <expr><silent><nowait> { <SID>findBlankLine(0)
"" <expr> 表示{rhs}是表达式，表达式的返回值，作为最后映射的按键序列
"function! s:findBlankLine(isNext)
    "let l:f = 'nW'
    "if a:isNext == 0
        "let l:f = l:f . 'b'
    "endif
    "let l:l = search('^\s*$', l:f)
    "if l:l == 0
        "return ""
    "endif
    "" 最后的字符'0'表示跳到行首, 很有必要, 因为可以避免在可视模式(非可视块模式)下的向上搜索的一些bug(比如不能定位到上一个空白行)
    "return l:l . 'gg0'
"endfunction

" 感觉还是把空白行的空白字符都删了比较好, 这样才是最满足vim之语义的, 从而vim的in a sentense或in a paragraph之类的就都可以用了, 所以把上面关于{和}的映射给注释掉了. DelBlanklineChars
command! -nargs=0 DblanklineChars :%s/\v^[ \t\r\n]+$//g
command! -nargs=0 CtagsUpdate :!ctags -R
command! -nargs=0 GtagsUpdate :Leaderf! gtags --update
command! -nargs=0 Lettime :let @+ = strftime('%Y/%m/%d %H:%M:%S')
" CocConfig用于打开coc-settings.json
command! -nargs=0 Myvimrc :tabnew $MYVIMRC
command -nargs=* Py :!python % <args>
"""""insert mode as Emacs key-mapping begin
" a应该是ahead的意思
" 保留vim之C-d的原始功能,就是反缩进,与C-t相对
" 尽量不要占用alt类的键位,因为要用alt模式,就是alt+字母=esc+字母
"inoremap <silent><nowait> <M-t> <C-d>
" 删除下一个字符
inoremap <silent><nowait> <C-d> <Del>
" 删除上一个字
"inoremap <silent><nowait> <M-Backspace> <C-w>
" 删除下一个字,删除至字尾
"inoremap <silent><nowait> <M-d> <C-o>ce
" 将光标移动到行首的第一个非空白字符
inoremap <silent><nowait> <M-m> <Esc><Esc>^i
noremap <silent><nowait> <M-m> ^
" 移到行首
inoremap <silent><nowait> <C-a> <Home>
" 移到行尾
inoremap <silent><nowait> <C-e> <End>
" 句首,从行首到句首之间可能有空格
"inoremap <silent><nowait> <M-a> <Esc><Esc>(i
" 句尾
"inoremap <silent><nowait> <M-e> <Esc><Esc>)gea
" 前进一个字,移动到下一个词首
"inoremap <silent><nowait> <M-f> <C-Right>
" 后退一个字,跳动到当前光标所在词的开头
"inoremap <silent><nowait> <M-b> <C-Left>
" 删除到行尾
inoremap <silent><nowait> <C-k> <C-o>C
" 删除这一句,M-k另有它用,注释掉吧.
"inoremap <silent><nowait> <M-k> <Esc><Esc>cis
" 前进一行
inoremap <silent><nowait> <C-n> <Down>
" 后退一行
inoremap <silent><nowait> <C-p> <Up>
" 文件首
"inoremap <silent><nowait> <M-<> <C-Home>
" 文件尾
"inoremap <silent><nowait> <M->> <C-End>
" 当前行居中
inoremap <silent><nowait> <C-l> <Esc><Esc>zza
" 向下翻页
"inoremap <silent><nowait> <C-v> <C-o><C-d>
" 向上翻页
"inoremap <silent><nowait> <M-v> <C-o><C-u>
" 粘贴至光标后
"inoremap <silent><expr> <C-y> <SID>insertModePaste()
inoremap <silent><nowait> <C-y> <C-r>+
" save
inoremap <silent><nowait> <C-x><C-s> <Esc><Esc>:<C-u>w<CR>a
" 撤销,快捷键不支持,那就算了,无所谓.
"inoremap <silent><nowait> <C-/> <C-o>u

" 用这个函数去粘贴,是不会自动格式化的,因为<C-r>+会自动格式化.
" 感觉还是<C-r>+的体验更好一些, 尤其是也支持vim-visual-multi下的复制
"function! s:insertModePaste()
    "let l:c = col('$')
    "if l:c == 1
        "return "\<Esc>\<Esc>gPa"
    "elseif col('.') == l:c
        "return "\<Esc>\<Esc>gpa"
    "else
        "return "\<Esc>\<Esc>gpi"
    "endif
"endfunction
"""""insert mode as Emacs key-mapping end

"""""Command-line editing begin
cnoremap <C-a> <Home>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
"cnoremap <M-f> <S-Right>
"cnoremap <M-b> <S-Left>
cnoremap <C-d> <Del>
"<C-r>=  可以计算一个表达式,比如输入`<C-r>=1+2`然后按回车,就会得到数字3
cnoremap <C-y> <C-r>+
"""""Command-line editing end

" C-i不是vim自带的,而是terminal自带的,就是说在按下tab和C-i时,terminal发给vim的数值是一样的
" [参考:Conflict Ctrl-I with TAB in normal
" mode](https://unix.stackexchange.com/questions/563469/conflict-ctrl-i-with-tab-in-normal-mode)
" C-i=Tab, M-i约等于Tab, 因为M-i只是单纯地产生Tab效果,不会被key-mapping的
inoremap <M-i> <Tab>

"function! s:hlsearchToggle()
    "if &hls == 1
        "setlocal nohls
    "else
        "setlocal hls
    "endif
    "return ''
"endfunction
"noremap <silent><expr> <leader>hl <SID>hlsearchToggle()

noremap <silent><nowait> <leader>lg :<C-u>LazyGit<CR>
" :te == :ter == :terminal
"command Tt :tabe|te
noremap <leader>te :<C-u>te<CR>
noremap <leader>ts :<C-u>belowright new<CR>:te<CR>
noremap <leader>tv :<C-u>botright vne<CR>:te<CR>
noremap <leader>tt :<C-u>tabe<CR>:te<CR>
" 不再需要vi这个快捷键,因为快捷命令已足够强大,有以下vifm相关命令:
" SplitVifm, VsplitVifm, TabVifm, Vifm, DiffVifm
noremap <leader>vs :<C-u>SplitVifm<CR>
noremap <leader>vv :<C-u>VsplitVifm<CR>
noremap <leader>vt :<C-u>TabVifm<CR>
noremap <leader>vi :<C-u>Vifm<CR>
noremap <leader>vd :<C-u>DiffVifm<CR>
"noremap <C-p> :<C-u>let @p = @+<CR>
"noremap <M-p> :<C-u>let @+ = @p<CR>

nnoremap <silent><nowait> <C-h> :<C-u>tabp<CR>
" C-l 本来是用来刷新的
nnoremap <silent><nowait> <C-l> :<C-u>tabn<CR>
"""""""""""common user map or command end

"""""""""""common script begin
function! s:getExplorer()
    if g:iswsl
        return 'wsl-open'
    elseif g:iswindows
        return 'explorer.exe'
    endif
    return 'open'
endfunction

" 打开网络浏览器
function! s:getExplorerNet()
    if g:iswindows
        return s:path . '/mycmd/expl2.bat'
    endif
    return s:getExplorer()
    if g:iswindows
        return s:path . '/mycmd/expl2.bat'
    elseif g:ismac
        return 'bash ' . s:path . '/mycmd/expl2_mac.sh'
    elseif g:iswsl
        return 'wsl-open '
    endif
    return 'bash ' . s:path . '/mycmd/expl2_linux.sh'
endfunction
let g:netrw_browsex_viewer=s:getExplorerNet()

" ZFVimIM setting
let g:ZFVimIM_keymap = 0 "不使用插件默认的快捷键
let g:ZFVimIM_cloudInitMode = 'forceAsync'
let g:ZFVimIM_cloudAsync_autoCleanup = 0
let g:ZFVimIM_dbIndex = 0
let g:ZFVimIM_cloudSync_enable = 0
let g:ZFVimIM_cloudAsync_autoInit = 1
let g:ZFVimIM_openapi_enable=0
" 关闭长句输入
let g:ZFVimIM_sentence = 0
" ZFVimIM在启动的情况下,会影响到CocList后面的自动补全, 而且弹出的面板没有任何符号, [问题相关描述](https://github.com/ZSaberLv0/ZFVimIM/issues/43)
let g:ZFVimIM_autoDisable_coc = 1
let g:ZFVimIME_enableOnInsertOnly = 1

" easymotion setting
" 日本用户才需要这个
let g:EasyMotion_use_migemo = 0
" type `l` and match `l`&`L`
let g:EasyMotion_smartcase = 1
" Smartsign (type `3` and match `3`&`#`)
let g:EasyMotion_use_smartsign_us = 1

" xtabline setting
let g:xtabline_settings = {}
let g:xtabline_settings.enable_mappings = 0

" sandwich setting
let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1

" signature setting
" DeleteMark原先的快捷键是dm, 感觉没必要, 而且会影响Leaderf的buffer窗口的d按键
let g:SignatureMap = {'DeleteMark': ''}

" auto-pairs setting
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutFastWrap = ''
let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutBackInsert = ''
let g:AutoPairsMoveCharacter = ''

" vim-textobj-comment setting
let g:loaded_textobj_comment = 1

" unimpaired setting
let g:nremap = { '[y': 0, ']y': 0, '[C': 0, ']C': 0, '[u': 0, ']u': 0, '[x': 0, ']x': 0 }
let g:xremap = g:nremap
"""""""""""markdown begin
" markdown setting
" Latex数学公式
let g:vim_markdown_math = 1
" [mac上实现markdown的预览](http://xiaqunfeng.cc/2017/05/25/mac-vim-markdown-preview/)
let g:mkdp_path_to_chrome=s:getExplorerNet()
let g:mkdp_auto_close=0
let g:mkdp_markdown_css=''
let g:vim_markdown_frontmatter=1
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_folding_style_pythonic = 0
let g:vim_markdown_folding_level = 0
let g:vim_markdown_no_default_key_mappings = 0
" 这个插件的conceal功能和indentLine插件的功能相冲突了吗?貌似没有吧,反正管用就行了
let g:vim_markdown_conceal = 2
" 这个控制新增行的新增空白,若是为0,表示只是跟上一行对齐即可,不再增加新的空白
let g:vim_markdown_new_list_item_indent = 0
function! s:setlocalTabstopWidth(n)
    "ps. 必须得用这种解析字符串的方式才行,否则会报错: '='号后面需要数字
    "应该是viml解析方面的bug吧
    exec 'setlocal tabstop=' . a:n
    exec 'setlocal softtabstop=' . a:n
    exec 'setlocal shiftwidth=' . a:n
endfunction
"au=autocmd
"au BufRead,BufNewFile *.{txt} setfiletype markdown
"autocmd BufRead,BufNewFile *.{md} call s:setlocalTabstopWidth(2)
autocmd FileType markdown call s:setlocalTabstopWidth(2)
" 还是不要自定义markdown的快捷键了,因为它有时在mac上不正常,而在linux下正常,用默认的快捷键就挺好的,默认的快捷键跟下面自定义的基本一致,除了不带<leader>
"function! s:MapNotHasmapto(lhs, rhs)
    "if !hasmapto('<Plug>' . a:rhs)
        "execute 'nmap <buffer>' . a:lhs . ' <Plug>' . a:rhs
        "execute 'vmap <buffer>' . a:lhs . ' <Plug>' . a:rhs
    "endif
"endfunction
"call <sid>MapNotHasmapto('<leader>]]', 'Markdown_MoveToNextHeader')
"call <sid>MapNotHasmapto('<leader>[[', 'Markdown_MoveToPreviousHeader')
"call <sid>MapNotHasmapto('<leader>][', 'Markdown_MoveToNextSiblingHeader')
"call <sid>MapNotHasmapto('<leader>[]', 'Markdown_MoveToPreviousSiblingHeader')
"" u-> Up
"call <sid>MapNotHasmapto('<leader>]u', 'Markdown_MoveToParentHeader')
"" h->Header
"call <sid>MapNotHasmapto('<leader>]h', 'Markdown_MoveToCurHeader')
"call <sid>MapNotHasmapto('gx', 'Markdown_OpenUrlUnderCursor')
" ps. 这个快捷键跟标准的冲突了,也不知道它是干什么用的,注释掉吧
"call <sid>MapNotHasmapto('ge', 'Markdown_EditUrlUnderCursor')
"""""""""""markdown end

" indentLine setting
let g:indentLine_enable = 1
let g:autopep8_disable_show_diff = 1
let g:indentLine_leadingSpaceEnabled = 1
let g:indentLine_leadingSpaceChar = "·"
"let g:indentLine_fileTypeExclude = []
set concealcursor=
let g:indentLine_concealcursor = ''

" git setting
let g:lazygit_use_neovim_remote = 1

" LanguageClient setting
let g:LanguageClient_serverCommands = {
    \ 'sh': ['bash-language-server', 'start']
    \ }

" open-url setting
let g:open_url_default_mappings = 0

" coc setting
" rust-analyzer安装步骤: 1. :CocInstall coc-rust-analyzer; 2. rustup component add rust-src; 3. 安装针对 Rust 的 LSP（rust-analyzer）. [参考](https://www.starky.ltd/2021/05/30/vim-configuration-with-coc-support-rust-c-python-complete/)
" 输入:CocList后,选择marketplace,可以查看所有插件
" [coc-settings.json关于语言服务器(language-server)的范例](https://github.com/neoclide/coc.nvim/wiki/Language-servers)
let g:coc_global_extensions = [
    \ 'coc-highlight', 'coc-vimlsp', 'coc-sh',
    \ 'coc-json', 'coc-marketplace', 'coc-clangd', 'coc-cmake',
    \ 'coc-pyright', 'coc-rust-analyzer', 'coc-go', 'coc-tsserver',
    \ 'coc-protobuf', 'coc-html-css-support']
" 也是为了解决: python.analysis.extraPaths, 会报这样的错误: [Pyright reportMissingImports] [E] Import "xxx" could not be resolved
" [Using workspaceFolders](https://github.com/neoclide/coc.nvim/wiki/Using-workspaceFolders#resolve-workspace-folder)
" Use command `:CocList folders` to open list of workspace folders
" Use command `:echo coc#util#root_patterns()` to get patterns used for resolve workspace folder of current buffer
" `:echo g:WorkspaceFolders`,去查看workspace folders
let b:coc_root_patterns = ['.vimroot']
autocmd FileType python let b:coc_root_patterns = ['.vimroot'] "这里不能注释,否则workspace folders会有问题,从而导致`Pyright reportMissingImports`之类的错误. 由此可猜想,workspace folders最好只有一个,否则可能会有莫名其妙的问题
"如果需要为某些语言指定特殊的根目录的话,比如可以像下面这样(.idea是pycharm为工作目录生成的)
"autocmd FileType python let b:coc_root_patterns = ['.idea']
let g:coc_enable_locationlist = 1

" table-mode setting
" 不需要这个功能,而且它的按键是<leader>tt, 存在冲突
let g:table_mode_disable_tableize_mappings = 1

" fzf setting
let g:fzf_command_prefix = 'FZ'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'belowright split',
  \ 'ctrl-v': 'botright vsplit' }
" [Buffers] 如果可能跳到已存在窗口
let g:fzf_buffers_jump = 1
" - Popup window (anchored to the bottom of the current window)
"let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 } }

" LeaderF setting
" [Leaderf gtags之作者写的一篇文章](https://zhuanlan.zhihu.com/p/64842373)
" [作者写的一篇文章,里面有关于rg相关的介绍](https://segmentfault.com/a/1190000017896650)
" don't show the help in normal mode
" leaderf弹出的窗口若一开始无法输入字符的话,那么按tab或i键可进入到可输入状态
" 正则(regex)之要求某行中不包含某个字符串: `\v^((string)@!.)*$`. [正则表达式匹配不包含某些字符串的技巧](https://blog.csdn.net/JHON_03/article/details/77899563)
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
" popup mode
"let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "DejaVu Sans Mono for Powerline" }
let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }
"pip install pygments
"[查看支持的语言](https://pygments.org/languages/)
"[global/gtags官方下载地址](https://ftp.gnu.org/pub/gnu/global/)
let g:Lf_Gtagslabel = 'native-pygments'
let $GTAGSLABEL = g:Lf_Gtagslabel
" 用~/.globalrc比较好,因为可以改配置
"let g:Lf_Gtagsconf = '/usr/local/share/gtags/gtags.conf'
"let $GTAGSCONF = g:Lf_Gtagsconf
"需要手动更新gtags数据库:`Leaderf gtags --update`. 当代码有更改并且已经有 gtags 数据库生成时，更改的代码会自动同步到 gtags 数据库（即使g:Lf_GtagsAutoGenerate是0）
let g:Lf_GtagsAutoGenerate = 0
" https://github.com/ludovicchabant/vim-gutentags
let g:Lf_GtagsGutentags = 0
let g:Lf_RootMarkers = b:coc_root_patterns
let g:Lf_WorkingDirectoryMode = 'Ac'
"let g:Lf_DefaultMode = 'NameOnly'
let g:Lf_DefaultMode = 'FullPath'
let g:Lf_CacheDirectory = $HOME
let g:Lf_DelimiterChar = ';'
" Leaderf之config并不会读$RIPGREP_CONFIG_PATH中的文件,而是会使用此处的
let g:Lf_RgConfig = [
    \ "--max-columns=650",
    \ "--follow",
    \ "--no-text",
    \ "--smart-case",
    \ "--auto-hybrid-regex",
    \ "--glob=!{.git/,.svn/,/stage/,/publish/,__pycache__/,tags}"
\ ]
let g:Lf_WildIgnore = {
    \ 'dir': ['/stage','/publish','__pycache__','.git','.svn'],
    \ 'file': ['tags']
    \}
let g:Lf_ShortcutF = "<leader>ff"
let g:Lf_ShortcutB = "<leader>fb"
let g:Lf_GtagsAcceptDotfiles = 0
let g:Lf_FollowLinks = 1
let g:Lf_GtagsSkipSymlink = 'f'
let g:Lf_JumpToExistingWindow = 1
" 感觉自动显示preview体验不大好
let g:Lf_PreviewResult = {'File': 0, 'Buffer': 0, 'Mru': 0, 'Tag': 0, 'BufTag': 0, 'Function': 0, 'Line': 0, 'Colorscheme': 0, 'Jumps': 0}
" C-Y: 粘贴, C-X: 切换搜索模式(正则表达式或FullPath),C-S: 水平分割,C-V:垂直分割
" C-A: 行首, C-D: 删除后一个字符, C-F: 向右移动一个字符, C-B: 向左移动一个字符
" C-P: 预览,这个很不错
let g:Lf_CommandMap = {'<C-X>': ['<C-S>'], '<C-]>': ['<C-V>'], '<C-V>': ['<C-Y>'], '<C-R>': ['<C-X>'],
    \ '<Home>': ['<C-A>'], '<Del>': ['<C-D>'], '<Right>': ['<C-F>'], '<Left>': ['<C-B>']}
let g:Lf_NormalMap = {
    \ "_": [["<C-j>", "j"],["<C-k>", "k"]],
    \ "File": [["<C-t>", ':exec g:Lf_py "fileExplManager.accept(\"t\")"<CR>'],
    \   ["<C-v>", ':exec g:Lf_py "fileExplManager.accept(\"v\")"<CR>'],
    \   ["<C-s>", ':exec g:Lf_py "fileExplManager.accept(\"h\")"<CR>']],
    \ "Buffer": [["<C-t>", ':exec g:Lf_py "bufExplManager.accept(\"t\")"<CR>'],
    \   ["<C-v>", ':exec g:Lf_py "bufExplManager.accept(\"v\")"<CR>'],
    \   ["<C-s>", ':exec g:Lf_py "bufExplManager.accept(\"h\")"<CR>']],
    \ "Mru": [["<C-t>", ':exec g:Lf_py "mruExplManager.accept(\"t\")"<CR>'],
    \   ["<C-v>", ':exec g:Lf_py "mruExplManager.accept(\"v\")"<CR>'],
    \   ["<C-s>", ':exec g:Lf_py "mruExplManager.accept(\"h\")"<CR>']],
    \ "Tag": [["<C-t>", ':exec g:Lf_py "tagExplManager.accept(\"t\")"<CR>'],
    \   ["<C-v>", ':exec g:Lf_py "tagExplManager.accept(\"v\")"<CR>'],
    \   ["<C-s>", ':exec g:Lf_py "tagExplManager.accept(\"h\")"<CR>']],
    \ "BufTag": [["<C-t>", ':exec g:Lf_py "bufTagExplManager.accept(\"t\")"<CR>'],
    \   ["<C-v>", ':exec g:Lf_py "bufTagExplManager.accept(\"v\")"<CR>'],
    \   ["<C-s>", ':exec g:Lf_py "bufTagExplManager.accept(\"h\")"<CR>']],
    \ "Function": [["<C-t>", ':exec g:Lf_py "functionExplManager.accept(\"t\")"<CR>'],
    \   ["<C-v>", ':exec g:Lf_py "functionExplManager.accept(\"v\")"<CR>'],
    \   ["<C-s>", ':exec g:Lf_py "functionExplManager.accept(\"h\")"<CR>']],
    \ "Line": [["<C-t>", ':exec g:Lf_py "lineExplManager.accept(\"t\")"<CR>'],
    \   ["<C-v>", ':exec g:Lf_py "lineExplManager.accept(\"v\")"<CR>'],
    \   ["<C-s>", ':exec g:Lf_py "lineExplManager.accept(\"h\")"<CR>']],
    \ "History": [["<C-t>", ':exec g:Lf_py "historyExplManager.accept(\"t\")"<CR>'],
    \   ["<C-v>", ':exec g:Lf_py "historyExplManager.accept(\"v\")"<CR>'],
    \   ["<C-s>", ':exec g:Lf_py "historyExplManager.accept(\"h\")"<CR>']],
    \ "Self": [["<C-t>", ':exec g:Lf_py "selfExplManager.accept(\"t\")"<CR>'],
    \   ["<C-v>", ':exec g:Lf_py "selfExplManager.accept(\"v\")"<CR>'],
    \   ["<C-s>", ':exec g:Lf_py "selfExplManager.accept(\"h\")"<CR>']],
    \ "Colorscheme": [["<C-t>", ':exec g:Lf_py "colorschemeExplManager.accept(\"t\")"<CR>'],
    \   ["<C-v>", ':exec g:Lf_py "colorschemeExplManager.accept(\"v\")"<CR>'],
    \   ["<C-s>", ':exec g:Lf_py "colorschemeExplManager.accept(\"h\")"<CR>']],
    \ "Window": [["<C-t>", ':exec g:Lf_py "windowExplManager.accept(\"t\")"<CR>'],
    \   ["<C-v>", ':exec g:Lf_py "windowExplManager.accept(\"v\")"<CR>'],
    \   ["<C-s>", ':exec g:Lf_py "windowExplManager.accept(\"h\")"<CR>']],
    \ "Jumps": [["<C-t>", ':exec g:Lf_py "jumpsExplManager.accept(\"t\")"<CR>'],
    \   ["<C-v>", ':exec g:Lf_py "jumpsExplManager.accept(\"v\")"<CR>'],
    \   ["<C-s>", ':exec g:Lf_py "jumpsExplManager.accept(\"h\")"<CR>']],
    \ "Command": [["<C-t>", ':exec g:Lf_py "commandExplManager.accept(\"t\")"<CR>'],
    \   ["<C-v>", ':exec g:Lf_py "commandExplManager.accept(\"v\")"<CR>'],
    \   ["<C-s>", ':exec g:Lf_py "commandExplManager.accept(\"h\")"<CR>']],
    \ "Filetype": [["<C-t>", ':exec g:Lf_py "filetypeExplManager.accept(\"t\")"<CR>'],
    \   ["<C-v>", ':exec g:Lf_py "filetypeExplManager.accept(\"v\")"<CR>'],
    \   ["<C-s>", ':exec g:Lf_py "filetypeExplManager.accept(\"h\")"<CR>']],
    \ "Gtags": [["<C-t>", ':exec g:Lf_py "gtagsExplManager.accept(\"t\")"<CR>'],
    \   ["<C-v>", ':exec g:Lf_py "gtagsExplManager.accept(\"v\")"<CR>'],
    \   ["<C-s>", ':exec g:Lf_py "gtagsExplManager.accept(\"h\")"<CR>']],
    \ "Help": [["<C-t>", ':exec g:Lf_py "helpExplManager.accept(\"t\")"<CR>'],
    \   ["<C-v>", ':exec g:Lf_py "helpExplManager.accept(\"v\")"<CR>'],
    \   ["<C-s>", ':exec g:Lf_py "helpExplManager.accept(\"h\")"<CR>']],
    \ "QfLocList": [["<C-t>", ':exec g:Lf_py "qfloclistExplManager.accept(\"t\")"<CR>'],
    \   ["<C-v>", ':exec g:Lf_py "qfloclistExplManager.accept(\"v\")"<CR>'],
    \   ["<C-s>", ':exec g:Lf_py "qfloclistExplManager.accept(\"h\")"<CR>']],
    \ "Rg": [["<C-t>", ':exec g:Lf_py "rgExplManager.accept(\"t\")"<CR>'],
    \   ["<C-v>", ':exec g:Lf_py "rgExplManager.accept(\"v\")"<CR>'],
    \   ["<C-s>", ':exec g:Lf_py "rgExplManager.accept(\"h\")"<CR>']]
    \}

"vimspector setting
"Run :VimspectorInstall and the 4 adapters should be installed
"vscode-go needs [delve](https://github.com/go-delve/delve) to be installed. mac: brew install delve
let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-go', 'CodeLLDB', 'vscode-node-debug2' ]

" itchyny/lightline.vim
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'method' ] ]
      \ },
      \ 'component_function': {
      \   'method': 'NearestMethodOrFunction'
      \ },
      \ }

" *********** vista setting
" How each level is indented and what to prepend.
" This could make the display more compact or more spacious.
" e.g., more compact: ["▸ ", ""]
" Note: this option only works for the kind renderer, not the tree renderer.
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
" Executive used when opening vista sidebar without specifying it.
" See all the avaliable executives via `:echo g:vista#executives`.
"let g:vista_default_executive = 'ctags'
let g:vista_default_executive = 'coc'
" Set the executive for some filetypes explicitly. Use the explicit executive
" instead of the default one for these filetypes when using `:Vista` without
" specifying the executive.
let g:vista_executive_for = {
  \ 'cpp': 'coc',
  \ 'py': 'coc',
  \ }
" Declare the command including the executable and options used to generate ctags output
" for some certain filetypes.The file path will be appened to your custom command.
" For example:
let g:vista_ctags_cmd = {
      \ 'haskell': 'hasktags -x -o - -c',
      \ }
" To enable fzf's preview window set g:vista_fzf_preview.
" The elements of g:vista_fzf_preview will be passed as arguments to fzf#vim#with_preview()
" For example:
let g:vista_fzf_preview = ['right:50%']
" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista#renderer#enable_icon = 1
" The default icons can't be suitable for all the filetypes, you can extend it as you wish.
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }
"""""""""""common script end

"""""""""""plug begin
" [plug.vim](https://github.com/junegunn/vim-plug)
" plug.vim可以设置git仓库的格式
" let g:plug_url_format = 'https://github.com/%s.git'
" let g:plug_url_format = 'https://github.com.cnpmjs.org/%s.git'
" 国内镜像源
" let g:plug_url_format = 'https://hub.fastgit.org/%s.git'
" let g:plug_url_format = 'https://codechina.csdn.net/mirrors/%s.git'
" let g:plug_url_format = 'https://gitee.com/mirrors/%s.git'
" 这种ssh格式貌似不容易被墙
let g:plug_url_format = 'git@github.com:%s.git'

call plug#begin(s:path . '/plugged')
" npm i -g bash-language-server
"Plug 'autozimu/LanguageClient-neovim'
Plug 'neoclide/coc.nvim', {'branch': 'release'} " 代码补全、静态检测、函数跳转
Plug 'vifm/vifm.vim'
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' } " 文件浏览器, 类似nerdtree,coc-explorer
"下面三个插件显示dev图片,还是注释掉吧,没必要显示图标,没意思
"Plug 'ryanoasis/nerd-fonts' " github上下载太慢了
"Plug 'https://gitee.com/keyboardkiller/nerd-fonts.git'
"Plug 'ryanoasis/vim-devicons' " 这个插件貌似没什么用,好像有时还会有乱码问题
"Plug 'kristijanhusak/defx-icons'   " defx的图标,defx-icons 依赖
"nerd-fonts,美化类的东西似乎是没多大必要的
"需要手动更新gtags数据库:`Leaderf gtags --update`
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' } " 文件模糊查找器,类似fzf.vim. ff:检索文件,fb:检索buffer,c-c或<esc>:退出,c-r:在模糊匹配和正则匹配之间切换,c-f:在全路径搜索和名字搜索之间切换,tab:在检索模式和选择模式之间切换. 记得安装这个,运行速度会更快些`:LeaderfInstallCExtension`.运行完任何一个LeaderF命令后,`:echo g:Lf_fuzzyEngine_C`如果输出为1,则表示安装成功了.
" [fzf之vim下的安装方式](https://github.com/junegunn/fzf/blob/master/README-VIM.md)
" 2022/05/12 13:24:04, fzf已被leaderf完全取代
"if g:ismac
    "Plug '/usr/local/opt/fzf'
"elseif g:islinux
    "Plug '/usr/share/doc/fzf/examples'
"elseif g:iswindows
    "Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
"endif
"Plug 'junegunn/fzf.vim'
"Plug 'altercation/vim-colors-solarized' " 主题
Plug 'morhetz/gruvbox'  " 主题/配色方案,还是这个主题舒服
"Plug 'tomasr/molokai' " 黑客主题
Plug 'puremourning/vimspector'  " 调试器, debug
"Plug 'SirVer/ultisnips'    " 代码片段插件 ps. 貌似coc里有类似的插件的
Plug 'mg979/vim-xtabline'   " 精致的顶栏,F5可切换模式
Plug 'dhruvasagar/vim-table-mode'   " vim表模式插件,在插入模式输入||即可进入该模式
"Plug 'mbbill/undotree'  " 强大的撤销更改功能
Plug 'mg979/vim-visual-multi', {'branch': 'master'} " 多光标选择,类似vim-multiple-cursors,C-n选择一个单词
Plug 'machakann/vim-sandwich'   " 添加包裹符号,类似vim-surround.sa新增环线,sr修改,sd删除,t表示标签
Plug 'junegunn/vim-easy-align'  " 根据符号对齐文本,类似tabular,比如gaip=
"Plug 'vim-autoformat/vim-autoformat'    " 自动格式化插件,被CocFormat所替代
"Plug 'godlygeek/tabular'       " 对齐插件,'plasticboy/vim-markdown'依赖它,但我更喜欢easy-align
Plug 'plasticboy/vim-markdown'  " 提供了针对Markdown的语法高亮，段落折叠，查看目录，段间跳转等功能
Plug 'mzlogin/vim-markdown-toc' " 为Markdown文件生成目录
" markdown-preview.nvim,需要到这个插件目录里再执行一下编译之类的动作才行
" 通过浏览器实时预览Markdown 文件。并可以借助浏览器的打印功能导出PDF文档. 附带了Latex预览，Mermaid甘特图，Plantuml UML图等. 首次安装的话，需要先装nodejs和yarn,安装yarn:`npm i -g yarn`，然后在`.config\nvim\plugged\markdown-preview.nvim\app`目录下执行`npm install`或`yarn install`.所以这条命令应该可以不用再执行了:`:call mkdp#util#install()`.
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'easymotion/vim-easymotion'    " 快速跳转
" 打开函数与变量列表,类似tagbar,<leader>ou打开或关闭outline
" zm,zr,zc,zo,za之类的折叠功能是可以用的,如此一来便方便多了
Plug 'liuchengxu/vista.vim'
" m<space> 去除所有标记
Plug 'kshenoy/vim-signature'    " 书签
Plug 'brooth/far.vim'   " 查找与替换,在多个文件里搜索与替换
Plug 'airblade/vim-gitgutter'   " git侧边栏插件
Plug 'kdheepak/lazygit.nvim'
"[Using Vim or NeoVim as a Git mergetool](https://www.grzegorowski.com/using-vim-or-neovim-nvim-as-a-git-mergetool)
"When in the central window use d2o or d3o to pull changes from LOCAL or REMOTE file.
Plug 'tpope/vim-fugitive' " Gdiff之类的可以合并冲突
Plug 'gcmt/wildfire.vim'    " 按回车<CR>快速选择整个标签范围,<BS>反向选择. 类似vim-expand-region
"This plugin provides text object mappings ib and ab
"ib is a union of i(, i{, i[, i', i" and i<
"ab is a union of a(, a{, a[, a', a" and a<
Plug 'kana/vim-textobj-user' "vim-textobj-anyblock依赖此插件
Plug 'rhysd/vim-textobj-anyblock'
Plug 'kana/vim-textobj-line'
" n->note, 也即注释的意思. 不能用c,因为c是class的意思,已被coc占用
Plug 'glts/vim-textobj-comment'
Plug 'kana/vim-textobj-indent'
" scrooloose/nerdcommenter难道就是preservim/nerdcommenter?
Plug 'preservim/nerdcommenter'  " 快速注释插件,类似vim-commentary.cc:注释,cu:解注释,c<space>:智能判断,cy:先复制再注释,ca:转换注释方式,cA:跳到行尾加注释,cs:性感注释(就是/****/的注释),cm:NERDCommenterMinimal就是/**/的注释,c$:注释当前光标到行尾
"Plug 'bling/vim-airline'   " vim的底部状态增强/美化插件,即状态栏
Plug 'itchyny/lightline.vim' " 状态栏,用于vista.vim,还是这个好用,主要是实用
Plug 'Yggdroot/indentLine'  " 可视化缩进
Plug 'luochen1990/rainbow' " 嵌套括号高亮
"gB: Open url under cursor in the default web browser.
"g<CR>: Search word under cursor using default search engine
"gG: Google search word under cursor in the default web browser
"gW: Wikipedia search word under cursor in the default web browser
Plug 'dhruvasagar/vim-open-url'
"输入法
Plug 'ZSaberLv0/ZFVimIM'
Plug 'ZSaberLv0/ZFVimJob' "用于提升词库加载性能
"Plug 'ZSaberLv0/ZFVimGitUtil' " optional, cleanup your db commit history when necessary
"Plug 'ZSaberLv0/ZFVimIM_wubi_base'
" must after easymotion plugin, 支持搜索中文.not work for <Plug>(easymotion-s2)
Plug 'ZSaberLv0/vim-easymotion-chs'
Plug 'persytry/ZFVimIM_wubi_base'
" :let g:ZFVimIM_DEBUG_profile = 1
" :call ZFVimIM_DEBUG_checkHealth() 或 call ZFVimIM_DEBUG_profileInfo()     " 可查看日志输出
" :ZFProfileStart   " 也可以用这个命令,然后重启vim可查看日志输出到的文件
Plug 'ZSaberLv0/ZFVimUtil'
"Plug 'persytry/t-vim-git_batch', { 'dir': '~/.git_batch' }
Plug 'jeroenbourgois/vim-actionscript'
" 参考: [神级编辑器 Vim 使用 - 插件篇](https://www.hanleylee.com/usage-of-vim-editor-plugin.html)
Plug 'tpope/vim-unimpaired' " 一个映射了大量实用命令的插件, 主要前缀键是[与]
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-repeat'  " 支持重复
call plug#end()

"""""common plug set begin
let g:solarized_termcolors=256
let g:solarized_termtrans=0
let g:gruvbox_termcolors=256
"set term=screen-256color
"set t_Co = 256
"colorscheme solarized
colorscheme gruvbox
"colorscheme molokai
"set background=dark
set background=light
"光标的颜色设置是在终端中的,光标的背景颜色统一为橙色(orange,#FF9300,rgb(255,147,0)).
highlight Cursor ctermbg=white
"""""common plug set end
"""""""""""plug end

"""""""""""far begin
let g:far#enable_undo=1
" :Far {pattern} {replace-with} {file-mask} [params]. Find the text to replace.
" :F {pattern} {file-mask} [params]. Find only.
" :Far {pattern} {replace-with} **/*.py  " 在当前目录及子目录下的所有py文件中查找与替换
" :Far {pattern} {replace-with} **/*  " 在当前目录及子目录下的所有文件中查找与替换
" :Fardo [params]. Runs the replacement task. The shortcut for it is s (substitute).
" :Farundo [params]. Undo the recurrent replacement. The shortcut for it is u (undo).
"""""""""""far end

"""""""""""defx begin
"let g:defx_icons_enable_syntax_highlight = 1
call defx#custom#option('_', {
      \ 'winwidth': 30,
      \ 'split': 'vertical',
      \ 'direction': 'topleft',
      \ 'show_ignored_files': 0,
      \ 'buffer_name': '',
      \ 'toggle': 1,
      \ 'resume': 1
      \ })

" [vim插件defx配置成类似ranger风格](https://blog.csdn.net/lxyoucan/article/details/117549842)
" vifm style. w是window的简称
nnoremap <silent> <leader>wf :<C-u>Defx -listed -resume
      \ -columns=indent:mark:icon:icons:filename:git:size
      \ -buffer-name=tab`tabpagenr()`
      \ `expand('%:p:h')` -search=`expand('%:p')`<CR>
autocmd FileType defx call s:defx_my_settings()
    function! s:defx_my_settings() abort
      nnoremap <silent><buffer><expr> yy
      \ defx#do_action('copy')
      nnoremap <silent><buffer><expr> dd
      \ defx#do_action('move')
      nnoremap <silent><buffer><expr> p
      \ defx#do_action('paste')
      " 用drop而不用open,因为对于同一个文件,drop只会打开一次,而open会重复打开
      nnoremap <silent><buffer><expr> l
      \ defx#do_action('drop') "在当前tab的窗口中打开文件
      nnoremap <silent><buffer><expr> <CR>
      \ defx#do_action('drop') "在当前tab的窗口中打开文件
      nnoremap <silent><buffer><expr> <C-v>
      \ defx#do_action('drop', 'botright vnew') "在最右侧窗口打开文件
      nnoremap <silent><buffer><expr> <C-s>
      \ defx#do_action('drop', 'belowright new') "在最下侧窗口打开文件
      nnoremap <silent><buffer><expr> <C-t>
      \ defx#do_action('drop', '$tabnew') " 在新的tab中打开文件
      nnoremap <silent><buffer><expr> zo
      \ defx#do_action('open_tree')
      nnoremap <silent><buffer><expr> zc
      \ defx#do_action('close_tree')
      nnoremap <silent><buffer><expr> <leader>nd
      \ defx#do_action('new_directory')
      nnoremap <silent><buffer><expr> <leader>nf
      \ defx#do_action('new_file')
      nnoremap <silent><buffer><expr> C
      \ defx#do_action('toggle_columns',
      \                'mark:indent:icon:filename:type:size:time')
      nnoremap <silent><buffer><expr> S
      \ defx#do_action('toggle_sort', 'time')
      nnoremap <silent><buffer><expr> DD
      \ defx#do_action('remove')
      nnoremap <silent><buffer><expr> cw
      \ defx#do_action('rename', 'append')
      nnoremap <silent><buffer><expr> !
      \ defx#do_action('execute_command')
      nnoremap <silent><buffer><expr> x
      \ defx#do_action('execute_system')
      nnoremap <silent><buffer><expr> yf
      \ defx#do_action('yank_path')
      nnoremap <silent><buffer><expr> za
      \ defx#do_action('toggle_ignored_files')
      nnoremap <silent><buffer><expr> ;
      \ defx#do_action('repeat')
      nnoremap <silent><buffer><expr> h
      \ defx#do_action('cd', ['..'])
      nnoremap <silent><buffer><expr> ~
      \ defx#do_action('cd')
      nnoremap <silent><buffer><expr> q
      \ defx#do_action('quit')
      nnoremap <silent><buffer><expr> v
      \ defx#do_action('toggle_select') . 'j'
      nnoremap <silent><buffer><expr> V
      \ defx#do_action('toggle_select_all')
      nnoremap <silent><buffer><expr> j
      \ line('.') == line('$') ? 'gg' : 'j'
      nnoremap <silent><buffer><expr> k
      \ line('.') == 1 ? 'G' : 'k'
      nnoremap <silent><buffer><expr> <C-l>
      \ defx#do_action('redraw')
      nnoremap <silent><buffer><expr> <C-g>
      \ defx#do_action('print')
      nnoremap <silent><buffer><expr> cd
      \ defx#do_action('change_vim_cwd') " Current Working Directory
      nnoremap <silent><buffer><expr> <C-p>
      \ defx#do_action('preview')
    endfunction

call defx#custom#column('icon', {
      \ 'directory_icon': '▸',
      \ 'opened_icon': '▾',
      \ 'root_icon': ' ',
      \ })

call defx#custom#column('git', 'indicators', {
  \ 'Modified'  : 'M',
  \ 'Staged'    : '✚',
  \ 'Untracked' : '✭',
  \ 'Renamed'   : '➜',
  \ 'Unmerged'  : '═',
  \ 'Ignored'   : '☒',
  \ 'Deleted'   : '✖',
  \ 'Unknown'   : '?'
  \ })
"""""""""""defx end

"""""""""""coc begin
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" 若是不想选择补全,而是想要纯粹的tab效果,那么就用<M-i>
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
" 这个快捷键是windows风格的,没什么卵用
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" ctrl+\ to trigger completion, 即触发自动补全菜单
"inoremap <silent><expr> <C-Bslash> coc#refresh()
inoremap <silent><expr> <C-Bslash> pumvisible() ? "\<C-e>" : coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
"按回车自动选择最合适的那个,在弹出补全菜单的时候,不想选择而只想换行,就可以按<C-j>换行
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

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

" 解决easymotion和coc冲突的问题
let g:easymotion#is_active = 0
function! s:easyMotionCoc() abort
  if EasyMotion#is_active()
    let g:easymotion#is_active = 1
    silent! CocDisable
  else
    if g:easymotion#is_active == 1
      let g:easymotion#is_active = 0
      silent! CocEnable
    endif
  endif
endfunction
autocmd TextChanged,CursorMoved * call s:easyMotionCoc()
" Highlight the symbol and its references when holding the cursor.
" 即光标选择一个符号后,过一会高亮光标所在符号
function! s:cocActionHighlight()
    if exists('*CocActionAsync') && g:easymotion#is_active == 0
        call CocActionAsync('highlight')
    endif
endfunction
autocmd CursorHold * silent call s:cocActionHighlight()

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
" 格式化的话,我喜欢用vim自带的==
xmap <leader>=  <Plug>(coc-format-selected)
nmap <leader>=  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
" qf: QuickFix
nmap <leader>qf  <Plug>(coc-fix-current)
" Run the Code Lens action on the current line.
" CodeLens(代码信息指示器)是VS Code的一个功能，它可通过代码旁边的链接提供上下文感知的操作。当VS Code在代码中检测到测试注释时，它将在注释旁边提供“Run Test”链接和“Debug Test”链接，以便您快速进行操作而不需跳出代码. 它还可以动态提供一些有用的数据：单元测试结果、更改历史、工作项历史
nmap <leader>co  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
" 2022/04/30 20:40:18, CocFormat格式化由各个语言服务提供,比如想要为每个大括号单独放置在一行:
" typescript.format.placeOpenBraceOnNewLineForFunctions": true,
" typescript.format.placeOpenBraceOnNewLineForControlBlocks": true,
" javascript.format.placeOpenBraceOnNewLineForFunctions": true,
" javascript.format.placeOpenBraceOnNewLineForControlBlocks": true,
" CocFormat == CocCommand editor.action.formatDocument
command! -nargs=0 CocFormat :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Cocfold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 CocOrganize   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" -N, --number-select: Type a line number to select an item and invoke the default action on insert mode. Type `0` to select the 10th line.
" Show all diagnostics. p是pop式窗口的简称. o->coc中的o
nnoremap <silent><nowait> <leader>od  :<C-u>CocList diagnostics<cr>
" Manage extensions. ?: 表示无效插件, *: 表示插件已激活, +: 表示插件加载成功, -: 表示插件已禁止
nnoremap <silent><nowait> <leader>oe  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <leader>oc  :<C-u>CocList commands<cr>
" Find symbol of current document. f->fn, function中的f
nnoremap <silent><nowait> <leader>of  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <leader>os  :<C-u>CocList -I symbols<cr>
" Do default action for next item. 当前已执行过一个coc命令,现在执行CocList中的下一个. c是CoC的简称
nnoremap <nowait> <leader>oj  :<C-u>CocNext<CR>
" Do default action for previous item. 当前已执行过一个coc命令,现在执行CocList中的上一个
nnoremap <nowait> <leader>ok  :<C-u>CocPrev<CR>
" Resume latest coc list. a->awake之意
nnoremap <silent><nowait> <leader>oa  :<C-u>CocListResume<CR>
" by persy below
" jump to next symbol
nnoremap <silent><nowait> <C-j> :<C-u>CocCommand document.jumpToNextSymbol<CR>
" jump to previous symbol
nnoremap <silent><nowait> <C-k> :<C-u>CocCommand document.jumpToPrevSymbol<CR>

" C-t, C-]
" :h tagfunc, [CocTagFunc jump in new tab or existed tab](https://github.com/neoclide/coc.nvim/issues/3823)
set tagfunc=CocTagFunc
" [vim: Open tag in new tab](https://stackoverflow.com/questions/6069279/vim-open-tag-in-new-tabK)
nnoremap <silent> <leader><C-]> <C-w><C-]><C-w>T

" coc-list-mappings, 文档关键字, 用来查看快捷键, Default mappings on insert mode
" <C-o>       - Change to normal mode.
" coc-list-mappings-custom, 在coc-settings.json中改键

" 用于coc-settings.json. 自定义函数,命令等,首字母必须大写
function! MyCocDefaultAction(coc)
    "echomsg a:coc
    if a:coc.name == 'commands'
        return 'run'
    endif
    return 'drop'
endfunction
"""""""""""coc end

"""""""""""table mode begin
let g:table_mode_corner = '|'
let g:table_mode_border=0
let g:table_mode_fillchar=' '

function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'
"""""""""""table mode end

"""""""""""easy align begin
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
"""""""""""easy align end

"""""""""""easymotion begin
map <silent> <Plug>(easymotion-prefix)h <Plug>(easymotion-linebackward)
map <silent> <Plug>(easymotion-prefix)l <Plug>(easymotion-lineforward)
" 重复上次动作
map <silent> <Plug>(easymotion-prefix). <Plug>(easymotion-repeat)
" 默认的双向search需要提供一个字符,而我感觉两个字符比较合适,c就是char的简称
map <silent> <Plug>(easymotion-prefix)c <Plug>(easymotion-s2)
hi EasyMotionTarget2First ctermbg=none ctermfg=red
hi EasyMotionTarget2Second ctermbg=none ctermfg=blue
"""""""""""easymotion end

"""""""""""indentLine begin
" [打开json文件不显示双引号](https://www.zhihu.com/question/446071046/answer/1757604306)
" :verbose set conceallevel
" 用下面的方式是不行的,当先打开json文件后,再打开python文件,会导致python的indentLine也不可用了. 也可以考虑用`g:indentLine_fileTypeExclude`的方式
"autocmd FileType json,markdown let g:indentLine_conceallevel = 0 " indentLine
"autocmd FileType json,markdown let g:vim_json_syntax_conceal = 0 " vim-json
" il-> IndentLine. is-> IndentlineSpace
"let s:my_conceallevel = &conceallevel
"let s:my_conceallevel_old = 0
"function! s:myIndentLinesToggle()
    "execute 'setlocal conceallevel=' . s:my_conceallevel_old
    "execute 'IndentLinesToggle'
    "let s:my_conceallevel_old = s:my_conceallevel
    "let s:my_conceallevel = &conceallevel
    "return ''
"endfunction
"2022/05/24 22:35:01, 这两个老早就注释掉了
"nnoremap <silent><nowait><expr> <leader>il <SID>myIndentLinesToggle()
"xnoremap <silent><nowait><expr> <leader>il <SID>myIndentLinesToggle()
"2022/05/24 22:35:13, 下面4个不常用,就注释掉吧
"nnoremap <silent><nowait> <leader>il :<C-u>IndentLinesToggle<CR>
"xnoremap <silent><nowait> <leader>il :<C-u>IndentLinesToggle<CR>
"nnoremap <silent><nowait> <leader>is :<C-u>LeadingSpaceToggle<CR>
"xnoremap <silent><nowait> <leader>is :<C-u>LeadingSpaceToggle<CR>
"""""""""""indentLine end

"""""""""""rainbow begin
let g:rainbow_active = 1
let g:rainbow_conf = {
    \   'ctermfgs': ['blue', 'red', 'green', 'brown'],
    \   'separately': {
    \       'typescript': {
    \           'parentheses_options': 'containedin=typescriptBlock,typescriptFuncCallArg,typescriptClassBlock',
    \       },
    \   },
    \}

"""""""""""rainbow end

"""""""""""vimspector begin, debug
"let g:vimspector_enable_mappings = 'VISUAL_STUDIO' "mac下ctrl和shift无法和F1-F12的键组合在一起使用
nmap <F5>         <Plug>VimspectorContinue
nmap <leader><F5> <Plug>VimspectorStop
nmap <F6>         <Plug>VimspectorRestart
nmap <leader><F6> <Plug>VimspectorPause
nmap <F9>         <Plug>VimspectorToggleBreakpoint
nmap <leader><F9> <Plug>VimspectorToggleConditionalBreakpoint
"这个应该是通过一个表达式然后下断点的方式吧
nmap <leader><leader><F9> <Plug>VimspectorAddFunctionBreakpoint
nmap <F10>        <Plug>VimspectorStepOver
nmap <leader><F10> <Plug>VimspectorRunToCursor
nmap <F11>        <Plug>VimspectorStepInto
nmap <leader><F11> <Plug>VimspectorStepOut
nmap <F12> <Plug>VimspectorUpFrame
nmap <leader><F12> <Plug>VimspectorDownFrame
" Evaluate expression under cursor (or visual) in popup
" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval
"退出调试
nmap <Leader>dq :<C-u>VimspectorReset<CR>
"""""""""""vimspector end

"""""""""""vista begin
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

set statusline+=%{NearestMethodOrFunction()}

" By default vista.vim never run if you don't call it explicitly.
"
" If you want to show the nearest function in your statusline automatically,
" you can add the following line to your vimrc
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

nnoremap <silent><nowait> <leader>ou :<C-u>Vista!!<cr>
autocmd FileType vista,vista_kind nnoremap <buffer> <silent> <C-p> :<c-u>call vista#cursor#TogglePreview()<CR>
autocmd FileType vista,vista_kind nnoremap <buffer> <silent> <C-j> j
autocmd FileType vista,vista_kind nnoremap <buffer> <silent> <C-k> k
"""""""""""vista end

"""""""""""LeaderF begin
noremap <leader>fm :<C-U>LeaderfMruCwd<CR>
noremap <leader>fM :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <leader>fT :<C-U>LeaderfBufTagAll<CR>
noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>
noremap <leader>fn :<C-U><C-R>=printf("Leaderf function %s", "")<CR><CR>
noremap <leader>fN :<C-U>LeaderfFunctionAll<CR>
noremap <leader>fh :<C-U><C-R>=printf("Leaderf help %s", "")<CR><CR>
noremap <leader>fw :<C-U><C-R>=printf("Leaderf window %s", "")<CR><CR>
noremap <leader>fc :<C-U><C-R>=printf("Leaderf cmdHistory %s", "")<CR><CR>
noremap <leader>fC :<C-U><C-R>=printf("Leaderf command %s", "")<CR><CR>
"a->awake之意
noremap <leader>fa :<C-U><C-R>=printf("Leaderf! --recall %s", "")<CR><CR>

" FZRg用的是fzf的功能,与Leaderf rg功能差不多,但是leaderf的界面更友好一些
" noremap <leader>rg :<C-u>FZRg<CR>
noremap <leader>rg :<C-U><C-R>=printf("Leaderf rg --match-path %s", "")<CR><CR>
" Leaderf和Leaderf!的区别是,不加!则弹框可输入,加!则弹框不可输入
" -e就是--regexp,就是正则表达式(The input string is the same as the Vim's regexp),当Leaderf! rg后面有更多的参数的时候,默认是正则表达式搜索. -e选项必须放在最后,否则会出错
" 在当前文件中查找. 如果想要搜某个单词,就这样: Leaderf! rg --current-buffer -e '\bword\b'
" 也可以用-w选项,表示全字匹配(就是匹配单词边界)
" 如果搜索内容有空格或特殊字符的话, 也得加单引号或双引号
" 默认开启了--smart-case选项
" 输入Leaderf rg -h可查看帮助
"-e <PATTERN> 正则表达式搜索
"-F,--fixed-strings 搜索字符串而不是正则表达式
"-w 搜索只匹配有边界的词
"-t <TYPE>..., --type <TYPE>... Only search files matching TYPE. Multiple type flags may be provided. 比如只在python 文件中搜索的话,就输入-t py
"--match-path          Match the file path when fuzzy searching.
noremap <leader>rS :<C-U><C-R>=printf("Leaderf rg --current-buffer %s ", expand("<cword>"))<CR>
" 在工作目录下查找, 即全局查找
noremap <leader>rs :<C-U><C-R>=printf("Leaderf rg %s ", expand("<cword>"))<CR>
" 在本文件中搜索可视模式下选择的文本
xnoremap <leader>rV :<C-U><C-R>=printf("Leaderf rg --current-buffer -F -w %s ", leaderf#Rg#visual())<CR>
" search visually selected text literally, 全局搜索可视模式下选择的文本
xnoremap <leader>rv :<C-U><C-R>=printf("Leaderf rg -F -w %s ", leaderf#Rg#visual())<CR>
" 这个命令是在LeaderF窗口关闭的情况下,召回最后的搜索结果. a->awake之意.
noremap <leader>ra :<C-U>Leaderf! rg --recall<CR>

"--auto-jump [<TYPE>] 意思是如果只有一个结果直接跳过去
"更新. 必须得在根目录下创建.vim文件夹作为根目录,否则更新会失败的
" instead of GtagsUpdate command
"noremap <leader>gu :<C-u><C-r>=printf("Leaderf! gtags --update %s", "")<CR>
"Show locations of definitions. 跳转到定义
noremap <leader>gd :<C-U><C-R>=printf("Leaderf gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
"Show reference to a symbol which has definitions. 查找引用
noremap <leader>gr :<C-U><C-R>=printf("Leaderf gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
"Show reference to a symbol which has no definition. 不知道这个功能是干嘛的
noremap <leader>gs :<C-U><C-R>=printf("Leaderf gtags -s %s --auto-jump", expand("<cword>"))<CR><CR>
"Show all lines which match to the <PATTERN>. -g功能已被Leaderf rg包含
"noremap <leader>gg :<C-U><C-R>=printf("Leaderf gtags -g %s --auto-jump", expand("<cword>"))<CR><CR>
"Decide tag type by context at cursor position. If the context is a definition of the pattern then use -r, else if there is at least one definition of the pattern then use -d, else use -s. Regular expression is not allowed for pattern.
noremap <leader>gc :<C-U><C-R>=printf("Leaderf gtags --by-context %s --auto-jump", "")<CR><CR>
"跳转到下一个位置
noremap <leader>gj :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
"跳转到上一个位置
noremap <leader>gk :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
"恢复窗口,a->awake
noremap <leader>ga :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
"""""""""""LeaderF end

"""""""""""open-url begin
call open_url#engines#add('baidu', 'https://www.baidu.com/s?wd=%s') " 这一句要放在let语句的前面,因为如果不执行这句,open-url就不会去初始化,那么这些let语句就会被open-url的初始化语句给冲刷掉,相当于没写let语句
let g:open_url_browser_default=s:getExplorerNet()
let g:open_url#engines#default = 'baidu'
nmap gB <Plug>(open-url-browser)
xmap gB <Plug>(open-url-browser)
"""""""""""open-url end

"""""""""""ZFVimIM begin
" [和]能够从一个词组里面选出一个字出来,非常有意思
" 底线模式无法用这个输入法是个遗憾,不过还好了,因为插入和普通模式是最频繁的,底线模式一般也不需要搜中文.
inoremap <expr><silent> <C-]> ZFVimIME_keymap_toggle_i()

function! s:myVimIME_SelectLabel(c, n)
    if mode() != 'i'
        return a:c
    endif
    if pumvisible()
        call ZFVimIME_label(a:n)
        return ''
    endif
    return a:c
endfunction

function! s:myVimIME_LabelWithSymbol(c)
    if mode() != 'i'
        return a:c
    endif
    if pumvisible()
        call ZFVimIME_label(1)
        call feedkeys(a:c, 'nt')
        return ''
    endif
    return a:c
endfunction

function! s:myVimIME_SetupKeymap()
    lnoremap <buffer><expr> ; <SID>myVimIME_SelectLabel(';', 2)
    lnoremap <buffer><expr> ' <SID>myVimIME_SelectLabel("'", 3)

    lnoremap <buffer><expr> <C-h> ZFVimIME_backspace()
    lnoremap <buffer><expr> <C-j> ZFVimIME_enter()

    for c in split('`~!@#$%^&*()_+}{":/?.>,', '\zs')
        execute 'lnoremap <buffer><expr> ' . c . " <SID>myVimIME_LabelWithSymbol('" . c . "')"
    endfor

    " 对alt键的绑定,不能用lnoremap, 因为它会覆盖掉一些自定义快捷键
    for c in split('abcdefghijklnopqrstuvwxyz', '\zs')
        let l:u = toupper(c)
        execute 'lmap <buffer> <M-' . c . '> <Esc><Esc>' . c
        execute 'lmap <buffer> <M-' . l:u . '> <Esc><Esc>' . l:u
    endfor
    lnoremap <buffer> <M-m> <Esc><Esc>^i

    for c in split("0123456789`-=\\[];',./", '\zs')
        execute 'lmap <buffer> <M-' . c . '> <Esc><Esc>' . c
    endfor

    lnoremap <buffer><expr> <lt> <SID>myVimIME_LabelWithSymbol('<')
    lnoremap <buffer><expr> <Bslash> <SID>myVimIME_LabelWithSymbol('\')
    lnoremap <buffer><expr> <Bar> <SID>myVimIME_LabelWithSymbol('\|')
endfunction

augroup MyVimIME_augroup
    autocmd!
    autocmd User ZFVimIM_event_OnStart call s:myVimIME_SetupKeymap()
augroup END
"""""""""""ZFVimIM end

"""""""""""sandwich begin
"         [count1]{operator}[count2]{textobject}{addition}
"Default operators do not distinguish [count1] and [count2] but
"operator-sandwich does. [count1] is given for {operators} and [count2] is
"given for {textobject}.
silent! nmap <unique><silent> <leader>sd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
silent! nmap <unique><silent> <leader>sr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
silent! nmap <unique><silent> <leader>sdb <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
silent! nmap <unique><silent> <leader>srb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
" add
" <leader>saiw(  为一个单词增加小括号
silent! nmap <unique> <leader>sa <Plug>(operator-sandwich-add)
silent! xmap <unique> <leader>sa <Plug>(operator-sandwich-add)
silent! omap <unique> <leader>sa <Plug>(operator-sandwich-g@)
" delete
silent! xmap <unique> <leader>sd <Plug>(operator-sandwich-delete)
" replace
silent! xmap <unique> <leader>sr <Plug>(operator-sandwich-replace)
"""""""""""sandwich end

""""""""""""vim-textobj-comment begin
" n->note, 也即注释
call textobj#user#plugin('comment', {
     \   '-': {
     \     'select-a-function': 'textobj#comment#select_a',
     \     'select-a': 'an',
     \     'select-i-function': 'textobj#comment#select_i',
     \     'select-i': 'in',
     \   },
     \   'big': {
     \     'select-a-function': 'textobj#comment#select_big_a',
     \     'select-a': 'aN',
     \   }
     \ })
""""""""""""vim-textobj-comment end
