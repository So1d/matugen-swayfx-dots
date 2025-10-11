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

# Copia a imagem pro lugar certo ANTES de perguntar o scheme
cp "$SELECTION" "$WALL_COPY"

# --- LÓGICA NOVA COMEÇA AQUI ---

# Aqui a lista de schemes que o Matugen entende.
# Botei tudo numa string com quebra de linha pro 'echo' mandar pro Fuzzel.
SCHEMES="scheme-content\nscheme-expressive\nscheme-fidelity\nscheme-fruit-salad\nscheme-monochrome\nscheme-neutral\nscheme-rainbow\nscheme-tonal-spot"

# Agora, abro um segundo Fuzzel pra escolher o scheme. É opcional, se apertar Esc ele passa batido.
SELECTED_SCHEME=$(echo -e "$SCHEMES" | fuzzel --dmenu --prompt "Scheme:")

# Checo se o maluco escolheu algum scheme. Se sim, rodo o matugen com a flag -t. Se não, rodo normal.
if [ -n "$SELECTED_SCHEME" ]; then
    matugen -t "$SELECTED_SCHEME" image "$WALL_COPY"
else
    matugen image "$WALL_COPY"
fi

# --- LÓGICA NOVA TERMINA AQUI ---


swww img "$SELECTION" \
--transition-type any \
--transition-step 15 \
--transition-fps 60


# Aplica no swaync
killall swaync
swaync --style /home/machado/.config/swaync/style.css --config /home/machado/.config/swaync/config.json


echo "Wallpaper e tema atualizados."
exit 0
