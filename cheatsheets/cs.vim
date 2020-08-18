" File: cs.vim
" Author: Beomjoon Goh
" Description: 
" Last Modified: February 29, 2020

https://github.com/johngrib/vimscript-cheatsheet

" String {{{
" }}}

" List {{{
" }}}

" Dictionary {{{
" }}}

" Expression syntax {{{
" From least to most significant:
" ... indicates that the operations in this level can be concatenated.
expr1   expr2
	expr2 ? expr1 : expr1
expr2	expr3
	expr3 || expr3 ...
expr3	expr4
	expr4 && expr4 ...
expr4	expr5
	expr5 {cmp} expr5	{cmp}: ==, !=, >, >=, <, <=, =~, !~, is, isnot, {cmp}?, {cmp}#
expr5	expr6
	expr6 {opr} expr6 ...	{opr}: +, -, ., ..
expr6	expr7
	expr7 {opr} expr7 ...	{opr}: *, /, %
expr7	expr8
	{opr} expr7		{opr}: !, -, +
expr8	expr9
	expr8[expr1]
	expr8[expr1 : expr1]
	expr8.name
	expr8(expr1, ...)
	expr8->name(expr1, ...)
expr9	number
	"string"
	'string'
	[expr1, ...]
	{expr1: expr1, ...}
	#{key: expr1, ...}
	&option
	(expr1)
	variable
	$VAR
	@r
	function(expr1, ...)
	{args -> expr1}
" }}}

" Function {{{
function[!] {name}([arguments]) [range] [abort] [dict] [closure]
  {commands}
endfunction

delfunction[1] {name}

return {expr}

[range]call {name}([arguments])

"" {name}
  '\([A-Z]\|s:\)[0-9A-Za-z_]*'
  filename#funcname
"" [arguments]
  function Func(n, ...)    " a:1 ~ a:20, a:0, a:000
  function Func(n, m = 0)
" }}}

" Command {{{
let {var} = {expr1}
let {var}[{idx}] = {expr1}
let {var}[{idx1}:{idx2}] = {expr1}
let {var} {opr} {expr1}				{opr}: +=, -=, *=, /=, %=, .=, ..=
let ${env} {opr} {expr1}			{opr}: =, .=
let @{reg} {opr} {expr1}			{opr}: =, .=
let &{opt} {opr} {expr1}			{opr}: =, .=, +=, -=
let [{name1}, {name2}, ...] = {expr1}		{opr}: =, .=, +=, -=
let [{name}, ..., ; {lastname}] = {expr1}	{opr}: =, .=, +=, -=
let {var-name} =<< END
  text...
END

unlet[!] {name} ...
unlet ${env} ...
const {let expr}
lockvar[!] [depth] {name} ...
unlockvar[!] [depth] {name} ...

if {expr1}
  {commands}
elseif {expr1}
  {commands}
else
  {commands}
endif	

while {expr1}
  {commands}
endwhile

for {var} in {object}
  {commands}
endfor
for [{var1}, {var2}, ...] in {listlist}
  {commands}
endfor

continue
break

try
cat[ch] /{pattern}/
throw {expr1}
finally
endtry

echo {expr1} ..
echon {expr1} ..
echomsg {expr1} ..
echoerr {expr1} ..

eval {expr}
execute {expr1} ..
" }}}

" Namespace {{{
let g:foo = 'bar' " global
let s:foo = 'bar' " script
let l:foo = 'bar' " function
let a:foo = 'bar' " function argument
let v:foo = 'bar' " predefined by vim
let b:foo = 'bar' " current buffer
let w:foo = 'bar' " current window
let t:foo = 'bar' " current tab page
" }}}
