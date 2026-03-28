export SRC="$HOME/src"
export DOTFILES_REPO="${DOTFILES_REPO:-$SRC/dotfiles}"
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(git)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

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
