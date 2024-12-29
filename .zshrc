export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
        git
        zsh-autosuggestions
        zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'

# fnm
export PATH="$HOME/.local/share/fnm:$PATH"
eval "`fnm env --use-on-cd --corepack-enabled`"
# fnm end

alias vim=nvim
alias clr=clear
alias k=kubectl
alias kctx=kubectx
alias kns="kubectl config set-context --current --namespace "

alias lg="lazygit"
alias ld="lazydocker"

alias dcu='docker compose up'
alias dcb='docker compose build'
alias dcs='docker compose stop'
alias dcd='docker compose down'
alias dce='docker compose exec'

alias dip='docker image prune'
alias dvp='docker volume prune'

export PATH="$HOME/.turso:$PATH"

export PATH=$PATH:/usr/local/go/bin
export PATH="$(go env GOPATH)/bin:$PATH"


# yarn pnpm
export PATH="$PATH:$(yarn global bin)"
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# yarn pnpm end

eval "$(zoxide init zsh)"

. <(akatran completion zsh)

. <(fzf --zsh)

. /opt/asdf-vm/asdf.sh

# tmux pair programming
alias tpp="$HOME/scripts/tpp_startup.sh"
alias tpp-kill="pkill ngrok && tmux kill-sess -a"

. $HOME/scripts/tpp_ssh_startup.sh
# tmux pair programming end

alias ssh="TERM=xterm-256color ssh"

alias clip="xclip -sel c"

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

# local config
if [ -f ~/.zshrc-local ]; then
	# . ~/.zshrc-local
fi
# local config end

