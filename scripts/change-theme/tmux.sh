#!/usr/bin/env bash

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
TMUX_CONFIG_FOLDER="$CONFIG_HOME/tmux"

SCRIPT_NAME=$(basename $0)

tmux_re='^.*/tmux-(.*)$'

if [ -L ${TMUX_CONFIG_FOLDER} ] ; then
    rm "$TMUX_CONFIG_FOLDER"
elif [ -e ${TMUX_CONFIG_FOLDER} ] ; then
    echo "You already have a tmux folder in your config please delete it to make this script work"
    exit 1
fi

declare -A thememap
thememap["catppuccin-mocha"]="cat"
themes=()

for tmux in $CONFIG_HOME/*; do
  if [[ "$tmux" =~ $tmux_re ]]; then
    themes+=( "${BASH_REMATCH[1]}" )
  fi
done

theme="${thememap[$1]:-$1}"

containsElement () {
  for theme in "${themes[@]}"; do [[ "$theme" == "$1" ]] && return 0; done
  return 1
}

if ! containsElement "$theme"; then
	echo "$SCRIPT_NAME: $theme theme is not available"
	exit 1
fi

cd "$CONFIG_HOME"
ln -s "tmux-${theme}" "tmux"

