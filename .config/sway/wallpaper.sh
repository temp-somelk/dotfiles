wallpath=/usr/share/backgrounds/archlinux/
walltime=$(date +%H)

if [[ $walltime -ge 19 ]] || [[ $walltime -eq 0 ]]; then
    swaymsg output "*" bg $wallpath/geowaves.png fill
elif [[ $walltime -ge 1 ]] && [[ $walltime -lt 7 ]]; then
    swaymsg output "*" bg $wallpath/geolanes.png fill
elif [[ $walltime -ge 7 ]] && [[ $walltime -lt 13 ]]; then
    swaymsg output "*" bg $wallpath/wirefeather.png fill
elif [[ $walltime -ge 13 ]] && [[ $walltime -lt 19 ]]; then
    swaymsg output "*" bg $wallpath/wireparts.png fill
fi
