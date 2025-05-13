#!/usr/bin/env bash
set -e
SRC_DIR="$HOME/Documents/obsidian-vault/blog/posts"
DEST_DIR="$HOME/src/projects/blog/blog/content/posts"
BLOG_DIR="$HOME/src/projects/blog/blog"
PUBLIC_DIR="$HOME/src/projects/blog/cparaiso.github.io"
rsync -av --update "$SRC_DIR/" "$DEST_DIR/"
cd "$BLOG_DIR"
hugo build
cd "$PUBLIC_DIR"
http-server .
