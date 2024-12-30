#!/usr/bin/env bash

theme=$1

SCRIPT_NAME=$(basename $0)

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
GHOSTTY_CONFIG_FOLDER="$CONFIG_HOME/ghostty"

found=false
while read line; do
	if [[ "$theme" == "$line" ]]; then
		found=true
	fi
done <<< $(ghostty +list-themes --plain | sed 's/ (.*)//g')

if ! $found; then
	echo "$SCRIPT_NAME: $theme theme is not available"
	exit 1
fi

if [ ! -f "$GHOSTTY_CONFIG_FOLDER/local-config" ]; then
	echo "theme = $theme" > "$GHOSTTY_CONFIG_FOLDER/local-config"
else
	sed -i "s/^theme = .*$/theme = $theme/" "$GHOSTTY_CONFIG_FOLDER/local-config"
fi
