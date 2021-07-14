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
    --score 5
    --sort rate
```

## Zsh
1. [Autologin](https://wiki.archlinux.org/index.php/getty#Automatic_login_to_virtual_console) and use ```Type=simple``` in drop-in snippet

2. Install [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) and remove all plugins, themes and comment everything except ```export $HOME/.oh-my-zsh```  ```source $ZSH/oh-my-zsh.sh``` ```plugins=()```

3. In ```~/.zshrc``` source files for ```zsh-syntax-highlighting``` ```zsh-autosuggestions``` ```zsh-history-substring-search``` ```zsh-theme-powerlevel10k``` in this exact order

4. Make ```~/.zprofile``` and add [this](https://wiki.archlinux.org/index.php/Sway#Autostart_on_login) to autostart sway, remove ```exec``` to keep logged in after exiting sway

### Sway & Wayland
1. Copy all the configs to  ```~/```, ```~/.config``` and other respective directories

2. To open firefox [in wayland mode](https://wiki.archlinux.org/index.php/firefox#Wayland), set environment variable ```MOZ_ENABLE_WAYLAND=1``` in ```/etc/environment```. The wiki [says](https://wiki.archlinux.org/index.php/Environment_variables#Graphical_environment) to set the variable in ```~/.config/environment.d/envvars.conf```, but it doesn't work for some reason (have to figure out why), so setting it [globally](https://wiki.archlinux.org/index.php/Environment_variables#Globally)

3. ```LIBSEAT_BACKEND=logind``` in ```/etc/environment``` in case libseat fails to connect to socket

4. [systemd-sway integration](https://github.com/swaywm/sway/wiki/Systemd-integration)

### Extras
1. Add ```userChrome.css``` in ```~/.mozilla/firefox/(the_deafult_active_profile)/chrome/```

2. [Enable stylesheets for firefox](https://www.userchrome.org/how-create-userchrome-css.html#aboutconfig) by enabling ```toolkit.legacyUserProfileCustomizations.stylesheets``` in ```about:config```

3. Install the [firefox theme](https://addons.mozilla.org/en-US/firefox/addon/an-even-better-lime-green/) you made

4. Set ```cmus``` theme using ```:colorscheme```

5. Uncomment ```VerbosePkgLists```, ```CheckSpace```, ```TotalDownload```, ```Color``` in ```/etc/pacman.conf```

6. Set ```EDITOR=nvim``` in ```/etc/environment```

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
    base base-devel arch-install-scripts intel-ucode amd-ucode linux linux-lts linux-firmware man-db man-pages dosfstools ntfs-3g lvm2 efibootmgr grub nano
##### System
    ntp reflector playerctl brightnessctl libnotify pulseaudio pavucontrol(maybe?)
#### Shell
    zsh zsh-history-substring-search zsh-autosuggestions zsh-completions zsh-syntax-highlighting zsh-theme-powerlevel10k
#### Networking
    networkmanager nm-connection-editor modemmanager mobile-broadband-provider-info usb_modeswitch networkmanager-openconnect networkmanager-openvpn openvpn openresolv dnsmasq rp-pppoe(maybe?)
#### Drivers
    mesa mesa-vdpau libva-mesa-driver opencl-mesa vulkan-intel vulkan-mesa-layers vulkan-radeon libinput
##### Sway & Wayland
    archlinux-wallpaper xorg-server-xwayland sway swaybg swayidle swaylock waybar mako wofi jq grim slurp wf-recorder wl-clipboard gammastep kanshi clipman(aur)
##### Additional Apps
    termite neovim vifm firefox cmus vlc/mpv/both mutt/neomutt/notmuch rtv youtube-dl spotify-tui(aur)
##### Fonts
    adobe-source-code-pro-fonts adobe-source-sans-pro-fonts adobe-source-serif-pro-fonts noto-fonts noto-fonts-emoji ttf-fira-code ttf-jetbrains-mono ttf-nerd-fonts-symbols ttf-font-awesome


### Todos
- [x] Transition from i3 to sway ~~(currently in progress)~~ Done
- [x] Setup up fscrypt for home directories (Changed to dm-crypt for system-wide encryption)
- [x] ~~Configure [mlocate](https://wiki.archlinux.org/index.php/mlocate) to change frequency of updatedb in systemd timer unit~~
- [x] Check if mlocate is reuqired in the first place (yeah, not required)
- [x] Make LUKS Header backup
- [x] Filesyetem and journal modifications and optimizations for flash drives
- [ ] Sway-systemd integration
- [ ] Set up Network Manager
- [ ] Set up a firewall
- [ ] Set up a VPN
- [x] Set up session lock (Swaylock for wayland and physlock for tty.
- [ ] Set up a keyring (and check its security to convinience ratio)
- [ ] Set up a password manager, preferably [KeePassXC](https://wiki.archlinux.org/index.php/KeePass)
- [ ] Set up an IRC and an IRC client (irssi maybe)
- [ ] Power management
- [x] MPD and ncmpcpp (used cmus, since it's simpler, more lightweight and faster, may consider switching later tho)
- [x] Transition from Xorg to Wayland (Sway is the most likely candidate)
- [x] Figure out a way to remove Waybar-Workpace-Hover in style.css [(Workaround)](https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect)
- [x] Waybar-Workspace-Index to Bullet icons using JSON hack-workarounds (used CSS for #workspaces button.persistent)
- [x] Sway stacked layout for firefox (workspace 3)
- [x] Make a good color scheme which can be used both at day/night (and stick to it dammit)
- [x] Window screenshot binding on sway (grim)
- [x] Use output audio (speakers) for wf-recorder screencasts
- [ ] Binary tree layout for tiled windows automation scipt
- [ ] ```--release``` for kill/floating_toggle mouse keybindings
- [x] Revise Drivers, Xorg and Window Manager packages
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
