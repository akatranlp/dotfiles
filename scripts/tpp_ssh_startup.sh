#!/bin/env bash
if [[ "$SSH_CLIENT" == *"127.0.0.1"* ]] && [ -n "$SSH_TTY" ]; then
  echo "Welcome to the server $(hostnamectl --static)"
  if [ -z "$NAME" ]; then echo "You are not allowed to be here"; exit; fi

  echo "Hello $NAME"
  sleep 1

  if [ -z "$TMUX" ]; then
    SESSION_NAME=$(cat /tmp/tpp_session_name 2>/dev/null)
    SESSION_NAME="${SESSION_NAME:-$USER}"
    tmux attach -t "$NAME" || tmux new -t "$SESSION_NAME" -s "$NAME"
    exit
  fi
fi

