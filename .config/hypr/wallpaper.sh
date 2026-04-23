#!/bin/bash
WALLPAPER_DIR="$HOME/wallpapers/walls"
THUMB_DIR="$HOME/.cache/wallpaper-thumbs"

menu() {
    find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) |
    while read -r wall; do
        echo "img:$THUMB_DIR/$(basename "$wall").jpg"
    done
}

main() {

    choice=$(menu | wofi -c ~/.config/wofi/wallpaper -s ~/.config/wofi/style-wallpaper.css \
        --show dmenu --prompt "Select Wallpaper:" -n)
    [[ -z "$choice" ]] && exit 0

    # Map thumb path back to the original wallpaper
    thumb_path=${choice#img:}
    thumb_name=$(basename "$thumb_path" .jpg)
    selected_wallpaper="$WALLPAPER_DIR/$thumb_name"

    awww img "$selected_wallpaper" --transition-type any --transition-fps 60 --transition-duration .5
    wal -i "$selected_wallpaper" -n --cols16

    # Kitty + swaync are cheap, fire them immediately
    cp ~/.cache/wal/colors-kitty.conf ~/.config/kitty/current-theme.conf
    swaync-client --reload-css &

    # Backgroundable chunks — all of these can run in parallel
    {
        cp ~/.cache/wal/colors-swayosd.css ~/.config/swayosd/style.css
        pkill swayosd-server
        swayosd-server -s ~/.config/swayosd/style.css &
    } &

    pywalfox update &

    {
        color1=$(awk 'match($0, /color2=\47(.*)\47/,a) { print a[1] }' ~/.cache/wal/colors.sh)
        color2=$(awk 'match($0, /color3=\47(.*)\47/,a) { print a[1] }' ~/.cache/wal/colors.sh)
        cava_config="$HOME/.config/cava/config"
        sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$color1'/" "$cava_config"
        sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$color2'/" "$cava_config"
        pkill -USR2 cava 2>/dev/null
    } &

    source ~/.cache/wal/colors.sh && cp "$wallpaper" ~/wallpapers/pywallpaper.jpg &
}
main
