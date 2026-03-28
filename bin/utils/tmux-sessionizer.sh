#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
  selected=$1
else
  selected=$(find ~/src/ ~/.config/ -mindepth 1 -maxdepth 1 -type d |
    while IFS= read -r dir; do
      case "$dir" in
      "$HOME/src/"*)
        label="src/$(basename "$dir")"
        ;;
      "$HOME/.config/"*)
        label="config/$(basename "$dir")"
        ;;
      *)
        label=$(basename "$dir")
        ;;
      esac

      printf '%s\t%s\n' "$label" "$dir"
    done |
    fzf --delimiter=$'\t' --with-nth=1 |
    cut -f2)
fi

if [[ -z $selected ]]; then
  exit 0
fi

case "$selected" in
"$HOME/src/"*)
  selected_name="src_$(basename "$selected")"
  ;;
"$HOME/.config/"*)
  selected_name="config_$(basename "$selected")"
  ;;
*)
  selected_name=$(basename "$selected")
  ;;
esac

selected_name=$(printf '%s' "$selected_name" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -s $selected_name -n "dev" -c $selected \; \
    new-window -t $selected_name -n "term" -c $selected \; \
    new-window -t $selected_name -n "agent" -c $selected \; \
    send-keys -t "$selected_name:agent" "opencode --port" C-m \; \
    select-window -t "$selected_name":dev
  exit 0
fi

if ! tmux has-session -t=$selected_name 2>/dev/null; then
  tmux new-session -ds $selected_name -n "dev" -c $selected \; \
    new-window -t $selected_name -n "term" -c $selected \; \
    new-window -t $selected_name -n "agent" -c $selected \; \
    send-keys -t "$selected_name:agent" "opencode --port" C-m \; \
    select-window -t "$selected_name":dev

fi
if [[ -z $TMUX ]]; then
  # Not in tmux, so attach to the session
  tmux attach-session -t $selected_name
else
  # In tmux, so switch to the session
  tmux switch-client -t $selected_name
fi
