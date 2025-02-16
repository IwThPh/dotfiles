# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

if [[ ! "$PATH" == */home/iwanp/src/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/iwanp/src/fzf/bin"
fi

### End of Zinit's installer chunk
zi ice depth"1"
zi light romkatv/powerlevel10k

zi light-mode for \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions \
    zsh-users/zsh-syntax-highlighting \
    Aloxaf/fzf-tab

zi snippet OMZL::git.zsh
zi snippet OMZP::aws
zi snippet OMZP::git

zi ice as"completion"
zi snippet OMZP::docker/completions/_docker

zi snippet OMZP::dotnet

# zi ice as"completion"
# zi snippet OMZP::kubectl/kubectl.plugin.zsh

# zi snippet OMZP::kubectx
zi snippet OMZP::command-not-found

if [[ -d "$HOME/.dotnet/tools" ]]; then
  export PATH="${PATH:+${PATH}:}$HOME/.dotnet/tools"
fi

# M1 Mac, add homebrew to path
if [[ $(uname) == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if command -v fzf &> /dev/null; then
  eval "$(fzf --zsh)"
fi

if command -v colima &> /dev/null; then
    eval "$(colima completion zsh > "${fpath[1]}/_colima")"
fi

# Load completions
autoload -Uz compinit
compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Key bindings
bindkey '^y' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# see https://github.com/Aloxaf/fzf-tab/wiki/Configuration#default-color
zstyle ':fzf-tab:*' default-color $'\033[30m'
zstyle ':fzf-tab:*' fzf-flags --color=light

if command -v dircolors &> /dev/null; then
  zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"'
  zinit light trapd00r/LS_COLORS
else
  export CLICOLOR=1
  zstyle ':completion:*:default' list-colors ''
fi

export EDITOR=nvim
export DOTNET_CLI_TELEMETRY_OPTOUT=1

if command -v gh &> /dev/null; then
  gh_token=$(gh auth token)
  export GITHUB_API_TOKEN="$gh_token"
fi

source ~/.config/zsh/functions.sh
source ~/.config/zsh/aliases.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias ls='ls --color=auto'
alias ssh='TERM=xterm-256color ssh'
