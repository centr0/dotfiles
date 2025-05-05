#!/bin/bash

# create venv if does not exists
if [ -d ".venv" ]; then
  echo "Found .venv. Activating..."
  source .venv/bin/activate
else
  read -p ".venv does not exist. Would you like to create a venv for this directory? (y/n) " response
  if [ "$response" == "y" ]; then
    echo "Creating .venv directory @ $PWD"
    python3 -m venv .venv
  fi
fi
