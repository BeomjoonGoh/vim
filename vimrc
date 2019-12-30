"""""""""""""""""""""""""""""""""""""""""""""""""
"               [.vimrc file]                   "
"""""""""""""""""""""""""""""""""""""""""""""""""
"                                               "
" Maintainer:   Beomjoon Goh (bjgoh1990)        "
" Last Change:  10 Dec 2019 15:04:13 +0900      "
"                                               "
" Contents:                                     "
"     > General                                 "
"     > User Interfaces                         "
"     > Functions                               "
"     > Color                                   "
"     > File type Specific                      "
"     > Folding                                 "
"     > Key Mappings                            "
"                                               "
"""""""""""""""""""""""""""""""""""""""""""""""""

"===== >    GENERAL            ===== {{{
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1,cp949
endif

set nocompatible
filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()
  Plugin 'VundleVim/Vundle.vim'

  Plugin 'othree/vim-autocomplpop'          " requires L9 library
    Plugin 'L9'                             " utility functions / commands library
  Plugin 'BeomjoonGoh/vim-taglist'          " source code navigation
  Plugin 'garbas/vim-snipmate'              " requires vim-addon-mw-utils, tlib_vim
    Plugin 'MarcWeber/vim-addon-mw-utils'
    Plugin 'tomtom/tlib_vim'
  Plugin 'BeomjoonGoh/vim-cppman'           " cppman within vim on a new tab
  Plugin 'gerw/vim-latex-suite'             " latex-suite
  Plugin 'junegunn/goyo.vim'
  Plugin 'michaeljsmith/vim-indent-object'

  " Colorscheme & Syntax
  Plugin 'BeomjoonGoh/vim-desertBJ'
  Plugin 'BeomjoonGoh/vim-txt'
  Plugin 'BeomjoonGoh/vim-aftersyntax'      " requires vim-cpp-enhanced-highlight
    Plugin 'octol/vim-cpp-enhanced-highlight'
call vundle#end()
filetype plugin on
filetype indent on

set history=100
set viminfo='20,\"50,n~/.vim/.viminfo " read/write a .viminfo file, don't store more
set backspace=indent,eol,start  " backspacing over everything in insert mode
set scrolloff=3
set clipboard=exclude:.*        " Fixes slow startup with ssh!! Same as $ vim -X
set lazyredraw                  " Not sure but it makes scrolling faster
set ttyfast                     " This one too
set formatoptions+=rnlj
set path+=**                    " Search down into subdirectories

runtime! ftplugin/man.vim
let g:ft_man_open_mode="tab"

syntax on
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
  command! -nargs=? -complete=file Sp sp <args>
  command! -nargs=? -complete=file Vs vs <args>
  command! -nargs=? -complete=file Vsp vsp <args>
  command! -nargs=? -complete=file_in_path Find vnew<bar> find <args>
  command Cd cd %:p:h
  if has('terminal')
    let s:termoptions = {
      \ "term_finish":"close",
      \ "term_rows":10,
      \ "term_name":"[Terminal] bash",
      \}
    command Term botright call term_start("bash -ls", s:termoptions)
    let s:vtermoptions = {
      \ "term_finish":"close",
      \ "term_name":"[Terminal] bash",
      \}
    command Vterm vertical call term_start("bash -ls", s:vtermoptions)
  endif
  command Vn vsp ~/work/.scratchpad.txt
  command Sn sp  ~/work/.scratchpad.txt
  command RemoveTrailingSpaces %s/\s\+$//e
endif

" }}}
"===== >    USER INTERFACES    ===== {{{
"--- Command & Status line
set cmdheight=1
set noshowcmd
set laststatus=2
set statusline=%!MyStatusLine()
function! MyStatusLine()
  return '%h%f %m%r  pwd: %<%{getcwd()} %=%(C: %c%V, L: %l/%L%) %P '
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
    elseif ftype == 'help'    | let fname .= '[Help] '.fnamemodify(bufname(bufnr), ':t:r')
    elseif ftype == 'qf'      | let fname .= '[Quickfix]'
    elseif ftype == 'netrw'   | let fname .= "[Netrw]"
    elseif ftype == 'taglist' | let fname .= "[TagList]"
    elseif ftype == 'cppman'  | let fname .= "[C++] ".g:page_name
    else                      | let fname .= fnamemodify(bufname(bufnr), ':t')
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
let s:cycleIndentOption=1       "   indent as the line you're currently on.
set tabstop=8                   " Change tab size (set to default for compatibility with others tabbed codes.)
set expandtab                   " Expand a <tab> to spaces
let s:nSpace=2
let &shiftwidth=s:nSpace        " Indents width
let &softtabstop=s:nSpace       " <BS> regards 's:nSpace' spaces as one character
                                " :%retab replaces all \t's to spaces
unlet s:nSpace

"--- Search
set incsearch                   " Show search matches as you type.
set smartcase                   " ignore case if search pattern is all lowercases, case-sensitive otherwise
set hlsearch                    " Highlights searches

set wildmenu                    " Turn on command line completion wild style
set wildmode=list:longest,full

set nowrap

set numberwidth=4
set number
augroup numbertoggle
  "Turn off relativenumber for non focused splits. This has a potential of slowing down scrolling when combined with
  "iTerm2
  autocmd!
  autocmd BufEnter,FocusGained *
  \ if (&filetype!="help" && &filetype!="taglist" && &filetype!="netrw" && &filetype!="cppman") |
  \   setlocal relativenumber |
  \ endif
  autocmd BufLeave,FocusLost * setlocal norelativenumber
augroup END

"--- Spell check
set spellsuggest=best,3        " 'z=' shows 3 best suggestions

"--- Insert mode completion & AutoComplPop settings
set completeopt+=menuone,noinsert
let g:acp_enableAtStartup=1
let s:acpState=1                " ACP at start up: 1->enable, 0->disable (Both)

"--- About the split
set splitbelow
set splitright

"--- TagList settings
let Tlist_Exit_OnlyWindow=1     " Quit when TagList is the last open window
let Tlist_WinWidth=30           " Set the width
let Tlist_Use_Right_Window=1    " show TagList window on the right
let Tlist_Compact_Format=1
let Tlist_Enable_Fold_Column=0

"--- SnipMate settings
let g:snipMate = {}
let g:snipMate.no_default_aliases = 1

"--- netrw
let g:netrw_winsize=25        " window size
let g:netrw_liststyle=3       " tree style
let g:netrw_banner=0          " no banner
let g:netrw_browse_split=2    " <CR> :vsp 'selected file'
let g:netrw_special_syntax=1  " file type syntax

"--- goyo settings
let g:goyo_width="123"
let g:goyo_height="95%"
function! s:goyo_enter()
  set number
  highlight Normal ctermbg=black
  if exists('+colorcolumn')
    set colorcolumn=120
    highlight ColorColumn ctermbg=234
  endif
endfunction
autocmd! User GoyoEnter nested call <SID>goyo_enter()

" }}}
"===== >    FUNCTIONS          ===== {{{
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

function CppmanLapack()
  " before use cppman under cursor this removes trailing underscore character if it has one. (eg., void dgetrf_(...))
  let s:word = expand("<cword>")
  if s:word[strlen(s:word)-1] == "_"
    let s:word = s:word[:-2]
  endif
  execute "Man " . s:word
endfunction

" }}}
"===== >    COLOR              ===== {{{
set t_Co=256                    " Default: 8
colorscheme desertBJ

" }}}
"===== >    FILETYPE SPECIFIC  ===== {{{
if !exists('user_filetypes')
  let user_filetypes = 1
  augroup UserFileType
    autocmd!
    "--- .tex files
    " Enables snipMate for .tex. Default:.latex
    autocmd BufRead,BufNewFile *.tex
    \ set textwidth=120 |
    \ set filetype=tex  |
    \ set foldlevel=99
    "set grepprg=grep\ -nH $*
    let g:Tex_PromptedCommands=''
    let g:tex_flavor='latex'
    let g:Tex_DefaultTargetFormat='pdf'
    let g:Tex_ViewRule_pdf = 'open -a Preview'
    let g:Tex_FoldedEnvironments=''
    let g:tex_indent_brace=0

    "--- terminal
    if has('terminal')
      autocmd TerminalOpen terminal set winfixheight | set winfixwidth
    endif

    "--- .c, .cpp files
    let g:cpp_class_scope_highlight = 1
    let g:cpp_class_decl_highlight = 1
    let g:cpp_member_variable_highlight = 1
    let g:cpp_no_function_highlight = 1
    autocmd BufRead,BufNewFile *.c,*.cpp,*.h
    \ setlocal cindent |
    \ let g:acp_completeOption='.,w,b,u,t,i,d' |
    \ if !exists('pathset') |
    \   let pathset=1 |
    \   set path+=~/work/lib,~/work/lib/specialfunctions,~/work/projectEuler/Library |
    \ endif |
    \ setlocal formatoptions-=o |
    \ set textwidth=120 |
    \ nnoremap <F2> :call CppmanLapack()<CR>
    autocmd BufWritePost *.c,*.cpp,*.h :TlistUpdate

    "--- .py files
    let python_highlight_all = 1
    autocmd BufWritePost *.py :TlistUpdate

    autocmd FileType vim nnoremap <buffer> K :execute "tab help " . expand("<cword>")<CR>
    autocmd FileType sh,man nnoremap <buffer> K :execute "Man " . expand("<cword>")<CR>
  augroup END
endif

" }}}
"===== >    FOLDING            ===== {{{
set foldenable                  " enable folding
set foldcolumn=0                " add a fold column
set foldmethod=marker           " detect triple-{ style fold markers
set foldlevelstart=99           "  0: start out with everything folded
                                " 99: start out with everything unfolded
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
"===== >    KEY MAPPINGS       ===== {{{
"--- General
let mapleader = '\'

" goto file
nnoremap gf :vertical wincmd f<CR>
nnoremap gF :w<CR>gf

" Tab backwards!
augroup BackwardTab
  autocmd!
  " I don't know why but the ordinary method doesn't work.
  autocmd BufRead,BufNewFile * inoremap <S-Tab> <C-d>
augroup END

" Mapping of Tilde4nonAlpha to ~
nnoremap <silent> ~ :call Tilde4nonAlpha()<cr>

" Open the TagList plugin
nnoremap <F3> :TlistToggle<CR>

" Call NoMore120
nnoremap <F4> :call ToggleColorcolumn()<CR>
inoremap <F4> <Esc>:call ToggleColorcolumn()<CR>a

" Toggle AutoComplPop
nnoremap <F5> :call ToggleACP()<CR>
inoremap <F5> <Esc>:call ToggleACP()<CR>a

" Toggle paste safe mode
nnoremap <F6> :call TogglePasteSafe()<CR>
inoremap <F6> <Esc>:call TogglePasteSafe()<CR>a

" Toggle spell checking
nnoremap <F7> :setlocal spell!<CR>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>
inoremap <F7> <Esc>:setlocal spell!<CR>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>a

" Type(i) or show(n) the current date stamp
imap <F9> <C-R>=strftime('%d %b %Y %T %z')<CR>
nnoremap <F9> :echo 'Current time is ' . strftime('%d %b %Y %T %z')<CR>

" Set mouse on & off
nnoremap <F10> :call MouseOnOff()<CR>
inoremap <F10> <Esc>:call MouseOnOff()<CR>a

" netrw
nnoremap <C-\> :Lexplore<CR>
inoremap <C-\> <Esc>:Lexplore<CR>a

" Reset searches
nmap <silent> <Leader>r :nohlsearch<CR>

" Enter works in normal mode
nmap <CR> :call ToggleACP()<CR>i<C-m><Esc>:call ToggleACP()<CR>:echo<CR>

" To the previous buffer
nnoremap <Leader><Leader><Leader> <C-^>

"--- QuickFix window
" \ll => save the file and make and show the result in the bottom split (cwindow) if there are errors and/or warnings.
" \w => show the cwindow (if exists).
" \c => close the cwindow.
" \. => jump to the next problematic line and column of the code.
" \, => jump to the previous problematic line and column of the code.
" \g => from the cwindow, jump to the code where the cursor below indicates.
" \e => will run a program xxx if it is the binary file compiled from the source code with the same name
"       (but extension): xxx.c or xxx.cpp (% is current file name, < eliminates extension)
nmap <Leader>ll :w<CR>:make -Bs<CR>:botright cwindow<CR>
nmap <Leader>w :botright cwindow<CR>
nmap <Leader>c :cclose<CR>
nmap <Leader>. :cnext<CR>
nmap <Leader>, :cprevious<CR>
nmap <Leader>g :.cc<CR>
"nmap <Leader>e :!./%<<CR>
nmap <Leader>e :!./main<CR>

"--- Search in visual mode (* and #)
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
nnoremap <F8> mryi":let @/ = @"<CR>`r

"--- goyo
nnoremap <Leader>f :Goyo<CR>

"--- open URL
nnoremap <silent> go :!open -a Safari <cWORD><CR>
" }}}
