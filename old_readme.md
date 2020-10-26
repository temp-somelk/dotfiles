This was the older readme for Xorg and i3

## Xorg and WM
1. ```~/.xinitrc``` and ```~/.xserverrc``` [configuration](https://wiki.archlinux.org/index.php/Xinit#Configuration) and ```$ chmod +x```

2. Remove the last part of ```~/.xinitrc``` from ```twm...login```

3. [Set wallpaper](https://wiki.archlinux.org/index.php/Feh#Set_the_wallpaper) using ```feh``` and append ```~/.fehbg &``` to ```.xinitrc```

4. Copy ```/etc/xdg/picom.conf.example``` to ```~/.config/picom/picom.conf``` and [configure](https://wiki.archlinux.org/index.php/Picom#Configuration). Append ```picom &``` to ```~/.xinitrc```

## Packages
##### Xorg
    xorg-server xorg-init xorg-xbacklight
#### Window Manager
    feh picom scrot i3-gaps i3lock-color dunst libnotify polybar(aur)

