# vim Directory

## Installation

This `vimrc` uses [Vundle](https://github.com/VundleVim/Vundle.vim) plugin manager.

To install,
```bash
git clone https://github.com/BeomjoonGoh/vim ~/.vim
mkdir ~/.vim/bundle # Default installation path for Vundle.
git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
```

And in vim,
```vim
:PluginInstall
```

## Contents
- [Plugins](#installation)
- [Commands](#commands)
- [Key maps](#key-maps)

### Plugins

* [vim-autocomplpop](https://github.com/othree/vim-autocomplpop)

> Auto trigger complete popup menu.

It uses 'L9' library.  Global variable `g:acp_enableAtStartup` is on.
Function `ToggleACP()` toggles `autocomplpop` plugin, and it is mapped to
`F5`. For `C`(`C++`) files, complete option is set differently.


* [vim-snipmate](https://github.com/garbas/vim-snipmate)

> `SnipMate` aims to provide support for textual snippets, similar to
> `TextMate` or other Vim plugins like `UltiSnips`. 

It depends on `vim-addon-mw-utils`, `tlib_vim`. Snippets are stored in
`snippets` directory. `g:snipMate.no_default_aliases` is set so that aliases
such as `C++` -> `C` is disabled.


* [vim-latex](https://github.com/vim-latex/vim-latex)

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


* [goyo.vim](https://github.com/junegunn/goyo.vim)

> Distraction-free writing in Vim.

Mapped to `<Leader>f`. Uses user defined `goyo_enter()` to have `number`, and
`colorcolumn`.


* [vim-indent-object](https://github.com/michaeljsmith/vim-indent-object)

> Vim plugin that defines a new text object representing lines of code at the
> same indent level. Useful for python/vim scripts, etc.


* [vim-cpp-enhanced-highlight](https:/github.com/octol/vim-cpp-enhanced-highlight)

> Additional Vim syntax highlighting for C++ (including C++11/14/17)

`vim-aftersyntax` uses this plugin.


* [vim-taglist](https://github.com/BeomjoonGoh/vim-taglist)

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

<!--
  Plugin 'BeomjoonGoh/vim-cppman'           " cppman within vim on a new tab
  Plugin 'BeomjoonGoh/vim-desertBJ'
  Plugin 'BeomjoonGoh/vim-txt'
  Plugin 'BeomjoonGoh/vim-aftersyntax'      " requires vim-cpp-enhanced-highlight
-->

### Commands
### Key maps

## Todo
* [ ] fork cppman, taglist, txt
* [ ] publish forked plugins and  my owns.
* [ ] find all the references: MyTabLine, MyFoldText, search in visual mode, regex
* [ ] complete this readme
* [ ] publish this repository
