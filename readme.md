Backup to set up an encrypted Arch on a [USB drive](https://wiki.archlinux.org/index.php/Install_Arch_Linux_on_a_removable_medium#Tips) (bootable on both BIOS and UEFI preferably). Quick checklist to set it up fast, in case I forget the password again and have to reinstall arch. Still [to-do](#todos). PS. If someone else is reading this, **please refer to the official ArchWiki.** As you might have noticed most of these are outlinks to the wiki anyways. It's for a reason.

## Base Installation
1. [Setting up gpt table and partitioning disk](https://wiki.archlinux.org/index.php/GPT_fdisk#Create_a_partition_table_and_partitions) with [this layout](#disk-layout)

2. [Setting up LUKS Container, Logical Volumes](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS)

3. [Backing up and restoring LUKS Header](https://wiki.archlinux.org/index.php/Dm-crypt/Device_encryption#Backup_and_restore)

4. [Installing base Arch](https://wiki.archlinux.org/index.php/Installation_guide#Installation) with [these packages](#packages)

5. For initramfs hooks,<sup>[1](https://wiki.archlinux.org/index.php/Install_Arch_Linux_on_a_removable_medium#Installation_tweaks) [2](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#Configuring_mkinitcpio_2)</sup> <br />
```HOOKS=(base udev block keyboard keymap autodetect consolefont modconf encrypt lvm2 filesystems fsck)```<br />
```HOOKS=(base systemd autodetect keyboard sd-vconsole modconf block sd-encrypt sd-lvm2 filesystems fsck)```<br />
*(Don't forget to rebuild initramfs)*

6. To install GRUB for both systems, <sup>[1](https://wiki.archlinux.org/index.php/GRUB#Installation) [2](https://wiki.archlinux.org/index.php/GRUB#Installation_2) [3](https://wiki.archlinux.org/index.php/Install_Arch_Linux_on_a_removable_medium#GRUB)</sup> <br />
```# grub-install --target=i386-pc /dev/sdx --recheck```<br />
```# grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB  --removable --recheck```

7. For GRUB config, add the [cryptdevice parameters](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#Configuring_the_boot_loader_2) under ```GRUB_CMDLINE_LINUX=""``` and [disable submenu](https://wiki.archlinux.org/index.php/GRUB/Tips_and_tricks#Disable_submenu), both in ```etc/default/grub``` and regenerate /boot/grub/grub.cfg

8. Add user ```# useradd -m -G wheel -s /bin/zsh koala``` and add wheel to sudoers ```# EDITOR=nano visudo```

9. ```# passwd``` and ```# passwd koala```

## System
1. ~~To lock tty session after inactivity, make ```lock.sh``` in ```/etc/profile.d/``` and add ```TMOUT=300``` and on next line, add ```trap '[[ -z $DISPLAY ]] && physlock -p $USER' SIGALRM```~~ **This is more headache than necessary, don't do it. Just run ```vlock``` before leaving your pc**

2. keyring

3. password mananger

4. For networking, use [NetworkManager](https://wiki.archlinux.org/index.php/NetworkManager), by enabling NetworkManager.service and [disabling dhcpcd/netctl/other services](https://wiki.archlinux.org/index.php/NetworkManager#Additional_interfaces)

5. openvPN or WireGuard

6. nftables

7. power management

8. ntp

9. Update mirrorlists with ```reflector```, and enable ```reflector.service``` & ```reflector.timer```, and set ```/etc/xdg/reflector/reflector.conf```:
```
    --save /etc/pacman.d/mirrorlist
    --connection-timeout 5
    --download-timeout 5
    --protocol https
    --completion-percent 100.0
    --country de,fr,ch,nl,no,fi,be,at
    --age 2
    --score 10
    --sort rate
```

## Zsh
1. [Autologin](https://wiki.archlinux.org/index.php/getty#Automatic_login_to_virtual_console) and use ```Type=simple``` in drop-in snippet

2. Install [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) and remove all plugins, themes and comment everything except ```export $HOME/.oh-my-zsh```  ```source $ZSH/oh-my-zsh.sh``` ```plugins=()```

3. In ```~/.zshrc``` source files for ```zsh-syntax-highlighting``` ```zsh-autosuggestions``` ```zsh-history-substring-search``` ```zsh-theme-powerlevel10k``` in this exact order

4. Make ```~/.zprofile``` and add [this](https://wiki.archlinux.org/index.php/Sway#Autostart_on_login) to autostart sway, remove ```exec``` to keep logged in after exiting sway

### Sway & Wayland
1. Copy all the configs to  ```~/```, ```~/.config``` and other respective directories

2. To open firefox [in wayland mode](https://wiki.archlinux.org/index.php/firefox#Wayland), set environment variable ```MOZ_ENABLE_WAYLAND=1``` in ```.zshenv```

3. Export ```XDG_SESSION_TYPE=wayland``` and ```XDG_CURRENT_DESKTOP=sway``` to ```.zshenv```

4. ```LIBSEAT_BACKEND=logind``` in ```.zshenv``` in case libseat fails to connect to socket

5. In case hardware acceleration doesn't work out of the box, [set environment variables](https://wiki.archlinux.org/title/Hardware_video_acceleration#Configuration), ```LIBVA_DRIVER_NAME=i965/iHD/radeonsi/nouveau``` and ```VDPAU_DRIVER=va_gl/radeonsi/nouveau```.

6. ```MOZ_WEBRENDER=1``` in case there are performance issues (and/or CPU is not properly utilized/optimized), and ```MOZ_ACCELERATED=1``` in order to force hardware acceleration for MOZ_WEBRENDER to work in case it is disabled by default

### Extras
1. Add ```userChrome.css``` in ```~/.mozilla/firefox/(the_deafult_active_profile)/chrome/```

2. [Enable stylesheets for firefox](https://www.userchrome.org/how-create-userchrome-css.html#aboutconfig) by enabling ```toolkit.legacyUserProfileCustomizations.stylesheets``` in ```about:config```

3. Install the [firefox theme](https://addons.mozilla.org/en-US/firefox/addon/an-even-better-lime-green/) you made

4. Set ```cmus``` theme using ```:colorscheme```

5. Uncomment ```VerbosePkgLists```, ```CheckSpace```, ```Color``` and ```ParallelDownloads = 6``` in ```/etc/pacman.conf```

6. Set ```EDITOR=nvim```, ```TERMINAL=termite``` and ```BROWSER=firefox``` in ```/etc/environment```

### Environment Variable
The ```.zshenv``` file should end up looking like
```
EDITOR=nvim
XDG_SESSION_TYPE=wayland      
XDG_CURRENT_DESKTOP=sway
LIBSEAT_BACKEND=logind
TERMINAL=foot
BROWSER=firefox
MOZ_ENABLE_WAYLAND=1
MOZ_WEBRENDER=1
MOZ_ACCELERATED=1
```

### Disk Layout
<table>
  <tr>
    <td><b>Partitions</b></td>
	<td><b>Windows Readable Partition</b></td>
	<td colspan="2"><b>LUKS Container</b></td>
	<td><b>BIOS Grub Partition</b></td>
	<td><b>UEFI Boot Partition</b></td>
  </tr>
  <tr>
    <td><b>gdisk hex</b></td>
	<td>0700</td>
	<td colspan="2">8300</td>
	<td>ef02</td>
	<td>ef00</td>
  </tr>
    <tr>
    <td rowspan="2"><b>Block Device</b></td>
	<td>/dev/sdx1</td>
	<td colspan="2">/dev/sdx2</td>
	<td>/dev/sdx3</td>
	<td>/dev/sdx4</td>
  </tr> 
    <tr>
	<td></td>
    <td>/dev/VolumeGroup/root</td>
	<td>/dev/VolumeGroup/home</td>
	<td colspan="2"></td>
  </tr>  
    <tr>
    <td><b>File System</b></td>
	<td>FAT32/NTFS</td>
	<td>ext4</td>
	<td>ext4</td>
	<td>Unformatted</td>
	<td>FAT32</td>
  </tr> 
    <tr>
    <td><b>Mountpoint</b></td>
	<td>Not Mounted</td>
	<td>/</td>
	<td>/home</td>
	<td>Not Mounted</td>
	<td>/boot</td>
  </tr>
  <tr>
    <td rowspan="2"><b>Size</b></td>
	<td rowspan="2">As required</td>
	<td>At least 8GiB</td>
	<td>As required</td>
	<td rowspan="2">2MiB</td>
	<td rowspan="2">200MiB</td>
  </tr>
  <tr>
    <td colspan="2">(LUKS Container must accomodate size of both Logical volumes)</td>
  </tr>
</table>

### Packages
##### Base
    base base-devel arch-install-scripts intel-ucode amd-ucode linux linux-lts linux-firmware man-db man-pages dosfstools lvm2 efibootmgr grub
##### System
    git ntp(?) rsync reflector pacman-contrib playerctl brightnessctl libnotify pass bat bottom pulseaudio(maybe switch to pipewire?) pavucontrol(maybe?)
#### Shell
    zsh zsh-history-substring-search zsh-autosuggestions zsh-completions zsh-syntax-highlighting zsh-theme-powerlevel10k
#### Networking
    networkmanager nm-connection-editor modemmanager mobile-broadband-provider-info usb_modeswitch networkmanager-openconnect networkmanager-openvpn openvpn openresolv dnsmasq rp-pppoe(maybe?)
#### Drivers
    mesa mesa-vdpau libva-mesa-driver libva-intel-driver intel-media-driver opencl-mesa vulkan-intel vulkan-mesa-layers vulkan-radeon libinput
##### Sway & Wayland
    xorg-server-xwayland sway swaybg swayidle swaylock waybar mako wofi jq grim slurp wf-recorder wl-clipboard xdg-desktop-portal-wlr kanshi
##### Additional Apps
    neovim vifm foot firefox cmus imv mpv youtube-dl rtorrent
##### Maybe
    exa tldr fzf tickrs mutt/neomutt/notmuch httpie ncdu archlinux-wallpaper
##### Fonts
    adobe-source-code-pro-fonts adobe-source-sans-pro-fonts adobe-source-serif-pro-fonts noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-fira-code ttf-jetbrains-mono ttf-nerd-fonts-symbols ttf-font-awesome
##### AUR
    wlr-randr wlsunset clipman spotify-tui rtv

### Todos
- [x] Transition from i3 to sway ~~(currently in progress)~~ Done
- [x] Setup up fscrypt for home directories (Changed to dm-crypt for system-wide encryption)
- [x] ~~Configure [mlocate](https://wiki.archlinux.org/index.php/mlocate) to change frequency of updatedb in systemd timer unit~~
- [x] Check if mlocate is reuqired in the first place (yeah, not required)
- [x] Make LUKS Header backup
- [x] Filesyetem and journal modifications and optimizations for flash drives
- [ ] Set up Network Manager
- [ ] Set up a firewall
- [ ] Set up a VPN
- [x] Set up session lock (Swaylock for wayland and physlock for tty.
- [ ] Set up a keyring (and check its security to convinience ratio)
- [x] Set up a password manager [used ```pass```](https://www.github.com/somelazykoala/secrets)
- [ ] Set up an IRC and weechat
- [ ] Power management
- [x] MPD and ncmpcpp (used cmus, since it's simpler, more lightweight and faster, may consider switching later tho)
- [x] Transition from Xorg to Wayland (Sway is the most likely candidate)
- [x] Figure out a way to remove Waybar-Workpace-Hover in style.css [(Workaround)](https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect)
- [x] Waybar-Workspace-Index to Bullet icons using JSON hack-workarounds (used CSS for #workspaces button.persistent)
- [x] Sway stacked layout for firefox (workspace 3)
- [x] Make a good color scheme which can be used both at day/night (and stick to it dammit)
- [ ] Window screenshot binding on sway (grim) (Done, but not satisfactory; would like to take full window screenshots even if window is partially hidden by another window)
- [ ] Screenshot current monitor/output
- [ ] Move container to certain output
- [ ] Other multiple output related configs (sway, waybar, etc)
- [ ] Consider switching keyboard layout to Dvorak, Colemak or Wokman
- [x] Use output audio (speakers) for wf-recorder screencasts
- [x] Fix screensharing audio (probably pipewire related) (Not a bug, not supported officialy yet)
- [ ] Consider switching:
	- [x] termite -> foot ~~(hoping for it to come to official repos)~~ in official repos now
	- [ ] brightnessctl -> light (maybe?)
	- [ ] waybar -> yambar (maybe?)
	- [ ] wofi -> bemenu/fuzzel (wofi is unmaintained, so will switched, but idk to what)
	- [x] gammastep -> wlsunset (not in official repos yet either)
    - [ ] h264 -> hevc for ```wf-recorder``` (hevc results in worse quality)
    - [ ] lame -> vorbis-tools (```oggenc - -q8 -b196 -r -o $HOME/Music/recordings/$(date +'%F-%T.mp3'```) (need to weigh pros and cons, so far, oggenc is better but, dependencies might be huge; also need to sort out optimal quality/size ratio.)
	- [ ] pulseaudio -> pipewire
	- [ ] ext4 -> btrfs
	- [ ] grub -> systemd-boot (maybe?)
- [ ] Revise sway config and add ```--release``` and ```--no-repeat``` where necessary
- [ ] Binary tree layout for tiled windows automation scipt
- [ ] Window switching using wofi
- [x] Dictionary using wofi
- [ ] Emote selector using wofi
- [ ] Simple calc (maybe using wofi?)
- [ ] Shazam equivalent tool
- [ ] Restructure sway config (maybe all configs)
- [ ] ```--release``` for kill/floating_toggle mouse keybindings
- [ ] Revise drivers and packages
- [ ] Configure neovim
- [ ] Configure rtorrent
- [ ] Set up hardware acceleration for firefox
- [ ] Set up hardware acceleration for wf-recorder (using hevc, preferably)
- [ ] Revise the entire repo and remove bloat from config files
- [x] Timed wallpapers (changed to random, because userspace systemd timers are messy)
- [x] userChrome.css for firefox (Slowed down startup time and syntax keeps changing, so used themes instead)
- [ ] Spotifyd+Spotify-tui (buy premium you cheap fuck)
- [x] Wayland clipboard manager (will do after clipman is added to official repos)
- [ ] Transition to more CLI apps
- [ ] Transition from GRUB to sytemd-boot once BIOS is obsolete (Not now obviously, but later)

### For Permanent Install (on PC)
* Windows readable partition/Windows partition need not be the first partition
* Partition and format boot partition according to need (Either just for BIOS or just for UEFI)
* Enable journaling (use defaults) for ext4 partitions
* Install GRUB for either just BIOS or UEFI, (or just use systemd-boot in case it's UEFI)
* Use [default](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#Configuring_mkinitcpio_2) encrypt mkinitcpio hooks (Don't move ```blocks``` hook)
* Add a non-admin account ```# useradd -m guest``` and ```passwd guest```
