" vimrc file
" Languague:    vim
" Maintainer:   Beomjoon Goh
" Last Change:  14 Jul 2020 19:52:10 +0900
" Contents:
"   General
"   User Interfaces
"   Functions
"   Color
"   File type Specific
"   Folding
"   Key Mappings

" GENERAL {{{
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
  set fileencodings=ucs-bom,utf-8,latin1,cp949
endif

let mapleader = '\'

call plug#begin('~/.vim/plugged')
  Plug 'othree/vim-autocomplpop' | Plug 'vim-scripts/L9'
  Plug 'majutsushi/tagbar', { 'on' : 'TagbarToggle' }
  Plug 'garbas/vim-snipmate' | Plug 'MarcWeber/vim-addon-mw-utils' | Plug 'tomtom/tlib_vim'
  Plug 'BeomjoonGoh/vim-cppman', { 'for' : 'cpp' }
  Plug 'vim-latex/vim-latex', { 'for' : 'tex' }
  Plug 'michaeljsmith/vim-indent-object'
  Plug 'junegunn/vim-easy-align'
  Plug 'mbbill/undotree', { 'on' : 'UndotreeToggle' }
  Plug 'junegunn/vim-peekaboo'

  " Colorscheme & Syntax
  Plug 'BeomjoonGoh/vim-desertBJ'
  Plug 'BeomjoonGoh/txt.vim'
  Plug 'BeomjoonGoh/vim-aftersyntax'
  Plug 'octol/vim-cpp-enhanced-highlight'
  Plug 'shiracamus/vim-syntax-x86-objdump-d'
call plug#end()

set nocompatible
set history=100
set viminfo='50,\"50,n$HOME/.vim/.viminfo " read/write a .viminfo file, don't store more
set backspace=indent,eol,start        " backspacing over everything in insert mode
set scrolloff=1 sidescroll=5
set clipboard=exclude:.*              " Fixes slow startup with ssh!! Same as $ vim -X
set lazyredraw ttyfast                " Not sure but it makes scrolling faster
set formatoptions+=rnlj
set timeoutlen=500
set updatetime=500
set wildignore+=*out*,*inp*,*log*
set path+=**

runtime! ftplugin/man.vim
let g:ft_man_open_mode="tab"
let g:ft_man_folding_enable=1

set synmaxcol=512
set regexpengine=1

augroup redhat
  autocmd!
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") && $filetype !~# 'commit' |
  \   exe "normal! g'\"" |
  \ endif
augroup END

if has('mouse')
  set mouse=""
endif

"--- Commands
if has("user_commands")
  command! -bang -nargs=? -complete=file E e<bang> <args>
  command! -bang -nargs=? -complete=file W w<bang> <args>
  command! -bang -nargs=? -complete=file Wq wq<bang> <args>
  command! -bang -nargs=? -complete=file WQ wq<bang> <args>
  command! -bang Wqa wqa<bang>
  command! -bang WQa wqa<bang>
  command! -bang WQA wqa<bang>
  command! -bang Wa wa<bang>
  command! -bang WA wa<bang>
  command! -bang Q q<bang>
  command! -bang QA qa<bang>
  command! -bang Qa qa<bang>
  command! -nargs=? -complete=file Sp sp <args>
  command! -nargs=? -complete=file Vs vs <args>
  command! -nargs=? -complete=file Vsp vsp <args>
  command! -nargs=? -complete=file_in_path Vfind vnew<bar> find <args>
  command! -nargs=? -complete=file_in_path Sfind sfind <args>
  command! -nargs=? -complete=help Help tab help <args>
  command! Vn vsp $HOME/.vim/scratchpad.txt
  command! Sn sp  $HOME/.vim/scratchpad.txt
  command! RemoveTrailingSpaces %s/\s\+$//e
  command! Source source $HOME/.vim/vimrc
endif

" }}}
" USER INTERFACES {{{
"--- Command & Status line
set cmdheight=1
set noshowcmd
set laststatus=2
set wildmenu
set wildmode=list:longest,full
set nofileignorecase
set statusline=%!MyStatusLine()
function! MyStatusLine()
  return '%h%f %m%r  cwd: %<' . substitute(getcwd(), $HOME, '~', '') . ' %=%(C: %c%V, L: %l/%L%) %P '
endfunction
let &fillchars = 'vert: ,fold: ,diff: '

"--- Tab page
set showtabline=2
set tabline=%!MyTabLine()
function! MyTabLine()
  let str = repeat(' ', &numberwidth)
  for tpn in range(tabpagenr('$'))
    let ntab = tpn + 1
    let str .= '%'.ntab.'T'.(ntab == tabpagenr() ? '%1*%#TabNumSel# '.ntab.' %#TabLineSel# ' : '%2*%#TabNum# '.ntab.' %#TabLine# ')

    let buflist = tabpagebuflist(ntab)
    let bufnr = buflist[tabpagewinnr(ntab) - 1]
    let ftype = getbufvar(bufnr, '&filetype')

    let fname = ''
    if getbufvar(bufnr, '&buftype') == 'terminal' | let fname .= 'bash'
    elseif ftype == 'help'   | let fname .= '[Help] '.fnamemodify(bufname(bufnr), ':t:r')
    elseif ftype == 'qf'     | let fname .= '[Quickfix]'
    elseif ftype == 'netrw'  | let fname .= "[Netrw]"
    elseif ftype == 'tagbar' | let fname .= "[TagBar]"
    elseif ftype == 'cppman' | let fname .= "[C++] ".bufname(bufnr)
    else                     | let fname .= fnamemodify(bufname(bufnr), ':t')
    endif
    let str .= (fname != '' ? fname : "[No Name]")

    let modflag = ''
    for b in buflist
      if getbufvar(b, '&modified') && getbufvar(b, '&buftype') != 'terminal'
        let modflag .= (b == bufnr ? ' [+]' : ' [*]')
        break
      endif
    endfor
    let nwins = tabpagewinnr(ntab, '$')
    let str .= modflag. (nwins > 1 ? ' ('.nwins.') ' : ' ')
  endfor
  return str.'%T%#TabLineFill#%=%999XX'
endfunction

"--- Indent & tab
set autoindent smartindent      " When opening a new line and no filetype-specific indenting is enabled, keeps the same
let s:cycleIndentOption = 1     "   indent as the line you're currently on.
set tabstop=8                   " Change tab size (set to default for compatibility with others tabbed codes.)
set expandtab
let s:nSpace     = 2
let &shiftwidth  = s:nSpace     " Indents width
let &softtabstop = s:nSpace     " <BS> regards 's:nSpace' spaces as one character
                                " :%retab replaces all \t's to spaces
unlet s:nSpace

"--- Search
set incsearch                   " Show search matches as you type.
set smartcase                   " ignore case if search pattern is all lowercases, case-sensitive otherwise
set hlsearch

"--- Wrap
set nowrap

"--- Line number
set numberwidth=4
set number
augroup Numbertoggle
  "Turn off relativenumber for non focused splits. This has a potential of slowing down scrolling with iTerm2
  autocmd!
  let s:no_number_toggle = [ 'help', 'tagbar', 'netrw', 'cppman', 'man', 'undotree', 'diff' ]
  autocmd BufEnter,FocusGained *
  \ if (index(s:no_number_toggle, &filetype) == -1) | setlocal relativenumber | endif
  autocmd BufLeave,FocusLost * setlocal norelativenumber
augroup END

"--- Spell check
set spellsuggest=best,3         " 'z=' shows 3 best suggestions

"--- Insert mode completion & AutoComplPop settings
set complete=.,w,b,u,t
set completeopt+=menuone,noinsert
let g:acp_enableAtStartup = 1

function! s:unmapAcp()
  nnoremap i <Nop> | nunmap i
  nnoremap a <Nop> | nunmap a
  nnoremap R <Nop> | nunmap R
endfunction
augroup UnmapAcp
  autocmd!
  autocmd BufEnter * call s:unmapAcp()
augroup END

function! s:completeInclude()
  if &complete =~ 'i'
    set complete-=i
  else
    set complete+=i
  endif
  echo 'complete =' &complete
  let g:acp_completeOption = '&complete'
endfunction
if has('user_commands')
  command! CompleteIncludeToggle call <SID>completeInclude()
endif
silent call s:completeInclude()

"--- Split
set splitbelow
set splitright

"--- tagbar settings
let g:tagbar_width            = 30
let g:tagbar_compact          = 1
let g:tagbar_indent           = 1
let g:tagbar_show_balloon     = 0
let g:tagbar_map_showproto    = 'f'
let g:tagbar_map_togglefold   = ['<Space>', 'za']
let g:tagbar_map_openallfolds = ['_', '<kMultiply>', 'zR']
let g:tagbar_type_markdown    = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
        \ 'h:headings',
        \ 'l:links',
        \ 'i:images',
    \ ],
    \ 'sort' : 0,
\ }
highlight default link TagbarHighlight Visual

"--- SnipMate settings
let g:snipMate = get(g:, 'snipMate', {})
let g:snipMate.no_default_aliases = 1
let g:snipMate.snippet_version = 1
let g:snips_author = "Beomjoon Goh"

"--- netrw
let g:netrw_winsize        = 15 " window size
let g:netrw_liststyle      = 3  " tree style
let g:netrw_banner         = 0  " no banner
let g:netrw_browse_split   = 2  " <CR> :vsp 'selected file'
let g:netrw_special_syntax = 1  " file type syntax

"--- vimdiff
set diffopt=internal,filler,closeoff,context:3
function! s:iwhiteToggle()
  if &diffopt =~ 'iwhiteall'
    set diffopt-=iwhiteall
    echo "ignore all white spaces off"
  else
    set diffopt+=iwhiteall
    echo "ignore all white spaces on"
  endif
endfunction

"--- terminal {{{
if has('terminal')
  function! OpenTerminal(type)
    let l:cmd = a:type
    let l:rcfile = expand('$HOME/.vim/bin/setup_bash.sh')
    let l:term_options = {
          \ "term_finish" : "close",
          \ "term_name" : "[Terminal] bash",
          \}
    if     l:cmd == "botright"
      let l:term_options["term_rows"] = min([float2nr(0.18*&lines),15])
    elseif l:cmd == "vertical"
      let l:term_options["term_cols"] = min([float2nr(0.4*&columns),150])
    elseif l:cmd == ""
      let l:term_options["curwin"] = 1
    elseif l:cmd == "tab"
    else
      return 1
    endif
    execute l:cmd 'call term_start("bash --rcfile '.l:rcfile.'", l:term_options)'
    let g:term_bufnr = term_list()[0]
  endfunction

  autocmd TerminalOpen *
  \ if &buftype == 'terminal' |
  \   set winfixheight winfixwidth | 
  \   wincmd = |
  \ endif

  function! ChangeDirectoryTerm()
    if exists("g:term_bufnr") && getbufvar(g:term_bufnr, '&buftype') == 'terminal'
      let l:cmd = "cd " . fnameescape(getcwd()) . "\<CR>"
      call term_sendkeys(g:term_bufnr, l:cmd)
    endif
  endfunction

  function! ChangeDirectoryVim()
    let l:oldcwd = getcwd()
    cd %:p:h
    if l:oldcwd != getcwd()
      call ChangeDirectoryTerm()
    endif
  endfunction

  function! TextToTerm(text = "")
    let l:text = (a:text != "") ? a:text : substitute(getline("."), '$', '\n', '')

    let l:ftype = getbufvar("%", '&filetype')
    if l:ftype == 'vim'
      let l:text = substitute(l:text, '\n\+', '\n', 'g')
    elseif l:ftype == 'python'
      let l:text = s:processPython(l:text)
    endif

    call term_sendkeys(g:term_bufnr, l:text)
  endfunction

  function! s:processPython(code)
    let l:text = ""
    let l:previous_indent = 0
    for l:line in split(a:code, '\n')
      if empty(l:line) || l:line =~ '^\s*#'
        continue
      endif
      let l:current_indent = match(l:line, '\w')
      if l:previous_indent && !l:current_indent
        let l:text .= ''.l:line.''
      else
        let l:text .= l:line.''
      endif
      let l:previous_indent = l:current_indent
    endfor
    return l:previous_indent ? l:text.'' : l:text
  endfunction

  " terminal-api
  function! Tapi_SetTermBufferNumber(bufnr, arglist)
    let g:term_bufnr = a:bufnr
    echomsg "This terminal(" . g:term_bufnr . ") is now set to g:term_bufnr."
  endfunction

  function! Tapi_ChangeDirectory(bufnr, arglist)
    let l:cwd = join(a:arglist[:-2], " ")
    let l:do_cd = a:arglist[-1]
    if getcwd() != l:cwd
      execute 'cd' l:cwd
    endif
    if l:do_cd
      call ChangeDirectoryTerm()
    endif
  endfunction

  function! Tapi_Split(bufnr, arglist)
    if a:arglist[0] != 'v' && a:arglist[0] != 's'
      return
    endif
    let l:mode = (a:arglist[0] == 's') ? '' : a:arglist[0]
    let l:file = a:arglist[1]
    let l:cmd = (l:file == "new") ? '' : "split "
    wincmd W
    execute l:mode.l:cmd.l:file
  endfunction

  function! Tapi_Make(bufnr, arglist)
    execute 'make' join(a:arglist, " ")
    botright cwindow
  endfunction

  " commands
  if has("user_commands")
    command! Bterm call OpenTerminal("botright")
    command! Vterm call OpenTerminal("vertical")
    command! Nterm call OpenTerminal("")
    command! Tterm call OpenTerminal("tab")
  endif

  " keymap
  nnoremap <silent> <Leader>cd :call ChangeDirectoryVim()<CR>
  tnoremap <silent> <Leader>cd <C-w>:call ChangeDirectoryTerm()<CR>
  tnoremap <Leader>ll 2vim make<CR>
  nnoremap <Leader>t :call TextToTerm()<CR>
  vnoremap <Leader>t :<C-u>call TextToTerm(<SID>getSelectedText())<CR>
  tnoremap :: <C-w>:
endif
" }}}

"--- Cheatsheet {{{
" TODO
" [ ] make it a plugin
" [ ] write doc
let g:cheatsheet_filetypeDict = {
      \  "sh"       : "bash",
      \  "markdown" : "md",
      \  "make"     : "makefile",
      \} "filetype  : extension
let g:cheatsheet_path = '~/.vim/cheatsheets' " ??? global? automatically find path?
let g:cheatsheet_complete = system("ls " . g:cheatsheet_path . " | sed 's/cs.//g'")
let g:cheatsheet_split = 'vsp' " or 'sp'

function! Cheatsheet_getfile(ft)
  let l:file_type = (a:ft == "") ? &filetype : a:ft
  if has_key(g:cheatsheet_filetypeDict, l:file_type)
    let l:file_type = g:cheatsheet_filetypeDict[l:file_type]
  endif
  return expand(g:cheatsheet_path . '/cs.' . l:file_type)
endfunction

function! Cheatsheet_open(cmd, ft)
  let l:file = Cheatsheet_getfile(a:ft)
  if a:cmd == 'view' && !filereadable(l:file)
    echomsg 'cheatsheet does not exist:' l:file
    return
  endif
  execute g:cheatsheet_split
  execute a:cmd l:file
  silent! %foldclose!
endfunction

function! Cheatsheet_complete(A,L,P)
  return g:cheatsheet_complete
endfunction

if has('user_commands')
  command! -bang -nargs=? -complete=custom,Cheatsheet_complete Cheat call Cheatsheet_open('view', <q-args>)
  command! -bang -nargs=? -complete=custom,Cheatsheet_complete CheatEdit call Cheatsheet_open('edit', <q-args>)
endif
" }}}

"--- undotree
let g:undotree_WindowLayout             = 2
let g:undotree_SplitWidth               = 24
let g:undotree_DiffpanelHeight          = 10
let g:undotree_SetFocusWhenToggle       = 1
let g:undotree_DiffCommand              = '$HOME/.vim/bin/diff_no_header'
let g:undotree_ShortIndicators          = 1
let g:undotree_HighlightChangedText     = 0
let g:undotree_HighlightChangedWithSign = 0
let g:undotree_HelpLine                 = 0

" }}}
" FUNCTIONS {{{
function! ToggleColorcolumn()
  if exists('+colorcolumn')
    let &colorcolumn = (&colorcolumn == "") ? 120 : ""
    echo "colorcolumn =" &colorcolumn
  endif
endfunction

function! ToggleMouse()
  if has('mouse')
    let &mouse = (&mouse == "") ? "a" : ""
    echo "mouse =" &mouse
  endif
endfunction

function! ToggleACP()
  execute exists('#AcpGlobalAutoCommand#InsertEnter') ? 'AcpDisable' : 'AcpEnable'
endfunction

function! TogglePasteSafe()
  " see :help pastetoggle
  if (s:cycleIndentOption == 0)
    set number relativenumber smartindent autoindent
    let s:cycleIndentOption = 1
    let msg = "Back to normal indenting (smart and auto indent)."
  elseif (s:cycleIndentOption == 1)
    set nosmartindent noautoindent
    let s:cycleIndentOption = 2
    let msg = "Pasting is now safe (no smart nor auto indent)."
  else "s:cycleIndentOption == 2
    set nonumber norelativenumber
    let s:cycleIndentOption = 0
    let msg = "Copy without line numbers."
  endif
  redraw
  echo msg
endfunction

function! s:getSelectedText()
  let l:old_reg = getreg('"')
  let l:old_regtype = getregtype('"')
  norm gvy
  let l:ret = getreg('"')
  call setreg('"', l:old_reg, l:old_regtype)
  exe "norm \<Esc>"
  return l:ret
endfunction

function! s:tildeForNonAlpha(str)
  let l:pool = '`1234567890-=[]\;,./''~!@#$%^&*()_+{}|:<>?"'
  let l:lines = 0
  for l:c in split(a:str, '\zs')
    if     l:c =~ '\a' | normal! ~
    elseif l:c =~ '\s' | normal! l
    elseif l:c =~ '\d\|[[:punct:]]'
      execute 'normal!' 'r'.l:pool[((stridx(l:pool,l:c) + 21) % 42)].'l'
    elseif l:c =~ '\n'
      let l:lines = l:lines + 1
      execute 'normal! `<'.l:lines.'j'
    endif
  endfor
endfunction

function! s:manLapack()
  execute "Man" substitute(expand("<cword>"), '_', '','g')
endfunction

function! ClearNamedRegisters()
  for i in split("abcdefghijklmnopqrstuvwxyz",'\zs')
    call setreg(i,'')
  endfor
endfunction

if has('mac')
  "--- OpenFinder
  function! s:openFinder()
    let l:cmd = '!open ' . (filereadable(expand("%")) ? '-R '.shellescape("%") : '.')
    execute "silent!" l:cmd
    redraw!
  endfunction
  
  if has('user_commands')
    command! OpenFinder call <SID>openFinder()
  endif

  "--- InsertForeign
  let g:InsertForeign_IssLib = expand('$HOME/.vim/bin/libInputSourceSwitcher.dylib')
  let g:InsertForeign_DefaultLayout = 'com.apple.keylayout.US'
  let g:InsertForeign_InsertLayout = 'com.apple.inputmethod.Korean.2SetKorean'
  if filereadable(g:InsertForeign_IssLib)
    function! s:toggleInsertForeign()
      if !exists('#InsertForeignAu#InsertEnter')
        augroup InsertForeignAu
          autocmd!
          autocmd InsertEnter * call libcall(g:InsertForeign_IssLib, 'Xkb_Switch_setXkbLayout', g:InsertForeign_InsertLayout)
          autocmd InsertLeave * call libcall(g:InsertForeign_IssLib, 'Xkb_Switch_setXkbLayout', g:InsertForeign_DefaultLayout)
        augroup END
        echo "InsertForeign is on"
      else
        augroup InsertForeignAu
          autocmd!
        augroup END
        echo "InsertForeign is off"
      endif
    endfunction

    if has('user_commands')
      command! InsertForeign call <SID>toggleInsertForeign()
    endif
  endif
endif

" }}}
" COLOR {{{
set t_Co=256
colorscheme desertBJ

" }}}
" FILETYPE SPECIFIC {{{
if !exists('user_filetypes')
  let user_filetypes = 1
  augroup UserFileType
    autocmd!
    "--- .tex files
    autocmd FileType tex
    \ setlocal textwidth=120 |
    \ setlocal foldlevel=99
    let g:Tex_PromptedCommands    = ''
    let g:tex_flavor              = 'latex'
    let g:Tex_DefaultTargetFormat = 'pdf'
    let g:Tex_ViewRule_pdf        = 'open -a Preview'
    let g:Tex_FoldedEnvironments  = ''
    let g:tex_indent_brace        = 0

    "--- .c, .cpp files
    let g:cpp_class_scope_highlight     = 1
    let g:cpp_class_decl_highlight      = 1
    let g:cpp_member_variable_highlight = 1
    let g:cpp_no_function_highlight     = 1
    autocmd FileType c,cpp
    \ setlocal cindent |
    \ if !exists('pathset') |
    \   let pathset = 1 |
    \   set path+=$HOME/work/lib,$HOME/work/lib/specialfunctions,$HOME/work/projectEuler/Library |
    \ endif |
    \ setlocal formatoptions-=o |
    \ setlocal textwidth=120 |
    \ setlocal foldmethod=syntax

    "--- .py files
    let python_highlight_all = 1
    autocmd FileType python
    \ setlocal keywordprg=pydoc3 |
    \ setlocal foldmethod=indent

    "--- .md files
    let g:markdown_fenced_languages = [ 'bash=sh', 'vim', 'python', 'cpp' ]
    let g:markdown_minlines         = 100
    let g:markdown_folding          = 1

    autocmd FileType vim nnoremap <buffer> K :execute "tab help " . expand("<cword>")<CR>
    autocmd FileType sh,man nnoremap <buffer> K :execute "Man " . expand("<cword>")<CR>
  augroup END
endif

" }}}
" FOLDING {{{
set foldenable
set foldcolumn=0
set foldmethod=marker
set foldlevelstart=99
set foldnestmax=4
set foldminlines=1
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo

let s:char = matchstr(split(&fillchars,','), 'fold:.')
let g:foldchar = (s:char == "") ? '-' : s:char[-1:]
unlet s:char

set foldtext=MyFoldText()
function! MyFoldText()
  let line = substitute(getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g')
  let nfolded = v:foldend - v:foldstart

  let windowwidth = winwidth(0) - &foldcolumn - &number * &numberwidth
  let maxline = windowwidth - len(nfolded) - len(' lines ') - 1 
  let line = strpart(line, 0, maxline)
  return line . repeat(g:foldchar, maxline-len(line)+1) . nfolded . ' lines '
endfunction

" }}}
" KEY MAPPINGS {{{
function! s:Noremap(modelist, key, cmd)
  for l:mode in a:modelist
    if     l:mode == 'i' | let l:cmd = '<C-o>'.a:cmd
    elseif l:mode == 't' | let l:cmd = '<C-w>:'.a:cmd
    else                 | let l:cmd = a:cmd
    endif
    execute l:mode.'noremap' a:key l:cmd
  endfor
endfunction 

"--- General
" goto file
nnoremap gf :vertical wincmd f<CR>
nnoremap gF :w<CR>gf

" Tab backwards!
inoremap <S-Tab> <C-d>

" Switch case for non-alphabets
nnoremap <silent> ~ :call <SID>tildeForNonAlpha(getline(".")[col(".")-1])<CR>
vnoremap <silent> ~ :<C-u>call <SID>tildeForNonAlpha(<SID>getSelectedText())<CR>

" manLapack
nnoremap <F2> :call <SID>manLapack()<CR>

" Type(i) or show(n) the current date stamp
imap <F9> <C-R>=strftime('%d %b %Y %T %z')<CR>
nnoremap <F9> :echo 'Current time is ' . strftime('%d %b %Y %T %z')<CR>

" Reset searches
nmap <silent> <Leader>r :nohlsearch<CR>
nmap <silent> <Leader>R :silent!/BruteForceSearchReset_<C-r>=rand()<CR>.<CR>

" Enter works in normal mode
nmap <silent> <CR> i<C-m><Esc>

" To the previous buffer
nnoremap <Leader><Leader><Leader> <C-^>

" Yank to and paste from clipboard
vnoremap <C-y> "*y
nnoremap <C-p> "*p

"--- Toggle
call s:Noremap(['n','t'], '<F3>',  ":TagbarToggle<CR>")
call s:Noremap(['n','i'], '<F4>',  ":call ToggleColorcolumn()<CR>")
call s:Noremap(['n','i'], '<F5>',  ":call ToggleACP()<CR>")
call s:Noremap(['n','i'], '<F6>',  ":call TogglePasteSafe()<CR>")
call s:Noremap(['n','i'], '<F7>',  ":setlocal spell!<CR>:echo 'Spell Check: '.strpart('OffOn', 3*&spell, 3)<CR>")
call s:Noremap(['n','i'], '<F10>', ":call ToggleMouse()<CR>")
call s:Noremap(['n','i'], '<C-\>', ":Lexplore<CR>")
nnoremap <Leader>iw :call <SID>iwhiteToggle()<CR>

"--- QuickFix window
nnoremap <Leader>ll :w<CR>:make -s<CR>:botright cwindow<CR>
nnoremap <Leader>w :botright cwindow<CR>
nnoremap <Leader>c :cclose<CR>
nnoremap <Leader>n :cnext<CR>
nnoremap <Leader>N :cprevious<CR>
nnoremap <Leader>g :.cc<CR>

"--- Search in visual mode (* and #)
" See https://vim.fandom.com/wiki/Search_for_visually_selected_text
vnoremap <silent> * :call setreg("/", substitute(<SID>getSelectedText(), "\_s\+", '\\_s\\+', 'g'))<Cr>n
vnoremap <silent> # :call setreg("?", substitute(<SID>getSelectedText(), '\_s\+', '\\_s\\+', 'g'))<Cr>n

"--- Moving around
" Easy window navigation
" Note: Karabiner maps <C-hjkl> to Arrows
"       iTerm2    maps <A-hjkl> to <C-hjkl>
nnoremap <left> <C-w>h
nnoremap <down> <C-w>j
nnoremap <up> <C-w>k
nnoremap <right> <C-w>l

tnoremap <left> <C-w>h
tnoremap <down> <C-w>j
tnoremap <up> <C-w>k
tnoremap <right> <C-w>l

" For completeness. Use readline's normal mode instead
tnoremap <C-h> <left>
tnoremap <C-j> <down>
tnoremap <C-k> <up>
tnoremap <C-l> <right>

" Go up and down to the next row for wrapped lines
nnoremap j gj
nnoremap k gk

"--- Folding
call s:Noremap(['n','v'], '<Space>', "za")
nnoremap zR zr
nnoremap zr zR
nnoremap zM zm
nnoremap zm zM
for i in range(10)
  execute 'nnoremap' 'z'.i ':set foldlevel='.i.'<CR>'
endfor

"--- Tab page
nnoremap <Tab>: :tab
nnoremap <Tab>n :tabedit %<CR>
nnoremap <Tab>e :tabedit<Space>
nnoremap <Tab>gf <C-w>gf

" <C-Tab>   : iTerm Sends HEX code for <F11> "[23~"
" <C-S-Tab> : iTerm Sends HEX code for <F12> "[24~"
call s:Noremap(['n','i','t'], '<silent> <F11>', ":tabnext<CR>")
call s:Noremap(['n','i','t'], '<silent> <F12>', ":tabprevious<CR>")

for i in range(1,6)
  execute 'nnoremap <Tab>'.i i.'gt'
endfor

"--- EasyAlign
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

"--- open URL
if has('mac')
  nnoremap <silent> go :!open <cWORD><CR>
  vnoremap <silent> go y<Esc>:!open <C-r>0<CR>
endif

"--- undotree
nnoremap <Leader>u :UndotreeToggle<CR>
" }}}
