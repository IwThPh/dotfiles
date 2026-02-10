alias c='claude'
alias art='php artisan'
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'

# alias -g phpstan='docker run -v $PWD:/app --rm ghcr.io/phpstan/phpstan'

z() {
  if [[ -n "$1" ]]; then
    zellij attach --create "$1"
  else
    zellij
  fi
}
