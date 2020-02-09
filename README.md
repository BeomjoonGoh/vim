# vim Directory

## Contents

- [Installation](#installation)
- [Plugins](#plugins)
- [Commands](#commands)
- [Key maps](#key-maps)
- [Todo](#todo)

## Installation

This `vimrc` uses [Vundle](https://github.com/VundleVim/Vundle.vim) plugin manager.

To install,
```bash
git clone https://github.com/BeomjoonGoh/vim ~/.vim
mkdir ~/.vim/bundle    # Default installation path for Vundle.
git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
```

And open vimrc,
```vim
:source %
:PluginInstall
```

## Plugins

### [vim-autocomplpop](https://github.com/othree/vim-autocomplpop)

> Auto trigger complete popup menu.

It uses `L9` library.  Global variable `g:acp_enableAtStartup` is on.
Function `ToggleACP()` toggles `autocomplpop` plugin, and it is mapped to
`F5`. For `C`(`C++`) files, complete option is set differently.


### [vim-snipmate](https://github.com/garbas/vim-snipmate)

> `SnipMate` aims to provide support for textual snippets, similar to
> `TextMate` or other Vim plugins like `UltiSnips`.

It depends on `vim-addon-mw-utils`, `tlib_vim`.

Snippets are stored in `snippets` directory and triggered with `<Tab>` key.
`g:snipMate.no_default_aliases` is set so that aliases such as `C++` -> `C` is
disabled.


### [vim-latex](https://github.com/vim-latex/vim-latex)

> This vim plugin provides a rich tool of features for editing latex files.

Settings used are:
```vim
let g:Tex_PromptedCommands=''
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_ViewRule_pdf = 'open -a Preview'
let g:Tex_FoldedEnvironments=''
let g:tex_indent_brace=0
```

Note the following default mappings:
* `<Leader>lv` view pdf.
* `<Leader>ll` compile latex.


### [goyo.vim](https://github.com/junegunn/goyo.vim)

> Distraction-free writing in Vim.

Mapped to `<Leader>f`. Uses user defined `goyo_enter()` to have `number`, and
`colorcolumn`.


### [vim-indent-object](https://github.com/michaeljsmith/vim-indent-object)

> Vim plugin that defines a new text object representing lines of code at the
> same indent level. Useful for python/vim scripts, etc.


### [vim-cpp-enhanced-highlight](https:/github.com/octol/vim-cpp-enhanced-highlight)

> Additional Vim syntax highlighting for C++ (including C++11/14/17).

`vim-aftersyntax` uses this plugin.


### [vim-taglist](https://github.com/BeomjoonGoh/vim-taglist)

> This is a mirror of [taglist.vim](http://www.vim.org/scripts/script.php?script_id=273).
> Few modifications were add by Beomjoon Goh on top of version 4.6.
>
> The "Tag List" plugin is a source code browser plugin for Vim and provides
> an overview of the structure of source code files and allows you to
> efficiently browse through source code files for different programming
> languages.

Mapped to `<F3>` to toggle the taglist. For `C`, `C++` and `Python` codes,
taglist is updated upon writing.  Settings used are:

```vim
let Tlist_Exit_OnlyWindow=1
let Tlist_WinWidth=30
let Tlist_Use_Right_Window=1
let Tlist_Compact_Format=1
let Tlist_Enable_Fold_Column=0
```

### [vim-desertBJ](https://github.com/BeomjoonGoh/vim-desertBJ)

> color scheme based on the default desert.vim, motivated by `desertEx` by Mingbai.


### [vim-aftersyntax](https://github.com/BeomjoonGoh/vim-aftersyntax)

> `after/syntax` directory.

It depends on `vim-cpp-enhanced-highlight` plugin.  Supported syntax are: `C`,
`Cpp`, `Fortran`, `Netrw`, `Python`, `QuickFix`, and `TeX`.


### [vim-txt](https://github.com/BeomjoonGoh/vim-txt)

> This is modified version of 'Vim universal .txt syntax file' by Tomasz
> Kalkosiński.

Syntax for .txt, .out, etc. defined in `ftdetect/txt.vim`.

### [vim-cppman](https://github.com/BeomjoonGoh/vim-cppman)

> A plugin for using [*cppman*](https://github.com/aitjcize/cppman) from within
> Vim. *cppman* is used to lookup "C++ 98/11/14 manual pages for Linux/MacOS"
> through either [cplusplus.com](https://cplusplus.com) or
> [cppreference.com](https://cppreference.com).


## Commands

For builtin commands `e`, `q`, `qa`, `w`, `wa`, `wq`, `wqa`, `sp`, and `vsp`,
possible uppercase typos are defined.

* `Find` works like `find` but in vertical split.
* `Help` opens help page in new tab not in split
* `Term`(`Vterm`) runs `bash` shell in terminal emulator
  horizontally(vertically) with a few terminal options. See `:help terminal`.
* `Vn`(`Sn`) opens a scratchpad.
* `RemoveTrailingSpaces` does want it sounds like.


## Key maps

The backslash key (`\`) is used as The "mapleader" variable. The characters in
square brakets n, i, v, and t stand for normal, insert, visual, and terminal
mode respectively. See `:help map.txt` for help and `:map` to see defined maps.

### General

* `gf` [n] Go to a file under cursor in vertical split.
* `gF` [n] Open a file under cursor to the current window.
* `go` [n,v] Open URL under cursor
* `<S-Tab>` [i] Tab backwards.
* `~` [n] The `~` key works for non-alphabets as well.
* `<F2>` [n] Manual page for `Lapack` library functions if the file is `.c`,
  `.cpp`, or `.h`
* `<F9>` [n,i] Type(i) or show(n) the current date and time stamp
* `<Leader>r` [n] Stop highlight search result
* `<Leader>R` [n] Brute force reset search
* `<CR>` [n] Enter works in normal mode when `autocomplpop` is on.
* `*` [v] Search in visual mode
* `#` [v] Search in visual mode
* `<C-y>` [v] Yank to clipboard
* `<C-p>` [n] Paste from clipboard
* `<F8>` [n] Test regular expression under cursor in double quotes


### Toggle stuff

* `<F3>` [n] Toggle the `TagList` plugin
* `<F4>` [n,i] Toggle `colorcolumn=120`
* `<F5>` [n,i] Toggle `autocomplpop` plugin
* `<F6>` [n,i] Toggle smart/auto indent, number, relative number for clipboard
  paste
* `<F7>` [n,i] Toggle spell checking
* `<F10>` [n] Set mouse on and off
* `<C-\>` [n] Toggle `netrw` in the left split
* `<Leader><Leader><Leader>` [n] Go to the previous buffer
* `<Space>` [n,v] Open/close folds
* `z0` [n] Zero fold level
* `<Leader>f` [n] Toggle `goyo` plugin
* `<Leader>iw [n] In diff mode, toggle ignore white spaces


### Moving around

* `Arrow key` [n,t] Move around windows
* `j` [n] Go up to the next row for wrapped lines
* `k` [n] Go down to the next row for wrapped lines
* `-` [n] Move to the end of a line


### QuickFix

* `<Leader>ll` [n] Invoke `make` command and open QuickFix window
* `<Leader>w` [n] Open QuickFix window
* `<Leader>c` [n] Close QuickFix window
* `<Leader>.` [n] Jump to the next error/warning
* `<Leader>,` [n] Jump to the previous error/warning
* `<Leader>g` [n] From the QuickFix window, jump to the code where the cursor
  below indicates
* `<Leader>e` [n] Run `./main`


### Tab page

* `<Tab>:` [n] Type `:tab` in command-line
* `<Tab>n` [n] Open current buffer in tab
* `<Tab>e` [n] Type `:tabedit` in command-line
* `<Tab>gf` [n] Open a file under cursor in a new tab page
* `<C-Tab>` [n,i,v,t] Go to the next tab page (`iTerm` sends `<F11>`)
* `<C-S-Tab>` [n,i,v,t] Go to the previous tab page (`iTerm` sends `<F12>`)
* `<Tab>[num]` [n] Go to tab number `[num]` = 1 ~ 6

### Todo
[ ] `<Leader>cd` changes working directory to the buffer's directory.
[ ] Terminal api
