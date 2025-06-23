#!/usr/bin/env bash
set -e
PUBLIC_DIR="$HOME/src/projects/blog/cparaiso.github.io"
cd "$PUBLIC_DIR"
git add .
git commit -m "sync $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main
