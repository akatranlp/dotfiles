# local config
if [ -f ~/.zshrc-local ]; then
	. ~/.zshrc-local
fi
# local config end

# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="robbyrussell"
# plugins=(
#         git
#         zsh-autosuggestions
#         zsh-syntax-highlighting
# )
#
# source $ZSH/oh-my-zsh.sh
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"

export EDITOR='nvim'

# alias
alias la="ls -lAh"
alias vim=nvim
alias clr=clear
alias k=kubectl
alias kctx=kubectx
alias kns="kubectl config set-context --current --namespace "
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

dcontext () {
        local host=$1
        if [ -z "$1" ]; then
                echo "specify one of the following contexts:"
                docker context ls --format '{{.Name}}'
                return 1
        fi

        if ! docker context inspect $host &>/dev/null; then
                echo "context does not exist! Please provide one of the following contexts:"
                docker context ls --format '{{.Name}}'
                return 1
        fi
        echo "Using docker context $host temporarily"
        export DOCKER_HOST=$(docker context inspect $host | yq '.[0].Endpoints.docker.Host')
}
# utils end

export PATH="$HOME/.turso:$PATH"

export PATH="/usr/local/go/bin:$PATH"
export PATH="$(go env GOPATH)/bin:$PATH"

# yarn pnpm
export PATH="$(yarn global bin):$PATH"
export PATH="$HOME/.local/share/pnpm:$PATH"
# yarn pnpm end

# fnm
export PATH="$HOME/.local/share/fnm:$PATH"
eval "`fnm env --use-on-cd --corepack-enabled`"
# fnm end

# bat
export BAT_THEME="Catppuccin Mocha"
eval "$(batman --export-env)"
eval "$(batpipe)"
# bat end

eval "$(zoxide init zsh)"

. <(akatran completion zsh)

. <(fzf --zsh)

. /opt/asdf-vm/asdf.sh

# tmux pair programming
alias tpp="$HOME/scripts/tpp_startup.sh"
alias tpp-kill="pkill ngrok && tmux kill-sess -a"

. $HOME/scripts/tpp_ssh_startup.sh
# tmux pair programming end

