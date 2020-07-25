# Makefile cheatsheet
#
# Maintainer:  Beomjoon Goh
# Last Change: 25 Jul 2020 01:48:47 +0900
# See http://www.gnu.org/software/make/manual/make.html

# Rule {{{
# The first target is run if you don't specify one.
target:
	[commands]
target: prerequisites...
	[commands]
target: prerequisites...
# }}}

# Command {{{
# Each commands are separate invocation of the shell 
# make prints the command before executing.
dummy:
	# this works
	export foo='bar';\
	echo "foo=[$${foo}]"
	# this doesn't
	export foo='bar'
	echo "foo=[$${foo}]"
	# command prefix
	-echo 'A'	# Ignore errors
	+echo 'A'	# Run even if 'make --dry-run' or similary
	@echo 'A'	# Silent
# }}}

# Variables {{{
var := $(foo) # immediate
var  = $(foo) # lazy: evaluated when used.
var ?= $(foo) # set if not exist
var += $(bar) # append

src/%.txt:
	echo $* > $@

$@  # target
$<  # first prerequisite 
$^  # all prerequisites
$?  # all prerequisites newer than the target
$*  # the "stem" part of the rule's % bit
# }}}

# Functions {{{
# files
$(wildcard pattern)
$(dir names...)
$(notdir names...) # extract file part
$(suffix names...)
$(basename names...) # only remove suffix
$(addsuffix suffix, names...)
$(addprefix prefix, names...)
# texts
$(patsubst pattern, replacement, $(text)) 
$(text:pattern=replacement) # no space
$(filter pattern... , text)
$(filter-out pattern... , text)
$(join list1, list2) # innerproduct with concat
# }}}

# Includes {{{
include Makefile.in
# }}}

# Conditionals {{{
ifeq ($(var),foo)
	dothis
else
	dothis
endif

ifeq ($(var),foo)
	dothis
else ($(var),bar)
	dothis
else
	dothis
endif

ifdef $(var)
	dothis
endif 

ifndef $(var)
	dothis
endif 
# }}}
