#!/bin/bash

# Este script controla o volume e o brilho e exibe um OSD via swaync.

# Função para enviar a notificação com a barra de progresso
send_notification() {
    local type=$1
    local value=$2
    local icon=$3
    local text_body=$4

    notify-send -u critical \
                -t 1500 \
                -h "int:value:$value" \
                -h "string:x-canonical-private-synchronous:osd-$type" \
                -h "boolean:transient:true" \
                -i "$icon" \
                "$type" "$text_body"
}


case $1 in
    volume)
        case $2 in
            up) pamixer -i 5 ;;
            down) pamixer -d 5 ;;
            mute) pamixer -t ;;
        esac

        volume=$(pamixer --get-volume)
        is_muted=$(pamixer --get-mute)

        if [ "$is_muted" = "true" ]; then
            icon="audio-volume-muted"

            send_notification "Volume" "$volume" "$icon" "Mutado"
        else
            if [ "$volume" -le 33 ]; then
                icon="audio-volume-low"
            elif [ "$volume" -le 66 ]; then
                icon="audio-volume-medium"
            else
                icon="audio-volume-high"
            fi
            send_notification "Volume" "$volume" "$icon" "${volume}%"
        fi
        ;;

    brightness)
        case $2 in
            up) brightnessctl set +5% ;;
            down) brightnessctl set 5%- ;;
        esac

        brightness=$(brightnessctl get)
        max_brightness=$(brightnessctl max)
        percent=$((brightness * 100 / max_brightness))

        if [ "$percent" -le 33 ]; then
            icon="display-brightness-low"
        elif [ "$percent" -le 66 ]; then
            icon="display-brightness-medium"
        else
            icon="display-brightness-high"
        fi

        send_notification "Brilho" "$percent" "$icon" "${percent}%"
        ;;
esac
