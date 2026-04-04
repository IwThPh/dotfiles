# Bitwarden CLI integration — session management, profiles, secret fetching
command -v bw &> /dev/null || return

# Completions (cached)
bw_completion="${XDG_CACHE_HOME:-$HOME/.cache}/bw_completion.zsh"
if [[ ! -f "$bw_completion" || "$bw_completion" -ot "$(which bw)" ]]; then
  bw completion --shell zsh > "$bw_completion" 2>/dev/null
fi
source "$bw_completion"

typeset -A _bw_sessions
BW_ACTIVE_PROFILE=""

# --- Session management ---

bwl() {
  local session
  session="$(bw login --raw "$@")" || return $?
  export BW_SESSION="$session"
  echo "Bitwarden logged in."
}

bwu() {
  local session
  session="$(bw unlock --raw "$@")" || return $?
  export BW_SESSION="$session"
  echo "Bitwarden unlocked."
}

bwlock() {
  bw lock
  unset BW_SESSION
}

# --- Multi-account profiles ---
# Config file: ~/.config/bw/profiles
# Format: name|server_url|email (one per line, # comments allowed)

_bw_load_profiles() {
  typeset -gA BW_PROFILES
  BW_PROFILES=()
  local cfg="${XDG_CONFIG_HOME:-$HOME/.config}/bw/profiles"
  [[ -f "$cfg" ]] || return 1
  while IFS= read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    local name="${line%%|*}"
    local rest="${line#*|}"
    BW_PROFILES[$name]="$rest"
  done < "$cfg"
}

bwp() {
  _bw_load_profiles
  local profile="$1"

  if [[ -z "$profile" ]]; then
    if (( ${#BW_PROFILES} == 0 )); then
      echo "No profiles found. Create ~/.config/bw/profiles" >&2
      echo "Format: name|server_url|email" >&2
      return 1
    fi
    echo "Profiles:"
    for name in "${(@k)BW_PROFILES}"; do
      local marker=""
      [[ "$name" == "$BW_ACTIVE_PROFILE" ]] && marker=" *"
      local entry="${BW_PROFILES[$name]}"
      local email="${entry#*|}"
      echo "  $name — $email$marker"
    done
    return
  fi

  local entry="${BW_PROFILES[$profile]}"
  if [[ -z "$entry" ]]; then
    echo "Unknown profile: $profile" >&2
    echo "Available: ${(k)BW_PROFILES}" >&2
    return 1
  fi

  # Save current session before switching
  if [[ -n "$BW_ACTIVE_PROFILE" && -n "$BW_SESSION" ]]; then
    _bw_sessions[$BW_ACTIVE_PROFILE]="$BW_SESSION"
  fi

  local server="${entry%%|*}"
  local email="${entry#*|}"

  bw config server "$server" > /dev/null
  BW_ACTIVE_PROFILE="$profile"

  # Restore cached session if available
  if [[ -n "${_bw_sessions[$profile]}" ]]; then
    export BW_SESSION="${_bw_sessions[$profile]}"
    if bw unlock --check &> /dev/null; then
      echo "Switched to $profile (session restored)."
      return
    fi
    unset '_bw_sessions[$profile]'
  fi

  unset BW_SESSION
  echo "Switched to $profile ($email @ $server)."
  echo "Run 'bwl' to log in or 'bwu' to unlock."
}

# --- Inline secret fetching ---

bws() {
  if [[ -z "$BW_SESSION" ]]; then
    echo "Vault is locked. Run 'bwu' first." >&2
    return 1
  fi

  local item="$1"
  local field="${2:-password}"

  if [[ -z "$item" ]]; then
    echo "Usage: bws <item-name> [field]" >&2
    echo "Fields: password (default), username, notes, totp, uri" >&2
    return 1
  fi

  case "$field" in
    password) bw get password "$item" ;;
    username) bw get username "$item" ;;
    notes)    bw get notes "$item" ;;
    totp)     bw get totp "$item" ;;
    uri)      bw get uri "$item" ;;
    *)        bw get item "$item" | jq -r ".fields[] | select(.name==\"$field\") | .value" ;;
  esac
}
