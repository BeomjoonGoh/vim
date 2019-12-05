"""""""""""""""""""""""""""""""""""""""""""""""""
"               [.vimrc file]                   "
"""""""""""""""""""""""""""""""""""""""""""""""""
"                                               "
" Maintainer:   Beomjoon Goh (bjgoh1990)        "
" LastChange:   14 Apr 2019 02:33:08 -0400      "
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

set nocompatible
filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'file:///Users/bjgoh1990/.vim/bundle/desertBJ.vim'

call vundle#end()
filetype plugin on
filetype indent on

"===== >    GENERAL            ===== {{{
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif
set history=100
set viminfo='20,\"50,n~/.vim/viminfo " read/write a .viminfo file, don't store more
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
    "command Term botright terminal ++close ++rows=10 bash -ls
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
  command RemoveTrailingSpaces call RemoveTrailingSpaces()
endif
" }}}
"===== >    USER INTERFACES    ===== {{{
"--- Command & Status line
set cmdheight=1                 " Command mode height
set noshowcmd
set laststatus=2                " Show the status line
set statusline=%!MyStatusLine()
function! MyStatusLine()
  return '%h%f %m%r  pwd: %<%{getcwd()} %=%(C: %c%V, L: %l/%L%) %P '
  " Default value: '%<%f %h%m%r%=%-14.(%l,%c%V%) %P'
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
let nSpace=2
let &shiftwidth=nSpace          " Indents width
let &softtabstop=nSpace         " <BS> regards 'nSpace' spaces as one character
                                " :%retab replaces all \t's to spaces
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
  "This has potential of slowing down scrolling when combined with iTerm2"
  autocmd!
  autocmd BufEnter,FocusGained *
  \ if (&filetype!="help" && &filetype!="taglist" && &filetype!="netrw" && &filetype!="cppman") |
  \   set relativenumber |
  \ endif
  autocmd BufLeave,FocusLost * set norelativenumber
augroup END

"--- Spell check
set spellsuggest=best,3        " 'z=' shows 3 best suggestions

"--- Color column
let s:nomore120 = 0

"--- About the split
set splitbelow
set splitright

"--- netrw
let g:netrw_winsize=25        " window size
let g:netrw_liststyle=3       " tree style
let g:netrw_banner=0          " no banner
let g:netrw_browse_split=2    " <CR> :vsp 'selected file'
" }}}
"===== >    FUNCTIONS          ===== {{{
" Toggle highlight characters over 120 columns
function! ToggleNoMore120()
  if exists('+colorcolumn')
    if s:nomore120
      echo "Highlight char 120+ ON"
      set colorcolumn=120
      let s:nomore120 = 0
    else
      echo "Highlight char 120+ OFF"
      set colorcolumn=
      let s:nomore120 = 1
    endif
  endif
endfunction
silent call ToggleNoMore120()
" Sets mouse on and off. Utilized with keymap F10
function! MouseOnOff()
  let mou=&mouse
  if (mou == "")
    set mouse=a
    echo "Mouse On"
  else
    set mouse=""
    echo "Mouse Off"
  endif
endfunction
" Toggle paste safe mode
function! TogglePasteSafe()
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
" ~ key behaviour for non-alphabets
function! Tilde4nonAlpha() " {{{
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
" Remove every trailing spaces
function RemoveTrailingSpaces()
  %s/\s\+$//e
endfunction
" }}}
"===== >    COLOR              ===== {{{
set t_Co=256                    " Default: 8
colorscheme desertBJ            " Default: bclear?
highlight mParens ctermfg=246 cterm=BOLD
highlight mOper   ctermfg=180 cterm=BOLD

highlight link texMathSymbol  Function
highlight link texRefZone     String
highlight link texSuperscript texMath
highlight link texSubscript   texMath
highlight link texMath        Number
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

" Call NoMore120
nnoremap <F4> :call ToggleNoMore120()<CR>
inoremap <F4> <Esc>:call ToggleNoMore120()<CR>a

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
nnoremap <Tab>e :tabedit 
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

"nnoremap <F4> mryi":let @/ = @"<CR>`r
" }}}
