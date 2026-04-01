#!/usr/bin/env bash

set -euo pipefail

STATE_ROOT="${XDG_STATE_HOME:-$HOME/.local/state}/pomodoro"
SESSION_FILE="$STATE_ROOT/session"
STATS_FILE="$STATE_ROOT/stats"
SCRIPT_PATH="$(readlink -f "$0" 2>/dev/null || printf '%s' "$0")"
WAYBAR_SIGNAL="RTMIN+8"

mkdir -p "$STATE_ROOT"

load_stats() {
  completed=0
  canceled=0
  completed_minutes=0

  if [[ -f "$STATS_FILE" ]]; then
    # shellcheck disable=SC1090
    source "$STATS_FILE"
  fi
}

save_stats() {
  cat >"$STATS_FILE" <<EOF
completed=$completed
canceled=$canceled
completed_minutes=$completed_minutes
EOF
}

load_session() {
  session_id=""
  pid=""
  end_ts=""
  duration_minutes=""

  if [[ -f "$SESSION_FILE" ]]; then
    # shellcheck disable=SC1090
    source "$SESSION_FILE"
  fi
}

save_session() {
  cat >"$SESSION_FILE" <<EOF
session_id=$session_id
pid=$pid
end_ts=$end_ts
duration_minutes=$duration_minutes
EOF
}

clear_session() {
  rm -f "$SESSION_FILE"
}

refresh_waybar() {
  pkill --signal "$WAYBAR_SIGNAL" -x waybar >/dev/null 2>&1 || true
}

is_session_active() {
  load_session

  if [[ -z "$session_id" || -z "$pid" || -z "$end_ts" || -z "$duration_minutes" ]]; then
    return 1
  fi

  if ! kill -0 "$pid" >/dev/null 2>&1; then
    clear_session
    return 1
  fi

  if (( end_ts <= $(date +%s) )); then
    return 0
  fi

  return 0
}

format_remaining() {
  local remaining total_minutes seconds

  remaining=$(( end_ts - $(date +%s) ))
  if (( remaining < 0 )); then
    remaining=0
  fi

  total_minutes=$(( remaining / 60 ))
  seconds=$(( remaining % 60 ))

  if (( total_minutes > 0 )); then
    printf '%sm %02ss left' "$total_minutes" "$seconds"
    return
  fi

  printf '%ss left' "$seconds"
}

format_completed_time() {
  local hours minutes

  hours=$(( completed_minutes / 60 ))
  minutes=$(( completed_minutes % 60 ))
  printf '%sh %sm' "$hours" "$minutes"
}

notify() {
  local title message

  title=$1
  message=$2
  notify-send "$title" "$message"
}

cancel_active_session() {
  local should_count

  should_count=${1:-1}

  if ! is_session_active; then
    refresh_waybar
    return 1
  fi

  if kill -0 "$pid" >/dev/null 2>&1; then
    kill "$pid" >/dev/null 2>&1 || true
    wait "$pid" 2>/dev/null || true
  fi

  clear_session

  if [[ "$should_count" == "1" ]]; then
    load_stats
    canceled=$(( canceled + 1 ))
    save_stats
  fi

  refresh_waybar
  return 0
}

start_timer() {
  local minutes session_seconds worker_pid

  minutes=$1
  session_seconds=$(( minutes * 60 ))

  cancel_active_session 1 >/dev/null 2>&1 || true

  session_id="$(date +%s)-$RANDOM"
  end_ts=$(( $(date +%s) + session_seconds ))
  duration_minutes=$minutes

  nohup bash -lc "sleep $session_seconds; \"$SCRIPT_PATH\" complete $session_id" >/dev/null 2>&1 &
  worker_pid=$!
  pid=$worker_pid
  save_session

  refresh_waybar
}

complete_timer() {
  local finished_session_id

  finished_session_id=$1
  if [[ ! -f "$SESSION_FILE" ]]; then
    return 0
  fi

  load_session
  if [[ "$session_id" != "$finished_session_id" ]]; then
    return 0
  fi

  load_stats
  completed=$(( completed + 1 ))
  completed_minutes=$(( completed_minutes + duration_minutes ))
  save_stats
  clear_session
  refresh_waybar
  notify "Pomodoro complete" "Your ${duration_minutes}-minute session is complete."
}

show_stats() {
  load_stats
  notify "Pomodoro stats" "Completed sessions: $completed
Failed sessions: $canceled
Completed time: $(format_completed_time)"
}

show_status() {
  if is_session_active; then
    notify "Pomodoro status" "$(format_remaining)"
    return 0
  fi

  notify "Pomodoro status" "Not in session"
}

waybar_output() {
  if is_session_active; then
    printf '{"text":"󰔛","class":"active"}\n'
    return 0
  fi

  printf '{"text":"󰔛","class":"idle"}\n'
}

usage() {
  cat <<'EOF'
Usage:
  pomodoro.sh start <30|45|60>
  pomodoro.sh cancel
  pomodoro.sh stats
  pomodoro.sh status
  pomodoro.sh waybar
EOF
}

command=${1:-}

case "$command" in
start)
  minutes=${2:-}
  case "$minutes" in
  30 | 45 | 60)
    start_timer "$minutes"
    ;;
  *)
    usage
    exit 1
    ;;
  esac
  ;;
cancel)
  cancel_active_session 1 >/dev/null 2>&1 || true
  ;;
complete)
  finished_session_id=${2:-}
  if [[ -z "$finished_session_id" ]]; then
    usage
    exit 1
  fi
  complete_timer "$finished_session_id"
  ;;
stats)
  show_stats
  ;;
status)
  show_status
  ;;
waybar)
  waybar_output
  ;;
*)
  usage
  exit 1
  ;;
esac
