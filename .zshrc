# local config
if [ -f ~/.zshrc-local ]; then
  . ~/.zshrc-local
fi
# local config end

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(
  git
  direnv
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"

export EDITOR='nvim'
export SHELL="/bin/zsh"

# alias
function tmux() {
  local bin
  bin="/usr/bin/tmux"
  if [ ${#@} -gt 0 ]; then
    $bin $@
  else
    $bin attach 2>/dev/null || $bin new -s "$USER"
  fi
}

alias la="ls -lAh"
alias rm="trash"
alias vim=nvim
alias clr=clear

alias k=kubectl
alias kctx=kubectx
alias kn="kubectl config set-context --current --namespace "

alias lg="lazygit"
alias ld="lazydocker"

alias dcu='docker compose up'
alias dcb='docker compose build'
alias dcs='docker compose stop'
alias dcd='docker compose down'
alias dce='docker compose exec'

alias dip='docker image prune'
alias dvp='docker volume prune'

alias ssh="TERM=xterm-256color ssh"

alias clip="xclip -sel c"
alias open="xdg-open"
# alias end

# utils
function b64 {
  echo -n $1 | base64 -w0
}

function b64d {
  echo -n $1 | base64 -d -w0
}

function toolsup {
  pwd=$PWD
  cd ~/tools
  if [ -f patch.compose.yaml ]; then
    docker compose -f compose.yaml -f patch.compose.yaml up -d
  else
    docker compose up -d
  fi
  cd $pwd
  return "$?"
}

function dctx() {
  if [ -n "$DOCKER_HOST" ]; then
    unset DOCKER_HOST
    return 0
  fi
  local host
  host=$(docker context ls --format '{{.Name}}' | fzf --height="40%" --reverse --border)
  if [ "$?" != "0" ]; then
    echo "You need to select a context"
    return 1
  fi

  echo "Using docker context $host temporarily"
  export DOCKER_HOST=$(docker context inspect "$host" --format '{{.Endpoints.docker.Host}}')
}
# utils end

export PATH="$HOME/.turso:$PATH"

export PATH="/usr/local/go/bin:$PATH"
export PATH="$(go env GOPATH)/bin:$PATH"

# fnm
export PATH="$HOME/.local/share/fnm:$PATH"
eval "`fnm env --use-on-cd --corepack-enabled`"
# fnm end

# yarn pnpm
export PATH="$(yarn global bin):$PATH"
export PATH="$HOME/.local/share/pnpm:$PATH"
# yarn pnpm end

# bat
export BAT_THEME="Catppuccin Mocha"
eval "$(batman --export-env)"
eval "$(batpipe)"
# bat end

# eval "$(starship init zsh)"
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/config.toml)"

eval "$(zoxide init zsh)"

. <(akatran completion zsh)

. <(fzf --zsh)

. /opt/asdf-vm/asdf.sh

# tmux pair programming
alias tpp="$HOME/scripts/tpp_startup.sh"
alias tpp-kill="pkill ngrok && tmux kill-sess -a"

. $HOME/scripts/tpp_ssh_startup.sh
# tmux pair programming end

trashcount=$(trash-list | wc -l)
if [ $trashcount -gt 0 ]; then
  echo "\033[31m$trashcount item(s) in trash\033[0m"
fi

