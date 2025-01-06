if [ -f .envrc ] || [ -n "$DIRENV_FILE" ]; then
  direnv status --json | yq '.state | with(select(.loadedRC == null); .loadedRC = { .allowed = 1 }) | .loadedRC.allowed'
fi
