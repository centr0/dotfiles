#!/usr/bin/env bash

# Function to show usage
usage() {
  echo "Usage: $0 [-r] [temperature]"
  echo "  -r            Reset temperature"
  echo "  temperature   Integer between 1000 and 6000 to set temperature"
  exit 1
}

# Parse options
RESET=false
while getopts ":r" opt; do
  case ${opt} in
  r)
    RESET=true
    ;;
  \?)
    usage
    ;;
  esac
done
shift $((OPTIND - 1))

# Handle reset flag
if $RESET; then
  hyprctl hyprsunset identity >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "Temperature reset successfully."
  else
    echo "Failed to reset temperature."
    exit 1
  fi
  exit 0
fi

# Expect temperature argument if not resetting
if [ -z "$1" ]; then
  usage
fi

# Validate input is an integer
if ! [[ "$1" =~ ^[0-9]+$ ]]; then
  echo "Error: Temperature must be an integer."
  exit 1
fi

TEMP="$1"

# Check bounds
if [ "$TEMP" -lt 1000 ] || [ "$TEMP" -gt 6000 ]; then
  echo "Error: Temperature must be between 1000 and 6000."
  exit 1
fi

hyprctl hyprsunset temperature "$TEMP" >/dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "Temperature successfully set to $TEMP."
else
  echo "Failed to set temperature."
  exit 1
fi
