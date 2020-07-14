#!/usr/bin/env bash
# setup_bash
#
# Maintainer:   Beomjoon Goh
# Last Change:  14 Jul 2020 19:52:21 +0900

[ -f $HOME/.bashrc ] && source $HOME/.bashrc
[ -f $HOME/.bash_profile ] && source $HOME/.bash_profile

export PATH=$HOME/.vim/bin:$PATH
for comp in "$HOME/.vim/bin/completion.d/"*; do
  source "${comp}"
done
unset comp
