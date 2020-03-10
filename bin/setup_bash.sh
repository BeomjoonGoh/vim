#!/usr/bin/env bash
# setup_bash
#
# Maintainer:   Beomjoon Goh
# Last Change:  10 Mar 2020 10:30:12 +0900

export PATH=$HOME/.vim/bin:$PATH
for comp in "$HOME/.vim/bin/completion.d/"*; do
  source "${comp}"
done
unset comp
