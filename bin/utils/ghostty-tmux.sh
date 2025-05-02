#!/bin/bash
SESSION_NAME="dev"

# Check if the session already exists
/usr/bin/tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? -eq 0 ]; then
  # If the session exists, reattach to it
  /usr/bin/tmux attach-session -t $SESSION_NAME
else
  # If the session doesn't exist, start a new one
  /usr/bin/tmux new-session -s $SESSION_NAME -d
  /usr/bin/tmux attach-session -t $SESSION_NAME
fi
