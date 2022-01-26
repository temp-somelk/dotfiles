#!/usr/bin/env sh

WORD="$(cat "$HOME/.config/scripts/tools.dictionary.wordlist.txt" | dmenu-wl -p 'dictionary:' -i -h 30 -b -r -fn 'JetBrainsMono' -nb '#00010a' -nf '#e5e9f0' -sf '#e5e9f0' -sb '#3a575c')"
# WORD="$(cat 'wordlist.txt' | wofi --dmenu)"
DEFINITION="$({ dict 2>&3 -f -C -d wn "$WORD" | tail -n +4 | cut -c 7-; } 3>&1)"
notify-send -u normal -t 0 -a "Dictionary" "$WORD" "$DEFINITION"
