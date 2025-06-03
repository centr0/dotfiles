#!/usr/bin/env bash
set -e
SRC_DIR="$HOME/Documents/obsidian-vault/blog/posts"
DEST_DIR="$HOME/src/projects/blog/blog/content/posts"
BLOG_DIR="$HOME/src/projects/blog/blog"
rsync -av --update "$SRC_DIR/" "$DEST_DIR/"
cd "$BLOG_DIR"
hugo build
echo ":: Blog has been built. Test static site."
