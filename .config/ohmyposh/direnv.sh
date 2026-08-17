if [ -f .envrc ] || [ -n "$DIRENV_FILE" ]; then
  direnv status --json | jq 'if .state.loadedRC == null then 1 else .state.loadedRC.allowed end'
fi
