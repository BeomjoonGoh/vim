" vimrc file
" Languague:    vim
" Maintainer:   Beomjoon Goh
" Last Change:  01 Jan 2024 23:21:31 +0900

" GENERAL {{{
set nocompatible

if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
  set fileencodings=ucs-bom,utf-8,latin1,cp949
endif

let mapleader = '\'

call plug#begin('~/.vim/plugged')
  " General
  Plug 'othree/vim-autocomplpop' | Plug 'vim-scripts/L9'
  Plug 'junegunn/vim-easy-align', { 'on' : ['<Plug>(EasyAlign)', 'EasyAlign'] }
  Plug 'BeomjoonGoh/vim-easy-term'
  Plug 'tpope/vim-fugitive'
  Plug 'junegunn/vim-peekaboo'
  Plug 'garbas/vim-snipmate' | Plug 'MarcWeber/vim-addon-mw-utils' | Plug 'tomtom/tlib_vim'
  if v:version >= 800 | Plug 'jmckiern/vim-venter' | endif
  Plug 'lyokha/vim-xkbswitch',    { 'on' : 'EnableXkbSwitch' }
  Plug 'majutsushi/tagbar',       { 'on' : 'TagbarToggle' }
  Plug 'mbbill/undotree',         { 'on' : 'UndotreeToggle' }

  " Filetype
  Plug 'BeomjoonGoh/vim-cppman',       { 'for' : 'cpp' }
  Plug 'vim-latex/vim-latex',          { 'for' : 'tex' }
  Plug 'raingo/vim-matlab'
  if v:version >= 704
    Plug 'iamcco/markdown-preview.nvim', { 'for': 'markdown', 'do': ':call mkdp#util#install()' }
  endif

  " Colorscheme & Syntax
  Plug 'BeomjoonGoh/vim-aftersyntax'
  Plug 'octol/vim-cpp-enhanced-highlight'
  Plug 'BeomjoonGoh/vim-desertBJ'
  Plug 'shiracamus/vim-syntax-x86-objdump-d'
  Plug 'BeomjoonGoh/txt.vim'
call plug#end()

augroup last_cursor                   " Open file at the last cursor position
  autocmd!
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line ("'\"") <= line("$") && &filetype !~# 'commit' |
      \   execute 'normal! g`"' |
      \ endif
augroup END

set history=100
set viminfo='50,\"50,n$HOME/.vim/.viminfo " read/write a .viminfo file, don't store more
set backspace=indent,eol,start        " backspacing over everything in insert mode
set scrolloff=1 sidescroll=5
set clipboard=exclude:.*              " Fixes slow startup with ssh!! Same as $ vim -X
set lazyredraw ttyfast                " Not sure but it makes scrolling faster
set formatoptions+=rnl
if v:version >= 704
  set formatoptions+=j
endif
set timeoutlen=500
set updatetime=500
set synmaxcol=512
if exists('+regexpengine')
  set regexpengine=0
endif
set mouse=""
set nowrap
set diffopt=filler,context:3
if v:version >= 802 && !(has('mac') && $VIM == '/usr/share/vim')
  set diffopt+=internal
endif
set spellsuggest=best,3
set splitbelow splitright
set incsearch hlsearch

let $BASH_ENV = "$HOME/.config/bash_scripts/aliases.bash"

"--- Indent & tab
set autoindent smartindent
set tabstop=8
set expandtab
set shiftwidth=2
set softtabstop=2                     " :%retab replaces all \t's to spaces

"--- Insert mode completion
set dictionary+=/usr/share/dict/words,~/.vim/spell/en.utf-8.add
set complete=.,w,b,u,t
set completeopt+=menuone
if v:version >= 800
  set completeopt+=noinsert
endif

"--- Command line
set cmdheight=1
set noshowcmd
set wildmenu
set wildmode=list:longest,full
let &fillchars = 'vert: ,fold: ,diff: '
if exists('+fileignorecase')
  set nofileignorecase
endif

"--- Statusline
set laststatus=2
set statusline=%!MyStatusLine()
function! StatusLineGit() abort
  if !exists('g:loaded_fugitive') || getbufvar('%', '&buftype') == 'terminal' 
    return ''
  endif
  let l:branch = FugitiveHead()
  return empty(l:branch) ? '' : '['.l:branch.'] '
endfunction

function! StatusLinePath() abort
  let l:path = fnamemodify(getcwd(), ":~:.")
  return len(l:path) > winwidth(0)/3 ? pathshorten(l:path) : l:path
endfunction

function! StatusLineFile() abort
  if empty(expand("%"))
    return s:EmptyFileName('%')
  endif
  let l:file = fnamemodify(expand("%"), ":~:.")
  return len(l:file) > winwidth(0)/2 ? pathshorten(l:file) : l:file
endfunction

function! MyStatusLine() abort
  let l:machine = empty($MACHINE_NAME) ? 'cwd' : $MACHINE_NAME
  return '%{StatusLineGit()}%h%{StatusLineFile()} %m%r  '.l:machine.':%<%{StatusLinePath()} %=%(%c%V, %l/%L%) %P'
endfunction

"--- Tabline
set showtabline=2
set tabline=%!MyTabLine()

function! TabLineLabel(t) abort
  let l:bn = tabpagebuflist(a:t)[tabpagewinnr(a:t) - 1]
  let l:f = fnamemodify(bufname(l:bn), ':t')
  if getbufvar(l:bn, '&filetype') =~ 'help\|man\|qf'
    let l:f = '['.getbufvar(l:bn, '&filetype').'] '.fnamemodify(l:f, ':r')
  endif
  let l:line = empty(l:f) ? s:EmptyFileName(l:bn) : l:f

  let l:m = ''
  for l:b in tabpagebuflist(a:t)
    if getbufvar(l:b, '&modified') && getbufvar(l:b, '&buftype') != 'terminal'
      let l:m = l:b == l:bn ? ' [+]' : ' [*]'
      break
    endif
  endfor
  let l:nwin = tabpagewinnr(a:t, '$')
  return l:line . l:m . (l:nwin > 1 ? ' ('.l:nwin.') ' : ' ')
endfunction

function! MyTabLine() abort
  let l:line = repeat(' ', &numberwidth+&foldcolumn)
  for l:t in range(1, tabpagenr('$'))
    let l:s = l:t == tabpagenr() ? 'Sel' : ''
    let l:line .= '%'.l:t.'T%#TabNum'.l:s.'# '.l:t.' %#TabLine'.l:s.'#'
    let l:line .= TabLineLabel(l:t)
  endfor
  return l:line.'%T%#TabLineFill#%=%999XX'
endfunction

"--- Linenumber
set numberwidth=4
set number
if exists('+relativenumber')
  set relativenumber              " it may slow down scrolling.
endif
function! s:NoRnuWinLeaveToggle(...) abort
  if !exists('+relativenumber')
    return
  endif
  if exists('#no_rnu#WinLeave') || get(a:,1,0)
    augroup no_rnu
      autocmd!
    augroup END
  else
    augroup no_rnu
      "Turn off relativenumber for not-current windows.
      autocmd!
      autocmd WinLeave * setlocal norelativenumber
      autocmd WinEnter *
          \ if &filetype !~ '\vhelp|man|diff|tagbar|undotree' |
          \   set relativenumber< |
          \ endif
    augroup END
  endif
endfunction
call s:NoRnuWinLeaveToggle()

"--- Fold
set foldenable
set foldcolumn=0
set foldmethod=marker
set foldlevelstart=99
set foldnestmax=4
set foldminlines=1
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
set foldtext=MyFoldText()
function! MyFoldText() abort
  let l:line = substitute(getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g')
  let l:nfolded = v:foldend - v:foldstart
  let l:maxline = winwidth(0) - &foldcolumn - &number * &numberwidth - len(l:nfolded) - len(' lines ') - 1 
  let l:line = strpart(l:line, 0, l:maxline)
  let l:char = matchstr(split(&fillchars,','), 'fold:.')[-1:]
  return l:line . repeat(empty(l:char) ? '-' : l:char, l:maxline-len(l:line)+1) . l:nfolded . ' lines '
endfunction

"--- GUI
if has("gui_running")
  set guicursor=a:block,a:blinkon0
  set guitablabel=%!MyGuiTabLabel()
  function! MyGuiTabLabel() abort
    return '%N '. TabLineLabel(v:lnum)
  endfunction

  if has("gui_macvim")
    set guifont=Monaco:h14
    highlight Normal guibg=black
    set transparency=20
    set macmeta
    let macvim_skip_cmd_opt_movement = 1
    let macvim_skip_colorscheme = 1
    let g:macvim_default_touchbar_characterpicker = 0
  endif
endif

"--- Helper functions
function! s:EmptyFileName(bufnr) abort
  let l:special_names = { 'nofile':'[Scratch]', 'prompt':'[Prompt]', 'popup':'[Popup]' }
  return get(l:special_names, getbufvar(a:bufnr,'&buftype'), '[No Name]')
endfunction

function! s:Noremap(modelist, key, cmd) abort
  if !has('terminal')
    call filter(a:modelist, 'v:val != "t"')
  endif
  for l:mode in a:modelist
    execute l:mode.'noremap' a:key get({'i':'<C-o>', 't':'<C-w>'}, l:mode, '').a:cmd
  endfor
endfunction 

function! s:GetSelectedText() abort
  let l:old_reg = getreg('"')
  let l:old_regtype = getregtype('"')
  normal! gvy
  let l:ret = getreg('"')
  call setreg('"', l:old_reg, l:old_regtype)
  execute "normal! \<Esc>"
  return l:ret
endfunction

function! s:EchoOnOff(str, bool) abort
  echo a:str strpart('offon', 3*!empty(a:bool), 3)
endfunction

" }}}
" FILETYPE SPECIFIC {{{
"--- .tex files
let g:tex_flavor = 'latex'
"--- .py files
let python_highlight_all = 1
"--- .md files
let g:markdown_fenced_languages = [ 'bash=sh', 'vim', 'python', 'cpp', 'calendar' ]
let g:markdown_minlines         = 200
let g:markdown_folding          = 1
"--- man page
let g:ft_man_open_mode      = 'tab'
let g:ft_man_folding_enable = 1

augroup user_filetype
  autocmd!
  autocmd FileType tex
  \ setlocal textwidth=120 |
  \ setlocal foldlevel=99

  autocmd FileType c,cpp
  \ setlocal cindent |
  \ if !exists('pathset') |
  \   let pathset = 1 |
  \   set path+=$HOME/work/include,$HOME/work/include/specialfunctions |
  \ endif |
  \ setlocal formatoptions-=o |
  \ setlocal textwidth=120 |
  \ setlocal foldmethod=syntax |
  \ nnoremap <F2> :execute "Man" substitute(expand("<cword>"), '_', '','g')<CR>

  autocmd FileType python
  \ setlocal keywordprg=pydoc3 |
  \ setlocal foldmethod=indent

  autocmd FileType markdown
  \ syntax match markdownTime display '\<\%([01]\=\d\|2[0-3]\):[0-5]\d\%(:[0-5]\d\)\=' |
  \ syntax match markdownTime display '\<\%(0\=[1-9]\|1[0-2]\):[0-5]\d\%(:[0-5]\d\)\=\s*[AaPp][Mm]' |
  \ syntax match markdownDayDate "\<\(Mon\|Tue\|Wed\|Thu\|Fri\|Sat\|Sun\)\s\+\d\{1,2}\>" |
  \ highlight link markdownTime Type |
  \ highlight link markdownDayDate Identifier |
  \ set foldtext=MyFoldText()
    
  autocmd FileType sh 
  \ runtime! ftplugin/man.vim |
  \ nnoremap <buffer> K :execute 'Man' expand("<cword>")<CR>

  autocmd FileType vim nnoremap <buffer> K :execute 'tab help' expand("<cword>")<CR>
  autocmd FileType gitcommit setlocal spell

  autocmd FileType matlab
  \ compiler mlint |
  \ setlocal shiftwidth=4 softtabstop=4
augroup END

" }}}
" COMMAND {{{
"--- Commands
function! s:LUpermute(res,str) abort
  if empty(a:str)
    return [a:res]
  endif
  return s:LUpermute(a:res.tolower(a:str[0]), a:str[1:]) + s:LUpermute(a:res.toupper(a:str[0]), a:str[1:])
endfunction
function! s:CommandLowerUpper(cmds, opts, args) abort
  for l:cmd in a:cmds
    for l:perm in <SID>LUpermute(toupper(l:cmd[0]),l:cmd[1:])
      execute 'command!' a:opts l:perm l:cmd.a:args
    endfor
  endfor
endfunction
call <SID>CommandLowerUpper(['e','w','wq'], '-bang -nargs=? -complete=file', '<bang> <args>')
call <SID>CommandLowerUpper(['wqa','wa','qa', 'q'], '-bang', '<bang>')
call <SID>CommandLowerUpper(['sp','vsp'],'-nargs=? -complete=file', ' <args>')

if v:version >= 704
  command! -nargs=? -complete=file_in_path Vfind vertical sfind <args>
  command! -nargs=? -complete=file_in_path Tfind tab sfind <args>
  command! -nargs=? -complete=file_in_path Sfind sfind <args>
else
  command! -nargs=? -complete=file Vfind vertical sfind <args>
  command! -nargs=? -complete=file Tfind tab sfind <args>
  command! -nargs=? -complete=file Sfind sfind <args>
endif
command! -nargs=? -complete=help Help tab help <args>
command! RemoveTrailingSpaces %s/\m\s\+$//e
command! Source source $HOME/.vim/vimrc

function! s:CompleteIncludeToggle() abort
  execute 'set' 'complete'.((&complete =~ 'i') ? '-=' : '+=').'i'
  echo 'complete =' &complete
endfunction
command! CompleteIncludeToggle call <SID>CompleteIncludeToggle()

function! s:ClearNamedRegisters() abort
  for i in split('abcdefghijklmnopqrstuvwxyz','\zs')
    call setreg(i,'')
  endfor
endfunction
command! ClearNamedRegisters call <SID>ClearNamedRegisters()

function! s:GotoBuffer(cmd, pattern) abort
  let l:colon = getbufvar('%', '&buftype') == 'terminal' ? "\<C-w>:" : ":" 
  if empty(a:pattern)
    call feedkeys(l:colon.a:cmd." \<C-d>")
    return
  elseif a:pattern is '*'
    call feedkeys(l:colon."ls\<CR>".l:colon.a:cmd." ")
    return
  endif

  let l:globbed = a:pattern =~ '^\d\+$' ? str2nr(a:pattern) : '*'. substitute( substitute(a:pattern,'\s','*','g'), '\\\*','\\ ','g') . '*'
  try
    execute 'sbuffer' l:globbed
    let l:bn = bufnr('%')
    quit!
    for l:t in range(1, tabpagenr('$'))
      if index(tabpagebuflist(l:t), l:bn) != -1
        execute "tabnext" l:t 
        execute bufwinnr(l:bn).'wincmd w'
        return
      endif
    endfor
    execute 'vertical sbuffer' l:bn
  catch
    call feedkeys(l:colon.a:cmd." ".l:globbed."\<C-d>\<C-u>".a:cmd." ".a:pattern)
  endtry
endfunction
command! -nargs=? -complete=buffer B call <SID>GotoBuffer('B', <q-args>)

if has('mac')
  function! s:OpenFinder() abort
    let l:cmd = '!open ' . (filereadable(expand('%')) ? '-R '.shellescape('%') : '.')
    execute 'silent!' l:cmd
    redraw!
  endfunction
  command! OpenFinder call <SID>OpenFinder()
endif

"--- Cheatsheet
let g:cheatsheet_filetypeDict = {
      \  'sh'       : 'bash',
      \  'markdown' : 'md',
      \  'make'     : 'makefile',
      \  'gnuplot'  : 'gpi',
      \} "filetype  : extension
let g:cheatsheet_command = 'vertical 90 new'
let g:cheatsheet_path = expand("<sfile>:p:h").'/cheatsheets'

function! Cheatsheet_getfile(ft) abort
  return g:cheatsheet_path . '/cs.' . get(g:cheatsheet_filetypeDict, a:ft, a:ft)
endfunction

function! Cheatsheet_open(cmd, ft) abort
  let l:file = Cheatsheet_getfile(empty(a:ft) ? &filetype : a:ft)
  if a:cmd == 'view' && !filereadable(l:file)
    echomsg 'cheatsheet does not exist:' l:file
    return
  endif
  execute g:cheatsheet_command
  execute a:cmd l:file
endfunction

function! Cheatsheet_complete(A,L,P) abort
  return "bash\ngit\ngpi\nmakefile\nmd\nregex\nvim"
endfunction

command! -bang -nargs=? -complete=custom,Cheatsheet_complete Cheat     call Cheatsheet_open('view', <q-args>)
command! -bang -nargs=? -complete=custom,Cheatsheet_complete CheatEdit call Cheatsheet_open('edit', <q-args>)

" }}}
" TEXT OBJECT {{{
" l : line, / : search, ? : search, i : indent, n : number
call s:Noremap(['x','o'], '<silent> il', ':<C-u>normal! ^vg_<CR>')
call s:Noremap(['x','o'], '<silent> al', ':<C-u>normal! 0v$<CR>')

call s:Noremap(['x','o'], '<silent> i/', ':<C-u>execute "normal!" "g".(v:searchforward ? "n":"N")<CR>')
call s:Noremap(['x','o'], '<silent> i?', ':<C-u>execute "normal!" "g".(v:searchforward ? "N":"n")<CR>')

function! s:TextObjectIndent(mode, begin, end, around) abort
  let l:bound = [a:begin, a:end]
  let l:indent = min(map(l:bound[:], 'indent(v:val)'))
  let l:last = line('$')
  if l:indent == 0 && empty(getline(l:bound[0])) && empty(getline(l:bound[1]))
    let [l:b, l:e] = l:bound[:]
    while l:indent == 0 && l:b > 0 && l:e <= l:last
      let l:b -= 1
      let l:e += 1
      let l:indent = min(filter(map([l:b, l:e], 'indent(v:val)'), 'v:val != 0'))
    endwhile
  endif

  for [l:i, l:expr, l:step] in [[0, '> 1', -1], [1, '< l:last', +1]]
    while eval('l:bound[l:i]'.l:expr) && (indent(l:bound[l:i]+l:step) >= l:indent || empty(getline(l:bound[l:i]+l:step)))
      let l:bound[l:i] += l:step
    endwhile
  endfor
  let l:vis = a:mode == 'v' ? 'V' : a:mode
  execute 'normal!' max([1, l:bound[0] - a:around]).'G'.l:vis.(l:bound[1] + a:around).'G'
endfunction
xnoremap <silent> ii :<C-u>call <SID>TextObjectIndent(visualmode(), line("'<"), line("'>"), 0)<CR>
onoremap <silent> ii :<C-u>call <SID>TextObjectIndent('V',          line('.'),  line('.'),  0)<CR>
xnoremap <silent> ai :<C-u>call <SID>TextObjectIndent(visualmode(), line("'<"), line("'>"), 1)<CR>
onoremap <silent> ai :<C-u>call <SID>TextObjectIndent('V',          line('.'),  line('.'),  1)<CR>

function! s:TextObjectNumber(around) abort
  let l:re_num = ['0b[01]\+', '0x\x\+', '[+-]\?\(\d\+\(\.\d*\)\?\|\.\d\+\)\%([eE][+-]\?\d\+\)\?']
  let l:pattern = join(a:around ? map(l:re_num, '''\s*''.v:val.''\s*''') : l:re_num, '\|')
  let l:p0 = getpos(".")[1:2]
  let l:p1 = searchpos(l:pattern, 'cb', l:p0[0])
  if l:p1[0]
    let l:p2 = searchpos(l:pattern, 'cne', l:p0[0])
    if l:p1[1] <= l:p0[1] && l:p0[1] <= l:p2[1]
      call cursor(l:p1)
      normal! v
      call cursor(l:p2)
    else
      call cursor(l:p0)
    endif
  endif
endfunction
call s:Noremap(['x','o'], '<silent> in', ':<C-u>call <SID>TextObjectNumber(0)<CR>')
call s:Noremap(['x','o'], '<silent> an', ':<C-u>call <SID>TextObjectNumber(1)<CR>')

" }}}
" KEY MAPPING {{{
"--- General
" Goto
nnoremap gf :vertical wincmd f<CR>
nnoremap gF :w<CR>gf
nnoremap gb :B<CR>
nnoremap gl yiw:execute (@" =~ '^\d\+$' ? 'normal! @"G' : '')<CR>
if has('mac')
  nnoremap <silent> go :!open <cWORD><CR>
  xnoremap <silent> go :<C-u>execute '!open' expand(<SID>GetSelectedText())<CR>
endif

" Tab backwards!
inoremap <S-Tab> <C-d>

" Switch case for non-alphabets
function! s:TildeForNonAlpha(str) abort
  let l:pool = '`1234567890-=[]\;,./''~!@#$%^&*()_+{}|:<>?"'
  let l:lines = 0
  for l:c in split(a:str, '\zs')
    if     l:c =~ '\m\a' | normal! ~
    elseif l:c =~ '\m\s' | normal! l
    elseif l:c =~ '\m\d\|[[:punct:]]'
      execute 'normal!' 'r'.l:pool[((stridx(l:pool,l:c) + 21) % 42)].'l'
    elseif l:c =~ '\m\n'
      let l:lines = l:lines + 1
      execute 'normal! `<'.l:lines.'j'
    endif
  endfor
endfunction
nnoremap <silent> ~ :call <SID>TildeForNonAlpha(getline(".")[col(".")-1])<CR>
xnoremap <silent> ~ :<C-u>call <SID>TildeForNonAlpha(<SID>GetSelectedText())<CR>

" Enter works in normal mode
nmap <silent> <CR> i<C-m><Esc>

" Yank to and paste from clipboard
xnoremap <C-y> "*y
nnoremap <C-p> "*p

" Reset searches
nmap <silent> <Leader>r :nohlsearch<CR>
nmap <silent> <Leader>R :silent!/BruteForceSearchReset_<C-r>=rand()<CR>.<CR>

" Search in visual mode (https://vim.fandom.com/wiki/Search_for_visually_selected_text)
xnoremap <silent> * :call setreg('/', substitute(<SID>GetSelectedText(), '\m\_s\+', '\\_s\\+', 'g'))<CR>n
xnoremap <silent> # :call setreg('/', substitute(<SID>GetSelectedText(), '\m\_s\+', '\\_s\\+', 'g'))<Bar>let v:searchforward = 0<CR>n

" Toggle vimdiff iwhiteall
if v:version >= 802
  function! s:IwhiteToggle() abort
    execute 'set' 'diffopt'.((&diffopt =~ 'iwhiteall') ? '-=' : '+=').'iwhiteall'
    echo 'diffopt =' &diffopt
  endfunction
  nnoremap <Leader>iw :call <SID>IwhiteToggle()<CR>
endif

" Terminal
if has('terminal')
  tnoremap :: <C-w>:
  tnoremap <S-Space> <Space>
endif

" ColorcolumnToggle
function! s:ColorcolumnToggle() abort
  if exists('+colorcolumn')
    let &colorcolumn = (&colorcolumn == "") ? 120 : ""
    call s:EchoOnOff('colorcolumn', &colorcolumn)
  endif
endfunction
call s:Noremap(['n','i'], '<F4>',  ":call <SID>ColorcolumnToggle()<CR>")

" CopyPasteToggle
function! s:CopyPasteToggle() abort
  if &paste
    setlocal nopaste
    let [ &l:number, &l:relativenumber ] = b:nurnu_before
  else
    setlocal paste
    let b:nurnu_before = [ &l:number, &l:relativenumber ]
    setlocal nonumber
    if exists('+relativenumber')
      set norelativenumber
    endif
  endif
  call s:EchoOnOff('CopyPaste:', &paste)
endfunction
call s:Noremap(['n','i'], '<F6>',  ":call <SID>CopyPasteToggle()<CR>")

" Spell check
call s:Noremap(['n','i'], '<F7>',  ":setlocal spell!<Bar>call <SID>EchoOnOff('Spell:', &spell)<CR>")

" Type(i) or show(n) the current date stamp
inoremap <expr> <F9> strftime('%d %b %Y %T %z')
nnoremap <F9> :echo strftime('%d %b %Y %T %z')<CR>

" Mouse
call s:Noremap(['n','i','t'], '<F10>', ":let &mouse = (&mouse == '') ? 'a' : ''<Bar>:call <SID>EchoOnOff('mouse', &mouse)<CR>")

" latexthis
xnoremap <Leader>lt :write !latexthis --font 20<CR>
nnoremap <Leader>lt :%write !latexthis<CR>

"--- Moving around
" Easy window navigation
" Note: Karabiner maps <C-hjkl> to Arrows
nnoremap <Left> <C-w>h
nnoremap <Down> <C-w>j
nnoremap <Up> <C-w>k
nnoremap <Right> <C-w>l
if has('terminal')
  tnoremap <Left> <C-w>h
  tnoremap <Down> <C-w>j
  tnoremap <Up> <C-w>k
  tnoremap <Right> <C-w>l
  " For completeness. Use readline's normal mode instead
  if has('gui_running')
    tnoremap <A-h> <Left>
    tnoremap <A-j> <Down>
    tnoremap <A-k> <Up>
    tnoremap <A-l> <Right>
  else " iTerm2 maps <A-hjkl> to <C-hjkl>
    tnoremap <C-h> <Left>
    tnoremap <C-j> <Down>
    tnoremap <C-k> <Up>
    tnoremap <C-l> <Right>
  endif
endif

" Go up and down to the next row for wrapped lines
nnoremap j gj
nnoremap k gk

"--- QuickFix window
nnoremap <Leader>ll :w<CR>:make -s<CR>:botright cwindow<CR>
nnoremap <Leader>w :botright cwindow<CR>
nnoremap <Leader>c :cclose<CR>
nnoremap <Leader>n :cnext<CR>
nnoremap <Leader>N :cprevious<CR>
nnoremap <Leader>g :.cc<CR>

"--- Fold
call s:Noremap(['n','x'], '<Space>', 'za')
nnoremap zR zr
nnoremap zr zR
nnoremap zM zm
nnoremap zm zM
for i in range(10)
  execute 'nnoremap' 'z'.i ':set foldlevel='.i.'<CR>'
endfor

"--- Tab page
nnoremap <Tab>: :tab
nnoremap <Tab>n <C-w>T
nnoremap <Tab>e :tabedit<Space>
nnoremap <Tab>gf <C-w>gf

" <C-Tab>   : iTerm Sends HEX code for <F11> "[23~"
" <C-S-Tab> : iTerm Sends HEX code for <F12> "[24~"
if has('gui_running')
  call s:Noremap(['n','i','t'], '<silent> <C-Tab>',   ':tabnext<CR>')
  call s:Noremap(['n','i','t'], '<silent> <C-S-Tab>', ':tabprevious<CR>')
else
  call s:Noremap(['n','i','t'], '<silent> <F11>', ':tabnext<CR>')
  call s:Noremap(['n','i','t'], '<silent> <F12>', ':tabprevious<CR>')
endif

for i in range(1,6)
  execute 'nnoremap' '<Tab>'.i i.'gt'
endfor

" }}}
" PLUGIN {{{
"--- vim-autocomplpop
let g:acp_enableAtStartup        = 1
let g:acp_completeOption         = &complete
let g:acp_completeoptPreview     = 1
let g:acp_behaviorSnipmateLength = -1
let g:acp_behaviorKeywordLength  = 2
let g:acp_behaviorKeywordCommand = "\<C-p>"
call s:Noremap(['n','i'], '<F5>',  ":execute exists('#AcpGlobalAutoCommand#InsertEnter') ? 'AcpDisable' : 'AcpEnable'<Bar>echo 'AcpToggle'<CR>")

"--- vim-easy-align
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

"--- vim-easy-term
if has('terminal')
  let g:easy_term_rows = '15,18%'
  let g:easy_term_cols = '120,33%'
  command! -nargs=? -complete=custom,easy_term#Complete Bterm botright Term <args>
  command! -nargs=? -complete=custom,easy_term#Complete Vterm vertical botright Term <args>
  command! -nargs=? -complete=custom,easy_term#Complete Tterm tab Term <args>
  nmap <Leader>cd <Plug>(EasyTermCdVim)
  tmap <Leader>cd <Plug>(EasyTermCdTerm)
  nmap <Leader>t <Plug>(EasyTermSendText)
  xmap <Leader>t <Plug>(EasyTermSendText)
  nmap <Leader>p <Plug>(EasyTermPutLast)
  tmap <Leader>y <Plug>(EasyTermYankLast)
  tmap <Leader>s <Plug>(EasyTermSet)
  tnoremap <Leader>ll tovim make<CR>
endif

"--- vim-fugitive
command! -bang -nargs=? -range=-1 -complete=customlist,fugitive#Complete Vg   vertical belowright G <args>
command! -bang -nargs=? -range=-1 -complete=customlist,fugitive#Complete Vgit vertical belowright Git <args>

"--- vim-peekaboo
let g:peekaboo_window = 'vertical botright 20new'

"--- vim-snipmate
let g:snips_author = 'Beomjoon Goh'
let g:snipMate = get(g:, 'snipMate', {})
let g:snipMate.no_default_aliases = 1
let g:snipMate.snippet_version    = 1
let g:snipMate.description_in_completion = 1

"--- vim-venter
function! s:VenterCustomToggle() abort
  if exists("t:venter_tabid")
    set showtabline=2
    call VenterClose()
    tabclose
  else
    set showtabline=0
    tab split
    call venter#Venter()
  endif
endfunction
nnoremap <Leader>f :call <SID>VenterCustomToggle()<CR>

"--- vim-xkbswitch
if has('mac')
  let g:XkbSwitchLib = '/usr/local/lib/libInputSourceSwitcher.dylib'
  function! s:XkbSwitchToggle() abort
    if get(g:, 'XkbSwitchEnabled')
      augroup XkbSwitch
        autocmd!
      augroup END
      let g:XkbSwitchEnabled = 0
    else
      EnableXkbSwitch
    endif
    call s:EchoOnOff('XkbSwitch:', g:XkbSwitchEnabled)
  endfunction
  command! XkbSwitchToggle call <SID>XkbSwitchToggle()
endif

"--- tagbar
let g:tagbar_width            = 30
let g:tagbar_compact          = 1
let g:tagbar_indent           = 1
let g:tagbar_show_balloon     = 0
let g:tagbar_map_showproto    = 'f'
let g:tagbar_map_togglefold   = ['<Space>', 'za']
let g:tagbar_map_openallfolds = ['_', '<kMultiply>', 'zR']
let g:tagbar_type_markdown    = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [ 'h:Headings', 'l:Links', 'i:Images' ],
    \ 'sort' : 0,
    \}
let g:tagbar_type_help = {
    \ 'ctagstype' : 'help',
    \ 'kinds' : [ 't:Tags' ],
    \ 'sort' : 0,
    \}
highlight default link TagbarHighlight Visual
call s:Noremap(['n','t'], '<F3>',  ":TagbarToggle<CR>")

"--- undotree
let g:undotree_WindowLayout             = 2
let g:undotree_SplitWidth               = 24
let g:undotree_DiffpanelHeight          = 10
let g:undotree_SetFocusWhenToggle       = 1
let g:undotree_ShortIndicators          = 1
let g:undotree_HighlightChangedText     = 0
let g:undotree_HighlightChangedWithSign = 0
let g:undotree_HelpLine                 = 0
let g:undotree_DiffCommand = 'custom_diff(){ diff -U1 "$@" | tail -n+3;}; custom_diff'
nnoremap <Leader>u :UndotreeToggle<CR>

"--- vim-latex
let g:Tex_PromptedCommands    = ''
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_ViewRule_pdf        = 'open -a Preview'
let g:Tex_FoldedEnvironments  = ''
let g:tex_indent_brace        = 0

"--- markdown-preview.nvim
let g:mkdp_auto_close   = 0
let g:mkdp_refresh_slow = 1

"--- vim-cpp-enhanced-highlight
let g:cpp_class_scope_highlight     = 1
let g:cpp_class_decl_highlight      = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_no_function_highlight     = 1

"--- vim-desertBJ
let &background = has('mac') && system('defaults read -g AppleInterfaceStyle') !~ 'Dark' ? 'light' : 'dark'
colorscheme desertBJ
let g:desertBJ_terminal = 1
" }}}
