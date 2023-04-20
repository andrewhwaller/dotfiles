#!/usr/bin/env bash
languages=`echo "rust ruby javascript psql zsh markdown yarn npm" | tr ' ' '\n'`
core_utils=`echo "xargs find mv sed awk" | tr ' ' '\n'`

selected=`printf "What language are you working in?\n$languages\n$core_utils" | fzf`
read -p "Here's what I need: " query

if printf "$languages" | grep -qs $selected; then
  curl cht.sh/$selected/`echo $query | tr ' ' '+'`
else
  curl cht.sh/$selected~$query
fi
