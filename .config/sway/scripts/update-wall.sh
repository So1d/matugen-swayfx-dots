#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
WALL_COPY="$HOME/.config/matugen/wallpapers/current_wallpaper"
THUMBNAIL_DIR="$HOME/.cache/sway_wall_thumbnails"

mkdir -p "$(dirname "$WALL_COPY")"
mkdir -p "$THUMBNAIL_DIR"


generate_fuzzel_list() {
    find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' \) | while read -r wall; do

        thumb_name=$(basename "$wall")
        thumbnail_path="$THUMBNAIL_DIR/$thumb_name.png"

        if [ ! -f "$thumbnail_path" ]; then
            echo "Gerando miniatura para $thumb_name..." >&2

            magick "$wall" -thumbnail 256x256^ -gravity center -extent 256x256 "$thumbnail_path"
        fi

        printf '%s\0icon\x1f%s\n' "$(basename "$wall")" "$thumbnail_path"
    done
}


SELECTED_BASENAME=$(generate_fuzzel_list | fuzzel --dmenu )

if [ -z "$SELECTED_BASENAME" ]; then
    echo "Nenhum wallpaper selecionado."
    exit 1
fi


SELECTION="$WALLPAPER_DIR/$SELECTED_BASENAME"

# Aplica de fato
cp "$SELECTION" "$WALL_COPY"
matugen image "$WALL_COPY"
swww img "$SELECTION" \
--transition-type center \
--transition-step 15 \
--transition-fps 60


# Aplica no swaync
killall swaync
swaync --style /home/machado/.config/swaync/style.css --config /home/machado/.config/swaync/config.json


echo "Wallpaper atualizado: $SELECTION"
exit 0
