#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
THUMBNAIL_DIR="$HOME/.cache/sway_wall_thumbnails"


rm -rf "$THUMBNAIL_DIR"
mkdir -p "$THUMBNAIL_DIR"

# Encontra todos os wallpapers e itera sobre eles
find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' \) | while read -r wall; do

    thumb_name=$(basename "$wall")
    thumbnail_path="$THUMBNAIL_DIR/$thumb_name.png"

    # Gera a miniatura se ela ainda não existir
    if [ ! -f "$thumbnail_path" ]; then

        magick "$wall" -thumbnail 256x256^ -gravity center -extent 256x256 "$thumbnail_path"
    fi
done
