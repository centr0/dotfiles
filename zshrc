export SRC="$HOME/src"
export DOTFILES_REPO="${DOTFILES_REPO:-$SRC/dotfiles}"

for shell_file in \
  "$DOTFILES_REPO/exports" \
  "$DOTFILES_REPO/paths" \
  "$DOTFILES_REPO/aliases" \
  "$DOTFILES_REPO/functions" \
  "$DOTFILES_REPO/binds"; do
  [[ -f "$shell_file" ]] && source "$shell_file"
done

if command -v uv >/dev/null 2>&1; then
  eval "$(uv generate-shell-completion zsh)"
fi
