# vim Directory

## Contents

- [Installation](#installation)
- [Plugins](#plugins)
- [Commands](#commands)
- [User Interfaces](#user-interfaces)
- [Key maps](#key-maps)

## Installation

This `vimrc` uses [vim-plug](https://github.com/junegunn/vim-plug) plugin
manager.

To install, first clone this repository,
```bash
git clone https://github.com/BeomjoonGoh/vim ~/.vim
```
Then get vim-plug in `~/.vim/autoload/` directory.
```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
Lastly open vimrc (`vim ~/.vim/vimrc`). You would get a few error messages
since none of the plugins are installed yet.  Install all plugins used by this
repository.
```vim
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

<details>
  <summary>Settings</summary>

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
</details>


### [vim-snipmate](https://github.com/garbas/vim-snipmate)

> `SnipMate` aims to provide support for textual snippets, similar to
> `TextMate` or other Vim plugins like `UltiSnips`.

It depends on `vim-addon-mw-utils`, `tlib_vim`.

Snippets are stored in `snippets` directory and triggered with `<Tab>` key.
`g:snipMate.no_default_aliases` is set so that aliases such as `C++` -> `C` is
disabled.

<details>
  <summary>Settings</summary>

  ```vim
  let g:snipMate = get(g:, 'snipMate', {})
  let g:snipMate.no_default_aliases = 1
  let g:snipMate.snippet_version = 1
  let g:snips_author = "Beomjoon Goh"
  ```
</details>


### [vim-cppman](https://github.com/BeomjoonGoh/vim-cppman)

> A plugin for using [*cppman*](https://github.com/aitjcize/cppman) from within
> Vim. *cppman* is used to lookup "C++ 98/11/14 manual pages for Linux/MacOS"
> through either [cplusplus.com](https://cplusplus.com) or
> [cppreference.com](https://cppreference.com).

Loaded when file type is `cpp`.


### [vim-latex](https://github.com/vim-latex/vim-latex)

> This vim plugin provides a rich tool of features for editing latex files.

Loaded when file type is `tex`.

Note the following default mappings:
* `<Leader>lv` view pdf.
* `<Leader>ll` compile latex.

<details>
  <summary>Settings</summary>

  ```vim
  let g:Tex_PromptedCommands    = ''
  let g:tex_flavor              = 'latex'
  let g:Tex_DefaultTargetFormat = 'pdf'
  let g:Tex_ViewRule_pdf        = 'open -a Preview'
  let g:Tex_FoldedEnvironments  = ''
  let g:tex_indent_brace        = 0
  ```
</details>


### [vim-indent-object](https://github.com/michaeljsmith/vim-indent-object)

> Vim plugin that defines a new text object representing lines of code at the
> same indent level. Useful for python/vim scripts, etc.


### [vim-easy-align](https://github.com/junegunn/vim-easy-align)

> A Vim alignment plugin

Mapped to `ga`.


### [undotree](https://github.com/mbbill/undotree)

> The undo history visualizer for VIM

Mapped to `<Leader>u`. See `:help undo.txt` for more info on builtin undo tree
in vim. A custom diff command, which is more git-diff like, is used.

<details>
  <summary>Settings</summary>

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
</details>


### [vim-peekaboo](https://github.com/junegunn/vim-peekaboo)

> Peekaboo extends `"` and `@` in normal mode and `<CTRL-R>` in insert mode so
> you can see the contents of the registers.


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


### [vim-cpp-enhanced-highlight](https://github.com/octol/vim-cpp-enhanced-highlight)

> Additional Vim syntax highlighting for C++ (including C++11/14/17).

`vim-aftersyntax` uses this plugin.

<details>
  <summary>Settings</summary>

  ```vim
  let g:cpp_class_scope_highlight     = 1
  let g:cpp_class_decl_highlight      = 1
  let g:cpp_member_variable_highlight = 1
  let g:cpp_no_function_highlight     = 1
  ```
</details>


### [vim-syntax-x86-objdump-d](https://github.com/shiracamus/vim-syntax-x86-objdump-d)

> vim syntax for x86/x64 disassemble file created by objdump -d or -D


## Commands

For builtin commands `e`, `q`, `qa`, `w`, `wa`, `wq`, `wqa`, `sp`, and `vsp`,
possible uppercase typos are defined.

* `Vfind`(`Sfind`) works like `find` but in vertical(horizontal) split.
* `Help` opens help page in new tab not in split
* `Vn`(`Sn`) opens a scratchpad in vertical(horizontal) split.
* `RemoveTrailingSpaces` does want it sounds like.
* `Source` sources `vimrc`.
* `OpenFinder`<sup>[[1]](#MacOS)</sup> opens a `Finder` window of the current
  buffer.
* `InsertForeign`<sup>[[1]](#MacOS)</sup> invokes the `ToggleInsertForeign()`
  function.  When on, the input method is changed to Korean 2 set layout upon
  entering the insert mode.  When leaving the insert mode, it's changed back
  to US keyboard layout.  It uses the [input source switcher][issw], a command
  line tool for switching the keyboard layout by Vladimir Timofeev.  A global
  variable `g:InsertForeign_InsertLayout` stores which layout to be used.  

[issw]: https://github.com/vovkasm/input-source-switcher


## User Interfaces

For all the settings, for instance, `set nocompatible`, I encourage you to see
the help page for more information (`:help {subject}`).


### Status & Tab line

Statusline:

    ([Help]){file} ([+],[-])([RO])  pwd:{dir}     C: {col}-{vcol}, L: {line}/{tot_lines} {percent} 

Tabline: `{tab}` = `{tab_num} {file} ([+],[*]) (({tot_win}))`

    {tab} {tab} {tab}                                                                       X

* `{file}`: Current buffer name.
* `{dir}`:  Vim's current directory.
* `[+]`: If {file} is modified.
* `[-]`: If {file} is not modifiable.
* `[*]`: If out of focus window is modified.
* `[RO]`: If {file} is read only.
* `X` : Close button for mouse

See `:help statusline, :help tabline`


### Terminal

User defined commands that open `bash` in terminal emulator:

* `Bterm` : `botright call term_start()`
* `Vterm` : `vertical call term_start()`
* `Tterm` : `tab call term_start()`
* `Nterm` : `call term_start()`

Bash is invoked by `bash --rcfile ~/.vim/bin/setup_bash.sh`, which adds
`~/.vim/bin` in `$PATH` environment.  When terminal is opened, window height
(`min(18%, 15)` if `botright`) and width (`min(40%, 150)` if `vertical`) are
fixed. The terminal window is closed once the job is finished.

#### Terminal - Vim communication

`~/.vim/bin/2vim`

#### Vim -Terminal communication


### Cheatsheet


## Key maps

The backslash key (`\`) is used as The "mapleader" variable. The characters n,
i, v, and t stand for normal, insert, visual, and terminal
mode respectively. See `:help map.txt` for help and `:map` to see defined maps.

<details>
  <summary>General</summary>
  
  | Key     | Mode | Description |
  |:-------:|:----:|:------------|
  |`gf`     | n    | Go to a file under cursor in vertical split.
  |`gF`     | n    | Open a file under cursor to the current window.
  |`<S-Tab>`| i    | Tab backwards.
  |`~`      | n    | The `~` key works for non-alphabets as well.
  |`<F2>`   | n    | Manual page for `Lapack` library functions if the file is `.c`, `.cpp`, or `.h`
  |`<F9>`   | n i  | Type(i) or show(n) the current date and time stamp
  |`\r`     | n    | Stop highlight search result
  |`\R`     | n    | Clear search result (register `"/"`)
  |`<CR>`   | n    | Enter works in normal mode when `autocomplpop` is on.
  |`\\\`    | n    | Go to the previous buffer
  |`*`, `#` | v    | Search in visual mode
  |`<C-y>`  | v    | Yank to clipboard (register `"\*`)
  |`<C-p>`  | n    | Paste from clipboard (register `"\*`)
  |`ga`     | n x  | Start interactive EasyAlign
  |`go`<sup>[[1]](#MacOS)</sup>| n v  | Open URL/file under cursor
</details>

<details>
  <summary>Toggle stuff </summary>
  
  | Key     | Mode | Description |
  |:-------:|:----:|:------------|
  |`<F3>`   | n    | Toggle the `tagbar` plugin
  |`<F4>`   | n i  | Toggle `colorcolumn=120`
  |`<F5>`   | n i  | Toggle `autocomplpop` plugin
  |`<F6>`   | n i  | Toggle smart/auto indent, number, relative number for clipboard paste
  |`<F7>`   | n i  | Toggle spell checking
  |`<F10>`  | n    | Set mouse on and off
  |`<C-\>`  | n    | Toggle `netrw` in the left split
  |`<Space>`| n v  | Open/close folds
  |`z[N]`   | n    | Set fold level to `[N]` = 0 ~ 9
  |`\iw`    | n    | In diff mode, toggle ignore white spaces
  |`\u`     | n    | Toggle `undotree`
</details>

<details>
  <summary>Moving around</summary>
  
  | Key    | Mode | Description |
  |:------:|:----:|:------------|
  |`Arrows`| n t  | Jump around split windows
  |`j`     | n    | Go up to the next row for wrapped lines
  |`k`     | n    | Go down to the next row for wrapped lines
</details>

<details>
  <summary>QuickFix</summary>
  
  | Key | Mode | Description |
  |:---:|:----:|:------------|
  |`\ll`| n    | Invoke `make` command and open QuickFix window
  |`\w` | n    | Open QuickFix window
  |`\c` | n    | Close QuickFix window
  |`\.` | n    | Jump to the next error/warning
  |`\,` | n    | Jump to the previous error/warning
  |`\g` | n    | From the QuickFix window, go to the code where error occured.
</details>

<details>
  <summary>Tab page</summary>
  
  | Key       | Mode    | Description |
  |:---------:|:-------:|:------------|
  |`<Tab>:`   | n       | Type `:tab` in command-line
  |`<Tab>e`   | n       | Type `:tabedit` in command-line
  |`<Tab>n`   | n       | Open the current buffer in a new tab page
  |`<Tab>gf`  | n       | Open a file under cursor in a new tab page
  |`<C-Tab>`  | n i v t | Go to the next tab page (`iTerm` sends `<F11>`)
  |`<C-S-Tab>`| n i v t | Go to the previous tab page (`iTerm` sends `<F12>`)
  |`<Tab>[N]` | n       | Go to `[N]`th tab page, `[N]` = 1 ~ 6
</details>

## Todo
- [x] Make Tilde4nonAlpha work in visual
- [ ] Make plugin
  - [ ] cheatsheet
  - [ ] terminal
- [ ] help paste, pastetoggle

<b name="MacOS">[1]</b>: Defined for MacOS only.
