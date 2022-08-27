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
- [ ] Remove ohmyzsh
- [ ] Power management
- [x] MPD and ncmpcpp (used cmus, since it's simpler, more lightweight and faster, may consider switching later tho)
- [x] Transition from Xorg to Wayland (Sway is the most likely candidate)
- [x] Figure out a way to remove Waybar-Workpace-Hover in style.css [(Workaround)](https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect)
- [x] Waybar-Workspace-Index to Bullet icons using JSON hack-workarounds (used CSS for #workspaces button.persistent)
- [x] Sway stacked layout for firefox (workspace 3)
- [ ] Make a good color scheme which can be used both at day/night (and stick to it dammit) (catpuccin and nord are candidates)
- [ ] Window screenshot binding on sway (grim) (Done, but not satisfactory; would like to take full window screenshots even if window is partially hidden by another window)
- [x] Screenshot current monitor/output
- [x] Move container to certain output
- [ ] Other multiple output related configs (sway, waybar, etc)
- [ ] Consider switching keyboard layout to Dvorak, Colemak or Wokman
- [x] Use output audio (speakers) for wf-recorder screencasts
- [x] Fix screensharing audio (probably pipewire related) (Not a bug, not supported officialy yet)
- [ ] Consider switching:
	- [x] termite -> foot ~~(hoping for it to come to official repos)~~ in official repos now
	- [ ] brightnessctl -> light (maybe?)
	- [ ] waybar -> yambar (maybe?)
	- [ ] wofi -> bemenu/fuzzel (wofi is unmaintained, so will switched, but idk to what)
	- [ ] pass -> something that uses symmetric encryption, preferably encrypts file structure and names too
	- [x] gammastep -> wlsunset (not in official repos yet either)
	- [ ] spotify-tui -> ncspot
        - [ ] h264 -> hevc for ```wf-recorder``` (hevc results in worse quality)
        - [ ] lame -> vorbis-tools (```oggenc - -q8 -b196 -r -o $HOME/Music/recordings/$(date +'%F-%T.mp3'```) (need to weigh pros and cons, so far, oggenc is better but, dependencies might be huge; also need to sort out optimal quality/size ratio.) Or flac(?), for lossless files.
        - [ ] Try to switch to lossless but compressed formats for audio recording/screenshots/screencasts/anything saved to disk
	- [ ] pulseaudio -> pipewire
	- [ ] ext4 -> btrfs
	- [ ] grub -> systemd-boot (maybe?)
- [ ] Revise sway config and add ```--release``` and ```--no-repeat``` where necessary
- [ ] Revise sway keybindings
- [ ] Binary tree layout for tiled windows automation scipt
- [ ] Update mako config (invoking makoctl DND mode, away mode, low priority styles+timing, progress styling, etc)
- [ ] Clean up waybar configs + Add proper multi-monitor indicators for workspace module
- [ ] Primary monitor only configs (workspace-module-only waybar, mako, swaylock ring on primary monitor only) (will do when a wayland protocol for primary output is decided)
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
- [ ] Create some gl-paper shaders
- [x] userChrome.css for firefox (Slowed down startup time and syntax keeps changing, so used themes instead)
- [ ] Spotifyd+Spotify-tui (buy premium you cheap fuck)
- [ ] Fix clipman configs in .config/sway/config (might do properly after clipman is added to official repos)
- [ ] Transition to more CLI apps
- [ ] Transition from GRUB to sytemd-boot once BIOS is obsolete (Not now obviously, but later)

### For Permanent Install (on PC)
* Windows readable partition/Windows partition need not be the first partition
* Partition and format boot partition according to need (Either just for BIOS or just for UEFI)
* Enable journaling (use defaults) for ext4 partitions
* Install GRUB for either just BIOS or UEFI, (or just use systemd-boot in case it's UEFI)
* Use [default](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#Configuring_mkinitcpio_2) encrypt mkinitcpio hooks (Don't move ```blocks``` hook)
* Add a non-admin account ```# useradd -m guest``` and ```passwd guest```

ssd specific
periodic fstrim
btrfs specific:
install snapper
1. mkfs.btrfs -L "label" --csum xxhash /dev/device
2. btrfs mount options noatime,compress-force=zstd:1,datacow,datasum,nodiscard,space_cache=v2,ssd
zstd:1 in case of nvme, zstd:2 for sata ssd, zstd:(default) for hdds, since cpu calculations compression can be a bottleneck; noatime -> relatime in case apps mishave; sdd in case of ssd
3. sudo btrfs subvolume create /mnt/test/{@,@home,@snapshots,@var}
4. umount /mnt/test
5. sudo mount -o noatime,compress-force=zstd:1,datacow,datasum,nodiscard,space_cache=v2,ssd,subvol=@ /dev/mapper/cryptroot /mnt/test
6. sudo mount -o noatime,compress-force=zstd:1,datacow,datasum,nodiscard,space_cache=v2,ssd,subvol=@home /dev/mapper/cryptroot /mnt/test/home
7. sudo mount -o noatime,compress-force=zstd:1,datacow,datasum,nodiscard,space_cache=v2,ssd,subvol=@var /dev/mapper/cryptroot /mnt/test/var
8. sudo mount -o noatime,compress-force=zstd:1,datacow,datasum,nodiscard,space_cache=v2,ssd,subvol=@snapshots /dev/mapper/cryptroot /mnt/test/snapshots

cod mw2
nfs shift2
nfs mw 2012
far cry 2
gta 4
gta sa
gta 3
portal
portal 2
stanley parable
half life
half life 2
half life alyx
