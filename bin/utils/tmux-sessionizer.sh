#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
  selected=$1
else
  selected=$(find ~/src/ -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
  exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -s $selected_name -n "dev" -c $selected \; \
    new-window -t $selected_name -n "term" -c $selected \; \
    new-window -t $selected_name -n "ext" -c $selected \; \
    select-window -t "$selected_name":dev
  exit 0
fi

if ! tmux has-session -t=$selected_name 2>/dev/null; then
  tmux new-session -ds $selected_name -n "dev" -c $selected \; \
    new-window -t $selected_name -n "term" -c $selected \; \
    new-window -t $selected_name -n "ext" -c $selected \; \
    select-window -t "$selected_name":dev

fi
if [[ -z $TMUX ]]; then
  # Not in tmux, so attach to the session
  tmux attach-session -t $selected_name
else
  # In tmux, so switch to the session
  tmux switch-client -t $selected_name
fi
