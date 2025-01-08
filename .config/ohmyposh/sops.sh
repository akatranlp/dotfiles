#!/usr/bin/env bash

SOPS_FILEPATH=".sops.yaml"
MAX_DEPTH=10
pwd=$PWD

if [ -f "$SOPS_FILEPATH" ]; then
  echo "0"
  exit 0
fi

for ((i = $MAX_DEPTH; i > 0; i--)); do
  SOPS_FILEPATH="../$SOPS_FILEPATH"
  if [ -f "$SOPS_FILEPATH" ]; then
    echo "0"
    exit 0
  fi
  current=$(realpath "$SOPS_FILEPATH")
  if [[ "$current" = "/.sops.yaml" ]]; then
    echo "1"
    exit 0
  fi
done

echo "1"

