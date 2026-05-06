#!/usr/bin/env bash
set -euo pipefail

# GitHub SSH setup helper for macOS.
# - Generates an Ed25519 key (if missing)
# - Ensures ~/.ssh permissions
# - Adds/updates GitHub host entry in ~/.ssh/config
# - Adds key to ssh-agent + Keychain
# - Prints public key for manual GitHub registration

KEY_NAME="${1:-id_ed25519_github}"
KEY_PATH="$HOME/.ssh/$KEY_NAME"
PUB_KEY_PATH="$KEY_PATH.pub"
SSH_CONFIG_PATH="$HOME/.ssh/config"
SSH_DIR="$HOME/.ssh"

EMAIL_FROM_GIT="$(git config --global user.email || true)"
if [[ -n "$EMAIL_FROM_GIT" ]]; then
  KEY_COMMENT="$EMAIL_FROM_GIT"
else
  KEY_COMMENT="$(whoami)@$(scutil --get LocalHostName 2>/dev/null || hostname)"
fi

log() {
  printf "[github-ssh-setup] %s\n" "$1"
}

ensure_ssh_dir() {
  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"
}

generate_key_if_needed() {
  if [[ -f "$KEY_PATH" ]]; then
    log "SSH key already exists: $KEY_PATH"
  else
    log "Generating new Ed25519 key: $KEY_PATH"
    ssh-keygen -t ed25519 -C "$KEY_COMMENT" -f "$KEY_PATH" -N ""
  fi

  chmod 600 "$KEY_PATH"
  chmod 644 "$PUB_KEY_PATH"
}

update_ssh_config() {
  touch "$SSH_CONFIG_PATH"
  chmod 600 "$SSH_CONFIG_PATH"

  local marker_begin="# >>> github.com managed by github_setup.sh >>>"
  local marker_end="# <<< github.com managed by github_setup.sh <<<"

  if grep -qF "$marker_begin" "$SSH_CONFIG_PATH"; then
    log "Existing managed GitHub block found. Replacing it."
    awk -v b="$marker_begin" -v e="$marker_end" '
      $0==b {skip=1; next}
      $0==e {skip=0; next}
      !skip {print}
    ' "$SSH_CONFIG_PATH" > "$SSH_CONFIG_PATH.tmp"
    mv "$SSH_CONFIG_PATH.tmp" "$SSH_CONFIG_PATH"
  fi

  {
    echo ""
    echo "$marker_begin"
    echo "Host github.com"
    echo "  HostName github.com"
    echo "  User git"
    echo "  IdentityFile $KEY_PATH"
    echo "  AddKeysToAgent yes"
    echo "  UseKeychain yes"
    echo "  IdentitiesOnly yes"
    echo "$marker_end"
  } >> "$SSH_CONFIG_PATH"

  log "Updated SSH config: $SSH_CONFIG_PATH"
}

load_key_to_agent() {
  # Start agent if needed
  if [[ -z "${SSH_AUTH_SOCK:-}" ]]; then
    eval "$(ssh-agent -s)" >/dev/null
  fi

  # macOS Keychain integration
  if ssh-add --apple-use-keychain "$KEY_PATH" >/dev/null 2>&1; then
    log "Key added to ssh-agent and Keychain."
  else
    ssh-add "$KEY_PATH" >/dev/null
    log "Key added to ssh-agent."
  fi
}

print_next_steps() {
  echo ""
  echo "===== Public key (copy this) ====="
  cat "$PUB_KEY_PATH"
  echo "===== End public key ====="
  echo ""
  echo "Next steps (manual on GitHub):"
  echo "1. GitHub > Settings > SSH and GPG keys > New SSH key"
  echo "2. Paste the key above and save"
  echo "3. Verify: ssh -T git@github.com"
  echo ""
}

main() {
  ensure_ssh_dir
  generate_key_if_needed
  update_ssh_config
  load_key_to_agent
  print_next_steps

  log "Done."
}

main "$@"
