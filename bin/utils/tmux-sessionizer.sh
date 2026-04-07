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

create_session() {
  local dev_pane agent_pane dev_left agent_left

  tmux new-session -ds "$selected_name" -n "dev" -c "$selected"
  dev_pane=$(tmux display-message -p -t "$selected_name:dev" '#{pane_id}')
  agent_pane=$(tmux split-window -h -P -F '#{pane_id}' -t "$selected_name:dev" -c "$selected")

  dev_left=$(tmux display-message -p -t "$dev_pane" '#{pane_left}')
  agent_left=$(tmux display-message -p -t "$agent_pane" '#{pane_left}')

  # Keep the original shell pane on the left and the new agent pane on the right.
  if (( dev_left > agent_left )); then
    tmux swap-pane -s "$dev_pane" -t "$agent_pane"
  fi

  tmux send-keys -t "$agent_pane" "opencode --port" C-m
  tmux select-pane -t "$dev_pane"
  tmux new-window -t "$selected_name" -n "term" -c "$selected"
  tmux select-window -t "$selected_name:dev"
}

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  create_session
  tmux attach-session -t "$selected_name"
  exit 0
fi

if ! tmux has-session -t=$selected_name 2>/dev/null; then
  create_session
fi
if [[ -z $TMUX ]]; then
  # Not in tmux, so attach to the session
  tmux attach-session -t $selected_name
else
  # In tmux, so switch to the session
  tmux switch-client -t $selected_name
fi
