# vim Directory

## Contents

- [Installation](#installation)
- [Plugins](#plugins)
- [Commands](#commands)
- [User Interfaces](#user-interfaces)
- [Key maps](#key-maps)
- [Todo](#todo)

## Installation

This `vimrc` uses [vim-plug](https://github.com/junegunn/vim-plug) plugin
manager.

To install,
```bash
git clone https://github.com/BeomjoonGoh/vim ~/.vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

And open vimrc,
```vim
:source %
:PlugInstall
```

## Plugins

### [vim-autocomplpop](https://github.com/othree/vim-autocomplpop)

> Auto trigger complete popup menu.

It uses `L9` library.  Global variable `g:acp_enableAtStartup` is on.
Function `ToggleACP()` toggles `autocomplpop` plugin, and it is mapped to
`F5`. For `C`(`C++`) files, complete option is set differently.


### [tagbar](https://github.com/majutsushi/tagbar)

> Vim plugin that displays tags in a window, ordered by scope

Loaded when `:TagbarToggle` is invoked which is mapped to `<F3>`.

```vim
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
```

### [vim-snipmate](https://github.com/garbas/vim-snipmate)

> `SnipMate` aims to provide support for textual snippets, similar to
> `TextMate` or other Vim plugins like `UltiSnips`.

It depends on `vim-addon-mw-utils`, `tlib_vim`.

Snippets are stored in `snippets` directory and triggered with `<Tab>` key.
`g:snipMate.no_default_aliases` is set so that aliases such as `C++` -> `C` is
disabled.

```vim
let g:snipMate = get(g:, 'snipMate', {})
let g:snipMate.no_default_aliases = 1
let g:snipMate.snippet_version = 1
let g:snips_author = "Beomjoon Goh"
```


### [vim-cppman](https://github.com/BeomjoonGoh/vim-cppman)

> A plugin for using [*cppman*](https://github.com/aitjcize/cppman) from within
> Vim. *cppman* is used to lookup "C++ 98/11/14 manual pages for Linux/MacOS"
> through either [cplusplus.com](https://cplusplus.com) or
> [cppreference.com](https://cppreference.com).

Loaded when file type is `cpp`.


### [vim-latex](https://github.com/vim-latex/vim-latex)

> This vim plugin provides a rich tool of features for editing latex files.

Loaded when file type is `tex`.  Settings used are:

```vim
let g:Tex_PromptedCommands    = ''
let g:tex_flavor              = 'latex'
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_ViewRule_pdf        = 'open -a Preview'
let g:Tex_FoldedEnvironments  = ''
let g:tex_indent_brace        = 0
```

Note the following default mappings:
* `<Leader>lv` view pdf.
* `<Leader>ll` compile latex.


### [goyo.vim](https://github.com/junegunn/goyo.vim)

> Distraction-free writing in Vim.

Mapped to `<Leader>f`. Uses user defined `goyo_enter()` to have `number`, and
`colorcolumn`.

```vim
let g:goyo_width  = "120"
let g:goyo_height = "95%"
function! s:goyo_enter()
  set nonu nornu
  highlight ColorColumn ctermbg=234
endfunction
autocmd! User GoyoEnter nested call <SID>goyo_enter()
```


### [vim-indent-object](https://github.com/michaeljsmith/vim-indent-object)

> Vim plugin that defines a new text object representing lines of code at the
> same indent level. Useful for python/vim scripts, etc.


### [vim-easy-align](https://github.com/junegunn/vim-easy-align)

> A Vim alignment plugin

Mapped to `ga`.


### [vim-desertBJ](https://github.com/BeomjoonGoh/vim-desertBJ)

> color scheme based on the default desert.vim, motivated by `desertEx` by Mingbai.


### [vim-txt](https://github.com/BeomjoonGoh/vim-txt)

> This is modified version of 'Vim universal .txt syntax file' by Tomasz
> Kalkosiński.

Syntax for `.txt`, `.out`, etc. defined in `ftdetect/txt.vim`.


### [vim-aftersyntax](https://github.com/BeomjoonGoh/vim-aftersyntax)

> `after/syntax` directory.

It depends on `vim-cpp-enhanced-highlight` plugin.  Supported syntax are: `C`,
`Cpp`, `Fortran`, `Netrw`, `Python`, `QuickFix`, and `TeX`.


### [vim-cpp-enhanced-highlight](https:/github.com/octol/vim-cpp-enhanced-highlight)

> Additional Vim syntax highlighting for C++ (including C++11/14/17).

`vim-aftersyntax` uses this plugin.

```vim
let g:cpp_class_scope_highlight     = 1
let g:cpp_class_decl_highlight      = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_no_function_highlight     = 1
```


### [undotree](https://github.com/mbbill/undotree)

> The undo history visualizer for VIM

Mapped to `<Leader>u`. See `:help undo.txt` for more on builtin undo tree in
vim. A custom diff command which is more git-diff like without headers is used.
Settings used are:

```vim
let g:undotree_WindowLayout             = 2
let g:undotree_SplitWidth               = 24
let g:undotree_DiffpanelHeight          = 6
let g:undotree_SetFocusWhenToggle       = 1
let g:undotree_DiffCommand              = '$HOME/.vim/bin/diff_no_header'
let g:undotree_ShortIndicators          = 1
let g:undotree_HighlightChangedText     = 0
let g:undotree_HighlightChangedWithSign = 0
let g:undotree_HelpLine                 = 0
```


## Commands

For builtin commands `e`, `q`, `qa`, `w`, `wa`, `wq`, `wqa`, `sp`, and `vsp`,
possible uppercase typos are defined.

* `Vfind` works like `find` but in vertical split.
* `Sfind` is `sfind` for completeness.
* `Help` opens help page in new tab not in split
* `Vn`(`Sn`) opens a scratchpad.
* `RemoveTrailingSpaces` does want it sounds like.


## User Interfaces

### Tab page

### Terminal

Terminal api
* `Term`(`Vterm`) runs `bash` shell in terminal emulator
  horizontally(vertically) with a few terminal options. See `:help terminal`.
* `<Leader>cd` changes working directory to the buffer's directory.


## Key maps

The backslash key (`\`) is used as The "mapleader" variable. The characters in
square brakets n, i, v, and t stand for normal, insert, visual, and terminal
mode respectively. See `:help map.txt` for help and `:map` to see defined maps.

### General

| Key     | Mode | Description |
|:-------:|:----:|:------------|
|`gf`     | n    | Go to a file under cursor in vertical split.
|`gF`     | n    | Open a file under cursor to the current window.
|`go`     | n v  | Open URL under cursor
|`<S-Tab>`| i    | Tab backwards.
|`~`      | n    | The `~` key works for non-alphabets as well.
|`<F2>`   | n    | Manual page for `Lapack` library functions if the file is `.c`, `.cpp`, or `.h`
|`<F9>`   | n i  | Type(i) or show(n) the current date and time stamp
|`\r`     | n    | Stop highlight search result
|`\R`     | n    | Brute force reset search
|`<CR>`   | n    | Enter works in normal mode when `autocomplpop` is on.
|`*`, `#` | v    | Search in visual mode
|`<C-y>`  | v    | Yank to clipboard
|`<C-p>`  | n    | Paste from clipboard
|`<F8>`   | n    | Test regular expression under cursor in double quotes
|`ga`     | n x  | Start interactive EasyAlign


### Toggle stuff

| Key     | Mode | Description |
|:-------:|:----:|:------------|
|`<F3>`   | n    | Toggle the `tagbar` plugin
|`<F4>`   | n i  | Toggle `colorcolumn=120`
|`<F5>`   | n i  | Toggle `autocomplpop` plugin
|`<F6>`   | n i  | Toggle smart/auto indent, number, relative number for clipboard paste
|`<F7>`   | n i  | Toggle spell checking
|`<F10>`  | n    | Set mouse on and off
|`<C-\>`  | n    | Toggle `netrw` in the left split
|`\\\`    | n    | Go to the previous buffer
|`<Space>`| n v  | Open/close folds
|`z0`     | n    | Zero fold level
|`\f`     | n    | Toggle `goyo` plugin with +5% offset
|`\iw`    | n    | In diff mode, toggle ignore white spaces
|`\u`     | n    | Toggle `undotree`


### Moving around

| Key    | Mode | Description |
|:------:|:----:|:------------|
|`Arrows`| n t  | Jump around split windows
|`j`     | n    | Go up to the next row for wrapped lines
|`k`     | n    | Go down to the next row for wrapped lines
|`-`     | n    | Move to the end of a line


### QuickFix

| Key | Mode | Description |
|:---:|:----:|:------------|
|`\ll`| n    | Invoke `make` command and open QuickFix window
|`\w` | n    | Open QuickFix window
|`\c` | n    | Close QuickFix window
|`\.` | n    | Jump to the next error/warning
|`\,` | n    | Jump to the previous error/warning
|`\g` | n    | From the QuickFix window, jump to the code where the cursor below indicates
|`\e` | n    | Run `./main`


### Tab page

| Key       | Mode    | Description |
|:---------:|:-------:|:------------|
|`<Tab>:`   | n       | Type `:tab` in command-line
|`<Tab>n`   | n       | Open current buffer in tab
|`<Tab>e`   | n       | Type `:tabedit` in command-line
|`<Tab>gf`  | n       | Open a file under cursor in a new tab page
|`<C-Tab>`  | n i v t | Go to the next tab page (`iTerm` sends `<F11>`)
|`<C-S-Tab>`| n i v t | Go to the previous tab page (`iTerm` sends `<F12>`)
|`<Tab>[N]` | n       | Go to tab number `[N]` = 1 ~ 6

### Todo
- [ ] Make Tilde4nonAlpha work in visual
- [ ] Make plugin
  - [ ] cheatsheet
  - [ ] terminal
- [ ] help paste, pastetoggle
