" File: cs.vim
" Author: Beomjoon Goh
" Description: 
" Last Modified: 20 Aug 2020 00:50:23 +0900

" List {{{
"" List creation
let two = 'two'
let mylist = [1, two, 3, 'four']
let emptylist = []
let nestlist = [[11, 12], [21, 22], [31, 32]]

"" List index
let item = mylist[0]		" 1
let item = mylist[2]		" 3
let last = mylist[-1]		" 'four'
let item = nestlist[0][1]	" 12
let mylist[1] = 2
""" NOTE: string can do these except negative numbers

"" List concatenation
let longlist = mylist + [5, 6]  " [1, 'two', 3, 'four', 5, 6]
let mylist += [7, 8]            " [1, 'two', 3, 'four', 5, 6, 7, 8]

"" Sublist
let shortlist = mylist[1:2]	" ['two', 3]
let shortlist = mylist[2:-1]	" [3, 'four', 5, 6, 7, 8]
let endlist   = mylist[2:]	" [3, 'four', 5, 6, 7, 8]
let otherlist = mylist[:]	" make a copy
""" NOTE: string can do these

"" List identity
let list1 = [1, 2, 3]
let list2 = list1               " pointer
call add(list1, 4)
echo list2                      '= [1, 2, 3, 4]'

let list2 = copy(list1)         " same as :let b = a
let list2 = deepcopy(list1)     " same as :let b = a[:]

echo list1 is list2             'checks if two refer to the same List.'
echo list1 == list2             'checks if two have the same value'

"" List unpack
let [var1, var2] = [0, 1]       " error if length is different
let [var1, var2; rest] = mylist
" }}}

" Dictionary {{{
"" Dictionary creation
let emptydict = {}
let mydict = {1: 'one', 2: 'two', 3: 'three'} " Internally A key is always a String.
let mydict = #{zero: 0, one: 1, two-key: 2, 33: 3, four: 4} " Literal Dictionary

"" Accessing entries
let val = mydict['one']
let mydict['four'] = 4
let mydict.four = 4             " if key is \w\+
let mydict['k'] = [ 0, {'key': 'val'} ]
echo mydict.k[1].key            '= val'

"" Dictionary identity
let onedict = {'a': 1, 'b': 2}
let adict = onedict             " pointer
let adict['a'] = 11
echo onedict['a']               '= 11'

"" Dictionary modification
let i = remove(mydict, 'zero')
unlet mydict['k']
call extend(mydict, {'33':'x'}) " For same keys, values are overwritten.
call filter(mydict, 'v:val =~ "x"')

"" Dictionary function
""" with dict attribute
function Mylen() dict
  return len(self.data)
endfunction
let mydict = {
      \ 'data': [0, 1, 2, 3],
      \ 'len': function("Mylen")
      \}
echo mydict.len()               '= 4'

""" directly
let mydict = {'data': [0, 1, 2, 3]}
function mydict.len()
  return len(self.data)
endfunction
echo mydict.len()               '= 4'
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

"" Builtin functions
help functions
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
catch /{pattern}/
throw {expr1}
finally
endtry

echo {expr1} ..
echon {expr1} ..
echomsg {expr1} ..
echoerr {expr1} ..

eval {expr}
execute {expr1} ..

normal[!] {commands}
" }}}

" Namespace {{{
let   foo = 'bar' " In a function: local to a function; otherwise: global
let g:foo = 'bar' " global
let s:foo = 'bar' " script
let l:foo = 'bar' " function
let a:foo = 'bar' " function argument
let v:foo = 'bar' " predefined by vim
let b:foo = 'bar' " current buffer
let w:foo = 'bar' " current window
let t:foo = 'bar' " current tab page
" }}}
