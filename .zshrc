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

function clip() {
  if [[ -n "$WAYLAND_DISPLAY" ]]; then
    wl-copy
  else
    xclip -sel c
  fi
}
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
  local pwd=$PWD
  cd ~/tools
  if [ -f patch.compose.yaml ]; then
    docker compose -f compose.yaml -f patch.compose.yaml up -d
  else
    docker compose up -d
  fi
  local ret="$?"
  cd $pwd
  return $ret
}

function dbcon {
  local pwd=$PWD
  cd ~/tools
  docker compose exec -it postgres psql -d postgres -U postgres
  local ret="$?"
  cd $pwd
  return $ret
}

function dctx() {
  if [ -n "$DOCKER_HOST" ]; then
    unset DOCKER_TLS_VERIFY
    unset DOCKER_HOST
    unset DOCKER_CERT_PATH
    unset MINIKUBE_ACTIVE_DOCKERD
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

function nasmount() {
  if ! [ -d "$HOME/mnt/home" ]; then
    mkdir -p $HOME/mnt/home
  fi

  sudo mount -t cifs -o credentials=$HOME/.smbcredentials/homenas,uid=`id -u`,gid=`id -g`,vers=3.1.1,file_mode=0660,dir_mode=0770,iocharset=utf8,nofail //192.168.20.200/home $HOME/mnt/home
}

function nasumount() {
  sudo umount $HOME/mnt/home
}
# utils end

export PATH="$HOME/.turso:$PATH"

export PATH="/usr/local/go/bin:$PATH"
export PATH="$(go env GOPATH)/bin:$PATH"

# fnm
export PATH="$HOME/.local/share/fnm:$PATH"
eval "`fnm env --use-on-cd --corepack-enabled`"
# fnm end

export PATH="$HOME/.cargo/bin:$PATH"

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

# tmux pair programming
alias tpp="$HOME/scripts/tpp_startup.sh"
alias tpp-kill="pkill ngrok && tmux kill-sess -a"

. $HOME/scripts/tpp_ssh_startup.sh
# tmux pair programming end

trashcount=$(trash-list | wc -l)
if [ $trashcount -gt 0 ]; then
  echo "\033[31m$trashcount item(s) in trash\033[0m"
fi

echo -n "CiAg4paI4paI4paI4paI4paI4pWXIOKWiOKWiOKVlyAg4paI4paI4pWXIOKWiOKWiOKWiOKWiOKWiOKVlyDilojilojilojilojilojilojilojilojilZfilojilojilojilojilojilojilZcgIOKWiOKWiOKWiOKWiOKWiOKVlyDilojilojilojilZcgICDilojilojilZcKIOKWiOKWiOKVlOKVkOKVkOKWiOKWiOKVl+KWiOKWiOKVkSDilojilojilZTilZ3ilojilojilZTilZDilZDilojilojilZfilZrilZDilZDilojilojilZTilZDilZDilZ3ilojilojilZTilZDilZDilojilojilZfilojilojilZTilZDilZDilojilojilZfilojilojilojilojilZcgIOKWiOKWiOKVkQog4paI4paI4paI4paI4paI4paI4paI4pWR4paI4paI4paI4paI4paI4pWU4pWdIOKWiOKWiOKWiOKWiOKWiOKWiOKWiOKVkSAgIOKWiOKWiOKVkSAgIOKWiOKWiOKWiOKWiOKWiOKWiOKVlOKVneKWiOKWiOKWiOKWiOKWiOKWiOKWiOKVkeKWiOKWiOKVlOKWiOKWiOKVlyDilojilojilZEKIOKWiOKWiOKVlOKVkOKVkOKWiOKWiOKVkeKWiOKWiOKVlOKVkOKWiOKWiOKVlyDilojilojilZTilZDilZDilojilojilZEgICDilojilojilZEgICDilojilojilZTilZDilojilojilZcg4paI4paI4pWU4pWQ4pWQ4paI4paI4pWR4paI4paI4pWR4pWa4paI4paI4pWX4paI4paI4pWRCiDilojilojilZEgIOKWiOKWiOKVkeKWiOKWiOKVkSAg4paI4paI4pWX4paI4paI4pWRICDilojilojilZEgICDilojilojilZEgICDilojilojilZEgIOKWiOKWiOKVl+KWiOKWiOKVkSAg4paI4paI4pWR4paI4paI4pWRIOKVmuKWiOKWiOKWiOKWiOKVkQog4pWa4pWQ4pWdICDilZrilZDilZ3ilZrilZDilZ0gIOKVmuKVkOKVneKVmuKVkOKVnSAg4pWa4pWQ4pWdICAg4pWa4pWQ4pWdICAg4pWa4pWQ4pWdICDilZrilZDilZ3ilZrilZDilZ0gIOKVmuKVkOKVneKVmuKVkOKVnSAg4pWa4pWQ4pWQ4pWQ4pWdCgo=" | base64 -d

