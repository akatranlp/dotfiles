#!/bin/env bash

NGROK_CONFIG=$1

if [ -z "$XDG_CONFIG_HOME" ]; then
  XDG_CONFIG_HOME="$HOME/.config"
fi
NGROK_BASE_CONFIG="$XDG_CONFIG_HOME/ngrok/ngrok.yml"

echo "Using config(s): $NGROK_BASE_CONFIG $NGROK_CONFIG"

ngrokApps=$(yq -r '.tunnels | to_entries | map([.key, .value.proto] | join("=")) | .[]' $NGROK_BASE_CONFIG $NGROK_CONFIG)

APPS_REGEX=()
APPS=()

for app in $ngrokApps; do
    name=$(echo $app | cut -d "=" -f 1)
    proto=$(echo $app | cut -d "=" -f 2)

    APPS+=("$name=$proto")

    if [[ "$proto" == "tcp" ]]; then
      regex="msg=\"started tunnel\" .* name=$name .* url=tcp://([0-9]+).tcp.eu.ngrok.io:([0-9]+)"
      APPS_REGEX+=("$regex")
    elif [[ "$proto" == "http" ]]; then
      regex="msg=\"started tunnel\" .* name=$name .* url=https://(.*).ngrok-free.app"
      APPS_REGEX+=("$regex")
    else
      echo "Proto: $proto not valid!"
      exit 1
    fi
done

cmd="ngrok --config $NGROK_BASE_CONFIG"
if [ -n "$NGROK_CONFIG" ]; then
  cmd="$cmd --config $NGROK_CONFIG"
fi
cmd="$cmd start --all --log=stdout"

exec 3< <(eval $cmd)

ENDPOINTS=("" "" "")

INITIAL_REGEX="msg=\"started tunnel\""

function read_tunnel_log() {
  while IFS= read -r line; do
    if [[ ! $line =~ $INITIAL_REGEX ]]; then
      continue
    fi
    for ((i = 0 ; i < ${#APPS[@]} ; i++ )); do
      name=$(echo ${APPS[$i]} | cut -d "=" -f 1)
      proto=$(echo ${APPS[$i]} | cut -d "=" -f 2)
      regex="${APPS_REGEX[$i]}"

      if [[ $line =~ $regex ]]; then
        subdomain=${BASH_REMATCH[1]}
	if [[ "$proto" == "tcp" ]]; then
          port=${BASH_REMATCH[2]}
          domain="ssh://$USER@$subdomain.tcp.eu.ngrok.io:$port"
        elif [[ "$proto" == "http" ]]; then
          domain="https://$subdomain.ngrok-free.app"
        fi
        ENDPOINTS[$i]="$domain"
	return 
      fi
    done
  done <&3
  return
}

while (true); do
  read_tunnel_log

  break="true"
  for ((i = 0 ; i < ${#APPS[@]} ; i++ )); do
    endpoint="${ENDPOINTS[$i]}"
    if [[ "$endpoint" == "" ]] ; then
      break="false"
    fi
  done

  if [[ "$break" == "true" ]]; then
    break
  else
    sleep 0.1
  fi
done

for ((i = 0 ; i < ${#APPS[@]} ; i++ )); do
  ep="${ENDPOINTS[$i]}"
  if [[ "$i" == "0" ]]; then
    clip=$(echo "$ep")
  else
    clip=$(echo -e "$clip\n$ep")
  fi
done

echo "$clip" | xclip -sel c

tmux attach -t "$USER" || tmux new -s "$USER"

