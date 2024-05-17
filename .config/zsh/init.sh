# M1 Mac, add homebrew to path
if [[ $(uname) == "Darwin" ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export EDITOR=nvim
export DOTNET_CLI_TELEMETRY_OPTOUT=1

if command -v gh &> /dev/null; then
	gh_token=$(gh auth token)
	export GITHUB_API_TOKEN="$gh_token"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="jonathan"

export plugins=(
	aws
	git
	github
	docker
	dotnet
	kubectl
	helm
	laravel
	you-should-use
)

## conditionally load oh-my-zsh
if [ -d "$ZSH" ]; then
	source "$ZSH/oh-my-zsh.sh"
fi

export NVM_DIR="$HOME/.nvm"

if [ -d "$NVM_DIR" ]; then
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
fi

fpath=($fpath ~/.zsh/completion)
[[ ${commands[kubectl]} ]] && source <(kubectl completion zsh)
