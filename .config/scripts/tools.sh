#!/usr/bin/env sh

TOOLS=('matrix codes' 'color picker' 'dictionary' 'emoji picker' 'calculator' 'copy to file' 'password manager')
TOOL="$(( IFS=$'\n'; echo "${TOOLS[*]}" ) | dmenu-wl -p "tools:" -i -h 30 -b -r -fn JetBrainsMono -nb "#00010a" -nf "#e5e9f0" -sf "#e5e9f0" -sb "#3a575c" | tr -d '[:blank:]' | tr '[:upper:]' '[:lower:]')"
exec "$HOME/.config/scripts/tools.$TOOL.sh"

# maybe just use conditional statements

# song identifier?
# tmp wl-paste screenshot
