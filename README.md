Backup to set up an encrypted Arch on a USB drive (bootable on both BIOS and UEFI preferably). Checklist to see if I forgot something. The configs are just barebones to get a functioning i3 desktop (will add more as I progress). [Still todos](#todos)

## Base Installation
1. [Setting up gpt table and partitioning disk](https://wiki.archlinux.org/index.php/GPT_fdisk#Create_a_partition_table_and_partitions) with [this layout](#Layout)

2. [Setting up LUKS Container, Logical Volumes](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS)

3. [Backing up and restoring LUKS Header](https://wiki.archlinux.org/index.php/Dm-crypt/Device_encryption#Backup_and_restore)

4. [Installing base Arch](https://wiki.archlinux.org/index.php/Installation_guide#Installation) with [these packages](#Packages)

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

<!---## Other System Related--->
[//]: # (NetworkManager)
[//]: # (Password Manager)

## Zsh
1. [Autologin](https://wiki.archlinux.org/index.php/getty#Automatic_login_to_virtual_console) and use ```Type=simple``` in drop-in snippet

2. Install [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) and remove all plugins

3. In ```~/.zshrc``` source files for ```zsh-syntax-highlighting``` ```zsh-autosuggestions``` ```zsh-history-substring-search``` ```zsh-theme-powerlevel10k``` in the exact order

4. Make ```~/.zprofile``` and add [this](https://wiki.archlinux.org/index.php/Xinit#Autostart_X_at_login) to autostart xorg

## Xorg and WM
1. ```~/.xinitrc``` and ```~/.xserverrc``` [configuration](https://wiki.archlinux.org/index.php/Xinit#Configuration) and ```$ chmod +x```

2. Remove the last part of ```~/.xinitrc``` from ```twm...login```

3. [Set wallpaper](https://wiki.archlinux.org/index.php/Feh#Set_the_wallpaper) using ```feh``` and append ```~/.fehbg &``` to ```.xinitrc```

4. Copy ```/etc/xdg/picom.conf.example``` to ```~/.config/picom/picom.conf``` and [configure](https://wiki.archlinux.org/index.php/Picom#Configuration). Append ```picom &``` to ```~/.xinitrc```

<!---## USB Flash Specific--->

### Layout
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
    base base-devel arch-install-scripts zsh zsh-history-substring-search zsh-autosuggestions zsh-completions zsh-syntax-highlighting zsh-theme-powerlevel10k intel-ucode amd-ucode linux linux-lts linux-firmware dosfstools ntfs-3g lvm2 efibootmgr grub nano
##### Drivers
    xf86-video-vesa xf86-video-ati xf86-video-intel xf86-video-amdgpu xf86-video-nouveau xf86-input-synaptics xf86-input-libinput
##### WM
    xorg-server xorg-init feh picom i3-gaps i3lock-color dunst polybar(aur)
##### Additional Apps
    firefox kitty/alacritty/rxvt-unicode vlc cmus ranger
##### Fonts
    adobe-source-code-pro-fonts adobe-source-sans-pro-fonts adobe-source-serif-pro-fonts noto-fonts noto-fonts-emoji ttf-roboto ttf-anonymous-pro ttf-cascadia-code ttf-inconsolata ttf-fira-code ttf-hack


### Todos
- [x] Transition from i3 to BSPWM (sticking to i3-gaps, too much hassle to set up config for universal support)
- [x] Setup up fscrypt for home directories (Changed to dm-crypt for system-wide encryption)
- [x] Configure [mlocate](https://wiki.archlinux.org/index.php/mlocate) to change frequency of updatedb in systemd timer unit
- [x] Check if mlocate is reuqired in the first place (Answer: not required)
- [x] Make LUKS Header backup
- [ ] Filesyetem and journal modifications and optimizations for flash drives
- [ ] Set up NetworkManager and nm-applet
- [ ] Check how to source substring-search without oh-my-zsh bloat
- [ ] Set up a password manager, preferably [pass](https://wiki.archlinux.org/index.php/Pass)
- [ ] Transition to complete CLI apps if possible
- [ ] Transition from GRUB to sytemd-boot once BIOS is obsolete (Not now obviously, but later)
* WM related
- [ ] i3 setup
	- [ ] borders
	- [ ] firefox and vlc specific worskspace config
	- [ ] i3lock-color
- [ ] choose a status bar and set it up
- [ ] dunst config
- [ ] rofi config
- [ ] urxvt config

### For Permanent Install (on PC)
* Windows readable partition/Windows partition need not be the first partition
* Enable journaling (use defaults) for ext4 partitions
* Install GRUB for either just BIOS or UEFI, (or just use systemd-boot in case it's UEFI)
* Use [default](https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#Configuring_mkinitcpio_2) encrypt mkinitcpio hooks (Don't move ```blocks``` hook)
