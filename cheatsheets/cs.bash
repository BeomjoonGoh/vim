#!/usr/bin/env bash
# cs.bash
#
# Maintainer:   Beomjoon Goh
# Last Change:  10 Jul 2020 17:07:41 +0900

# Shell execution {{{
  var=$(cmd)
  $? # exit status of last command
  $! # pid of last command
  $$ # pid of shell
  $0 # script name

  cmd < file      # stdin file to cmd
  cmd > file      # stdout to file
  cmd >> file     # append stdout to file
  cmd 2> err      # stderr to file
  cmd 2>&1        # stderr to stdout
  cmd 2>/dev/null # stderr to a black hole
  cmd &>/dev/null # stdout and stderr to a black hole
# }}}

# Default values {{{
                   | unset FOO    | FOO=''       | FOO='new'
  -----------------+--------------+--------------+--------------
  echo ${FOO:-val} | val          | val          | new          # $FOO, 'val' if unset/empty
  echo ${FOO:=val} | val (stored) | val (stored) | new          # $FOO, FOO='val' if unset/empty
  echo ${FOO:+val} | ''           | ''           | val          # 'val' if $FOO is set
  echo ${FOO:?err} | err (exit)   | err (exit)   | new          # show 'err' and exit if $FOO is unset/empty

                   | unset FOO    | FOO=''       | FOO='new'
  -----------------+--------------+--------------+--------------
  echo ${FOO-val}  | val          | ''           | new          # $FOO, 'val' if unset
  echo ${FOO=val}  | val (stored) | ''           | new          # $FOO, FOO='val' if unset
  echo ${FOO+val}  | ''           | val          | val          # 'val' if $FOO is set
  echo ${FOO?err}  | err (exit)   | ''           | new          # show 'err' and exit if $FOO is unset
# }}}

# Conditionals {{{
  command1 && command2 
  command1 || command2
  ! condition
  if condition; then
    ...
  elif
    ...
  else
    ...
  fi
  case word in
    this|that)
      ;;
    *)
      ;;
  esac

  [ -z string ]   # zero string
  [ -n string ]   # non zero string
  [ -e file ]     # file exist
  [ -f file ]     # file exist and regular
  [ -r file ]     # file exist and readable
  [ -d file ]     # file exist and is directory
  [ -h file ]     # file exist and symbolic
  [ -w file ]     # file exist and writable
  [ -x file ]     # file exist and executable
  [ -o option ]   # shell option is set 
  [ -v variable ] # shell variable is set 

  [ N operation M ] # operation: [integer] -eq, -ne, -lt, -le, -gt, -ge
                    #            [string ] =, !=, <, >

  # bashism
  [[ string == string ]]
  [[ string != string ]]
  [[ string =~ ^rege$ ]] # regular expression (POSIX extended)
  [[ N operation M ]] # operation: ==, !=, <, <=, >, >=
# }}}

# Loops {{{
  for needle in hay; do
    ...
  done

  for i in {1..3}; do
    ...
  done

  while [ condition ]; do
    ...
  done

  until [ condition ]; do
    ... 
  done

  for (( i = 0; i < imax; i++ )); do
    echo "bashism"
  done
# }}}

# Function {{{
  fun() {
    $#  # number of arguments
    $1  # first argument
    $@  # all arguments as an array
    $*  # all arguments as a single string
  }

  # bashism
  function fun() {
    ...
  }
# }}}

# String {{{
  # Substring.
  name="John Doe"
  ${name:0:2}    # = "Jo"
  ${name::2}     # = "Jo"
  ${name::-1}    # = "John Do"
  ${name:(-1)}   # = "e" (from right)
  ${name:(-2):2} # = "oe" (from right)

  # Substitution
  ${FOO/this/that}  # replace first match
  ${FOO//this/that} # replace all
  ${FOO/#this/that} # replace prefix
  ${FOO/%this/that} # replace suffix

  # Remove from left/right
  ${FOO#*this}       # remove first '*this' from left
  ${FOO##*this}      # remove last  '*this' from left
  ${FOO%this*}       # remove first 'this*' from right
  ${FOO%%this*}      # remove last  'this*' from right

  # Length
  ${#FOO}
# }}}

# Expansion {{{
  {A,B}.h   # = A.h B.h
  {1..3}    # = 1 2 3 No variables allowed
  {1..7..2} # = 1 3 5 7
# }}}

# Arithmetic evalutation {{{
  # Operators - grouped into levels of equal-precedence.
  (( id++ id-- ))  # variable post-increment and post-decrement
  (( - +       ))  # unary minus and plus
  (( ++id --id ))  # variable pre-increment and pre-decrement
  (( ! ~       ))  # logical and bitwise negation
  (( **        ))  # exponentiation
  (( * / %     ))  # multiplication, division, remainder
  (( + -       ))  # addition, subtraction
  (( << >>     ))  # left and right bitwise shifts
  (( <= >= < > ))  # comparison
  (( == !=     ))  # equality and inequality
  (( &         ))  # bitwise AND
  (( ^         ))  # bitwise exclusive OR
  (( |         ))  # bitwise OR
  (( &&        ))  # logical AND
  (( ||        ))  # logical OR
  (( expr ? expr : expr ))                # conditional operator
  (( = *= /= %= += -= <<= >>= &= ^= |= )) # assignment
  (( expr1 , expr2))                      # comma

  # Arithmetic Expansion
  $(( expr1 ))

  # NOTE:
  # - Fixed-width integers only.
  # - parameter expansion is performed before evalutation.
  # - Parameter expansion syntax ($) is not necessary.
# }}}

# Arrays {{{
  # Indexed (normal) array 
  ARR=( "foo" "bar" )       # declaration
  ARR[2]="baz"              # set
  ARR=( "${ARR[@]}" "qux" ) # push
  ARR+=( "quux" )           # push
  unset ARR[4]              # remove

  # Associative array (dictionary)
  declare -A ARR            # declaration
  ARR[f]="foo"              # set
  ARR[b]="bar"              # set
  unset ARR[b]              # remove

  # Operations
  "${ARR[key]}"             # access (for indexed array, use int.)
  "${ARR[@]}"               # all values
  "${!ARR[@]}"              # all keys (for indexed array, returns indices.)
  "${#ARR[@]}"              # number of elements
  "${ARR[@]:3:2}"           # sub array from 3, length 2. (associative array has order too)

  # String to array with delimeter. Same as ARR = string.split(',') in python
  IFS=',' read -r -a ARR <<< ${string}
# }}}

# Comment {{{
  # line comment
  : '
  this is
  a multi line comment.
  '
# }}}
