" vimrc file
" Languague:    vim
" Maintainer:   Beomjoon Goh
" Last Change:  09 Mar 2020 21:40:33 +0900
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
  Plug 'junegunn/goyo.vim'
  Plug 'michaeljsmith/vim-indent-object'
  Plug 'junegunn/vim-easy-align'
  Plug 'mbbill/undotree', { 'on' : 'UndotreeToggle' }

  " Colorscheme & Syntax
  Plug 'BeomjoonGoh/vim-desertBJ'
  Plug 'BeomjoonGoh/txt.vim'
  Plug 'BeomjoonGoh/vim-aftersyntax'
  Plug 'octol/vim-cpp-enhanced-highlight'
call plug#end()

set nocompatible
set history=100
set viminfo='50,\"50,n$HOME/.vim/.viminfo " read/write a .viminfo file, don't store more
set backspace=indent,eol,start        " backspacing over everything in insert mode
set scrolloff=3
set sidescroll=10
set clipboard=exclude:.*              " Fixes slow startup with ssh!! Same as $ vim -X
set lazyredraw                        " Not sure but it makes scrolling faster
set ttyfast                           " This one too
set formatoptions+=rnlj
set path+=**                          " Search down into subdirectories
set timeoutlen=300
set updatetime=500

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
  set mouse=""                   " Disable(enable) mouse: =""(a)
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
  command -nargs=? -complete=file Sp sp <args>
  command -nargs=? -complete=file Vs vs <args>
  command -nargs=? -complete=file Vsp vsp <args>
  command -nargs=? -complete=file_in_path Vfind vnew<bar> find <args>
  command -nargs=? -complete=file_in_path Sfind sfind <args>
  command -nargs=? -complete=help Help tab help <args>
  command Vn vsp $HOME/.vim/scratchpad.txt
  command Sn sp  $HOME/.vim/scratchpad.txt
  command RemoveTrailingSpaces %s/\s\+$//e
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
  let l:pwd = substitute(getcwd(), $HOME, '~', '')
  return '%h%f %m%r  pwd: %<' . l:pwd . ' %=%(C: %c%V, L: %l/%L%) %P '
 "return '%h%f %m%r  pwd: %<%{getcwd()} %=%(C: %c%V, L: %l/%L%) %P '
endfunction

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
    elseif ftype == 'cppman' | let fname .= "[C++] ".g:page_name
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
set expandtab                   " Expand a <tab> to spaces
let s:nSpace     = 2
let &shiftwidth  = s:nSpace     " Indents width
let &softtabstop = s:nSpace     " <BS> regards 's:nSpace' spaces as one character
                                " :%retab replaces all \t's to spaces
unlet s:nSpace

"--- Search
set incsearch                   " Show search matches as you type.
set smartcase                   " ignore case if search pattern is all lowercases, case-sensitive otherwise
set hlsearch                    " Highlights searches

"--- Wrap
set nowrap

"--- Line number
set numberwidth=4
set number
augroup numbertoggle
  "Turn off relativenumber for non focused splits. This has a potential of slowing down scrolling when combined with
  "iTerm2
  autocmd!
  let s:no_number_toggle = [ 'help', 'tagbar', 'netrw', 'cppman', 'man', 'undotree', 'diff' ]
  autocmd BufEnter,FocusGained *
  \ if (index(s:no_number_toggle, &filetype) == -1) | setlocal relativenumber | endif
  autocmd BufLeave,FocusLost * setlocal norelativenumber
augroup END

"--- Spell check
set spellsuggest=best,3         " 'z=' shows 3 best suggestions

"--- Insert mode completion & AutoComplPop settings
set completeopt+=menuone,noinsert
let g:acp_enableAtStartup = 1
let s:acpState = 1              " ACP at start up: 1->enable, 0->disable (Both)

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

"--- goyo settings
let g:goyo_width  = "120"
let g:goyo_height = "95%"
function! s:goyo_enter()
  set nonu nornu
  highlight ColorColumn ctermbg=234
endfunction
autocmd! User GoyoEnter nested call <SID>goyo_enter()

"--- vimdiff
if &diff
  function! IwhiteToggle()
    if &diffopt =~ 'iwhiteall'
      set diffopt-=iwhiteall
      echo "ignore all white spaces off"
    else
      set diffopt+=iwhiteall
      echo "ignore all white spaces on"
    endif
  endfunction
  nnoremap <Leader>iw :call IwhiteToggle()<CR>
endif

"--- terminal
if has('terminal')
  function! OpenTerminal(type)
    let l:cmd = a:type
    let l:term_options = {
          \ "term_finish" : "close",
          \ "term_name" : "[Terminal] bash",
          \}
    if     l:cmd == "botright"
      let l:term_options["term_rows"] = min([float2nr(0.18*&lines),15])
    elseif l:cmd == "vertical"
      let l:term_options["term_cols"] = min([float2nr(0.4*&columns),150])
    elseif l:cmd == "call"
      let l:cmd = ""
      let l:term_options["curwin"] = 1
    elseif l:cmd == "tab"
      "
    else
      return 1
    endif
    execute l:cmd . ' let g:term_bufnr = term_start("bash --login", l:term_options)'
    call term_sendkeys(g:term_bufnr, "source $HOME/.vim/bin/setup_bash.sh\<CR>")
  endfunction

  autocmd TerminalOpen *
  \ if &buftype == 'terminal' |
  \   set winfixheight winfixwidth |
  \ endif

  function! ChangeDirectory()
    let l:oldpwd = getcwd()
    cd %:p:h
    let l:newpwd = getcwd()
    if l:oldpwd != l:newpwd
      if exists("g:term_bufnr") && getbufvar(g:term_bufnr, '&buftype') == 'terminal'
        let l:cmd = "cd " . fnameescape(l:newpwd) . "\<CR>"
        call term_sendkeys(g:term_bufnr, l:cmd)
      endif
    endif
  endfunction

  " terminal-api
  function! Tapi_SetTermBufferNumber(bufnr, arglist)
    let g:term_bufnr = a:bufnr
    echomsg "This terminal(" . g:term_bufnr . ") is now set to g:term_bufnr."
  endfunction

  function! Tapi_ChangeDirectory(bufnr, arglist)
    let l:pwd = a:arglist[0]
    let l:do_cd = a:arglist[-1]
    if len(a:arglist) > 2
      for l:p in a:arglist[1:-2]
        let l:pwd .= " " . l:p
      endfor
    endif
    if getcwd() != l:pwd
      execute 'cd' . l:pwd
    endif
    if l:do_cd
      let l:cmd = "cd " . fnameescape(l:pwd) . "\<CR>"
      call term_sendkeys(g:term_bufnr, l:cmd)
    endif
  endfunction

  function! Tapi_VerticalSplit(bufnr, arglist)
    set nosplitright
    execute 'vertical split' . a:arglist[0]
    set splitright
  endfunction

  function! Tapi_Make(bufnr, arglist)
    let l:argstring = ''
    for l:a in a:arglist
      let l:argstring .= l:a
    endfor
    execute 'make' . l:argstring
    botright cwindow
  endfunction

  " commands
  if has("user_commands")
    command Bterm call OpenTerminal("botright")
    command Vterm call OpenTerminal("vertical")
    command Nterm call OpenTerminal("call")
    command Tterm call OpenTerminal("tab")
  endif

  " keymap
  nnoremap <Leader>cd :call ChangeDirectory()<CR>
  tnoremap <Leader>cd 2vim cd<CR>
  tnoremap <Leader>ll 2vim make<CR>
  tnoremap :: <C-w>:
endif

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
  " Toggle highlight characters over 120 columns
  if exists('+colorcolumn')
    if (&colorcolumn == "")
      echo "Highlight char 120+ On"
      set colorcolumn=120
    else
      echo "Highlight char 120+ Off"
      set colorcolumn=
    endif
  endif
endfunction

function! MouseOnOff()
  " Sets mouse on and off. Utilized with keymap F10
  if has('mouse')
    if (&mouse == "")
      set mouse=a
      echo "Mouse On"
    else
      set mouse=""
      echo "Mouse Off"
    endif
  endif
endfunction

function! ToggleACP()
  " Toggle AutoComplPop
  if s:acpState
    AcpDisable
    echo "AutoComplPop disabled"
    let s:acpState = 0
  else
    AcpEnable
    echo "AutoComplPop enabled"
    let s:acpState = 1
  endif
endfunction

function! TogglePasteSafe()
  " Toggle paste safe mode
  " see :help pastetoggle
  if (s:cycleIndentOption == 0)
    set number relativenumber
    set smartindent autoindent
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

function! Tilde4nonAlpha() " {{{
  " ~ key behaviour for non-alphabets
  let char = getline(".")[col(".") - 1]
  if     char == "`"  | normal! r~l
  elseif char == "1"  | normal! r!l
  elseif char == "2"  | normal! r@l
  elseif char == "3"  | normal! r#l
  elseif char == "4"  | normal! r$l
  elseif char == "5"  | normal! r%l
  elseif char == "6"  | normal! r^l
  elseif char == "7"  | normal! r&l
  elseif char == "8"  | normal! r*l
  elseif char == "9"  | normal! r(l
  elseif char == "0"  | normal! r)l
  elseif char == "-"  | normal! r_l
  elseif char == "="  | normal! r+l
  elseif char == "["  | normal! r{l
  elseif char == "]"  | normal! r}l
  elseif char == "\\" | normal! r|l
  elseif char == ";"  | normal! r:l
  elseif char == "'"  | normal! r"l
  elseif char == ","  | normal! r<l
  elseif char == "."  | normal! r>l
  elseif char == "/"  | normal! r?l
  elseif char == "~"  | normal! r`l
  elseif char == "!"  | normal! r1l
  elseif char == "@"  | normal! r2l
  elseif char == "#"  | normal! r3l
  elseif char == "$"  | normal! r4l
  elseif char == "%"  | normal! r5l
  elseif char == "^"  | normal! r6l
  elseif char == "&"  | normal! r7l
  elseif char == "*"  | normal! r8l
  elseif char == "("  | normal! r9l
  elseif char == ")"  | normal! r0l
  elseif char == "_"  | normal! r-l
  elseif char == "+"  | normal! r=l
  elseif char == "{"  | normal! r[l
  elseif char == "}"  | normal! r]l
  elseif char == "|"  | normal! r\l
  elseif char == ":"  | normal! r;l
  elseif char == "\"" | normal! r'l
  elseif char == "<"  | normal! r,l
  elseif char == ">"  | normal! r.l
  elseif char == "?"  | normal! r/l
  else                | normal! ~
  endif
endfunction
" }}}

function! ManLapack()
  " before use Man under cursor this removes trailing underscore character if it has one. (eg., void dgetrf_(...))
  let l:word = expand("<cword>")
  if l:word[strlen(l:word)-1] == "_"
    let l:word = l:word[:-2]
  endif
  execute "Man " . l:word
endfunction

" Cheatsheet
" TODO
" [ ] add option to edit.
" [ ] global variable vs / sp
" [ ] make it a plugin
" [ ] use bufname or something safer so that if cs.xxx is closed without
"     invoking Cheatsheet_close()

let g:cheatsheet_filetype_map = {
      \ "sh"       : "bash",
      \ "markdown" : "md",
      \}

function! Cheatsheet_toggle(cmd)
  if exists('s:cheatsheet_bufnr')
    call Cheatsheet_close(s:cheatsheet_bufnr)
    unlet s:cheatsheet_bufnr
  else
    let s:cheatsheet_bufnr = Cheatsheet_view( (a:cmd == "" ? "view" : a:cmd) )
    if s:cheatsheet_bufnr == -1
      unlet s:cheatsheet_bufnr
    endif
  endif
endfunction

function! Cheatsheet_getfile()
  let l:file_type = &filetype
  if has_key(g:cheatsheet_filetype_map, l:file_type)
    let l:file_type = g:cheatsheet_filetype_map[l:file_type]
  endif

  let l:file = expand('~/.vim/cheatsheets/cs.' . l:file_type)
  if !filereadable(l:file)
    echomsg 'cheat sheet does not exist: ' . l:file
    let l:file = "NOFILE"
  endif

  return l:file
endfunction

function! Cheatsheet_view(cmd)
  let l:file = Cheatsheet_getfile()
  if l:file == "NOFILE"
    return -1
  endif

  execute 'vertical split'
  execute a:cmd . l:file
  return bufnr('%')
endfunction

function! Cheatsheet_close(cheatsheet_bufnr)
  execute 'bdelete' a:cheatsheet_bufnr
endfunction

if has('user_commands')
  command! -bang -nargs=? -complete=command Cheat call Cheatsheet_toggle(<q-args>)
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
    \ let g:acp_completeOption='.,w,b,u,t,i,d' |
    \ if !exists('pathset') |
    \   let pathset=1 |
    \   setlocal path+=$HOME/work/lib,$HOME/work/lib/specialfunctions,$HOME/work/projectEuler/Library |
    \ endif |
    \ setlocal formatoptions-=o |
    \ setlocal textwidth=120 |
    \ setlocal foldmethod=syntax foldnestmax=2 |
    \ nnoremap <F2> :call ManLapack()<CR>

    "--- .py files
    let python_highlight_all = 1
    autocmd FileType python
    \ setlocal keywordprg=pydoc3 |
    \ setlocal foldmethod=indent foldnestmax=2 |

    "--- .md files
    let g:markdown_fenced_languages = [ 'bash=sh', 'vim', 'python', 'cpp' ]
    let g:markdown_minlines         = 50
    let g:markdown_folding          = 1

    autocmd FileType vim nnoremap <buffer> K :execute "tab help " . expand("<cword>")<CR>
    autocmd FileType sh,man nnoremap <buffer> K :execute "Man " . expand("<cword>")<CR>
  augroup END
endif

" }}}
" FOLDING {{{
set foldenable                  " enable folding
set foldcolumn=0                " add a fold column
set foldmethod=marker           " detect triple-{ style fold markers
set foldlevelstart=99           "  0: start out with everything folded
                                " 99: start out with everything unfolded
set foldnestmax=2
set foldminlines=2
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
                                " which commands trigger auto-unfold
set foldtext=MyFoldText()
function! MyFoldText()
  let line = getline(v:foldstart)

  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 3
  let foldedlinecount = v:foldend - v:foldstart

  " expand tabs into spaces
  let onetab = repeat(' ', &tabstop)
  let line = substitute(line, '\t', onetab, 'g')

  let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
  let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 7
  return line . repeat(" ",fillcharcount) . foldedlinecount . ' lines '
endfunction

" }}}
" KEY MAPPINGS {{{
"--- General
" goto file
nnoremap gf :vertical wincmd f<CR>
nnoremap gF :w<CR>gf

" Tab backwards!
inoremap <S-Tab> <C-d>

" Mapping of Tilde4nonAlpha to ~
nnoremap <silent> ~ :call Tilde4nonAlpha()<cr>

" Open the tagbar plugin
nnoremap <F3> :TagbarToggle<CR>
tnoremap <F3> <C-w>::TagbarToggle<CR>

" Call NoMore120
nnoremap <F4> :call ToggleColorcolumn()<CR>
inoremap <F4> <C-o>:call ToggleColorcolumn()<CR>

" Toggle AutoComplPop
nnoremap <F5> :call ToggleACP()<CR>
inoremap <F5> <C-o>:call ToggleACP()<CR>

" Toggle paste safe mode
nnoremap <F6> :call TogglePasteSafe()<CR>
inoremap <F6> <C-o>:call TogglePasteSafe()<CR>

" Toggle spell checking
nnoremap <F7> :setlocal spell!<CR>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>
inoremap <F7> <C-o>:setlocal spell!<CR>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>

" Type(i) or show(n) the current date stamp
imap <F9> <C-R>=strftime('%d %b %Y %T %z')<CR>
nnoremap <F9> :echo 'Current time is ' . strftime('%d %b %Y %T %z')<CR>

" Set mouse on & off
nnoremap <F10> :call MouseOnOff()<CR>
inoremap <F10> <C-o>:call MouseOnOff()<CR>

" netrw
nnoremap <C-\> :Lexplore<CR>
inoremap <C-\> <C-o>:Lexplore<CR>

" Reset searches
nmap <silent> <Leader>r :nohlsearch<CR>
nmap <silent> <Leader>R :silent!/BruteForceResetSearch_<C-r>=rand()<CR>.<CR>

" Enter works in normal mode
nmap <CR> :AcpLock<CR>i<C-m><Esc>:AcpUnlock<bar>echo<CR>


" To the previous buffer
nnoremap <Leader><Leader><Leader> <C-^>

"--- QuickFix window
" \ll  => save the file and make and show the result in the bottom split (cwindow) if there are errors and/or warnings.
" \w   => show the cwindow (if exists).
" \c   => close the cwindow.
" \n   => jump to the next problematic line and column of the code.
" \N   => jump to the previous problematic line and column of the code.
" <CR> => from the cwindow, jump to the code where the cursor below indicates.
" \e   => will run a program xxx if it is the binary file compiled from the source code with the same name
"         (but extension): xxx.c or xxx.cpp (% is current file name, < eliminates extension)
nnoremap <Leader>ll :w<CR>:make -Bs<CR>:botright cwindow<CR>
nnoremap <Leader>w :botright cwindow<CR>
nnoremap <Leader>c :cclose<CR>
nnoremap <Leader>n :cnext<CR>
nnoremap <Leader>N :cprevious<CR>
augroup QuickFixMap
  autocmd!
  autocmd FileType qf nnoremap <CR> :.cc<CR>
augroup END
"nnoremap <Leader>e :!./%<<CR>
nnoremap <Leader>e :!./main<CR>

"--- Search in visual mode (* and #)
" See https://vim.fandom.com/wiki/Search_for_visually_selected_text
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

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

" For completeness. Use bash cmd mode instead
tnoremap <C-h> <left>
tnoremap <C-j> <down>
tnoremap <C-k> <up>
tnoremap <C-l> <right>

" Go up and down to the next row for wrapped lines
nnoremap j gj
nnoremap k gk

" Move to the end of a line
nnoremap - $

"--- Folding Key Mappings
nnoremap <Space> za
vnoremap <Space> za
nnoremap zR zr
nnoremap zr zR
nnoremap zM zm
nnoremap zm zM
"nnoremap z0 :set foldlevel=0<cr>

"--- Tab page
nnoremap <Tab>: :tab
nnoremap <Tab>n :tabedit %<CR>
nnoremap <Tab>e :tabedit<Space>
nnoremap <Tab>gf <C-w>gf

" <C-Tab>   : iTerm Sends HEX code for <F11> "[23~"
" <C-S-Tab> : iTerm Sends HEX code for <F12> "[24~"
nnoremap <silent> <F11> :tabnext<CR>
nnoremap <silent> <F12> :tabprevious<CR>
inoremap <silent> <F11> <Esc>:tabnext<CR>
inoremap <silent> <F12> <Esc>:tabprevious<CR>
vnoremap <silent> <F11> <Esc>:tabnext<CR>
vnoremap <silent> <F12> <Esc>:tabprevious<CR>
tnoremap <silent> <F11> <C-w>:tabnext<CR>
tnoremap <silent> <F12> <C-w>:tabprevious<CR>

nnoremap <Tab>1 1gt
nnoremap <Tab>2 2gt
nnoremap <Tab>3 3gt
nnoremap <Tab>4 4gt
nnoremap <Tab>5 5gt
nnoremap <Tab>6 6gt

"--- Yank to and paste from clipboard
vnoremap <C-y> "*y
nnoremap <C-p> "*p

"--- Test regular expression under cursor in double quotes
" See https://stackoverflow.com/questions/14499107/easiest-way-to-test-vim-regex/14499299
nnoremap <F8> mryi":let @/ = @"<CR>`r

"--- goyo
nnoremap <expr> <Leader>f ":Goyo" . (exists('#goyo') ? '!' : '+5%' ) . "\n"

"--- EasyAlign
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

"--- open URL
nnoremap <silent> go :!open -a Safari <cWORD><CR>
vnoremap <silent> go y<Esc>:!open -a Safari <C-r>0<CR>

"--- undotree
nnoremap <Leader>u :UndotreeToggle<CR>
" }}}
