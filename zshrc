export SRC="$HOME/src"
export DOTFILES_REPO="${DOTFILES_REPO:-$SRC/dotfiles}"

for shell_file in \
  "$HOME/.config/exports" \
  "$HOME/.config/paths" \
  "$HOME/.config/aliases" \
  "$HOME/.config/functions" \
  "$HOME/.config/binds"; do
  [[ -f "$shell_file" ]] && source "$shell_file"
done

if command -v uv >/dev/null 2>&1; then
  eval "$(uv generate-shell-completion zsh)"
fi
