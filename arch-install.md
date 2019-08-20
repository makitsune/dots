# 0. Core installation

## Partitioning disks

**BIOS, MBR, DOS**
```bash
# create a single partition, bootable
cfdisk /dev/sda

mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt
```

**UEFI, GPT**
```bash
# create 512M partition, EFI system
# create second parition
cfdisk /dev/sda

mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
```

## Installing base

```bash
# (optional) set geographically close mirror top
nano /etc/pacman-d/mirrorlist

pacstrap /mnt base base-devel
genfstab -U /mnt > /mnt/etc/fstab
arch-chroot /mnt
```

## Configuring bootloader

**BIOS, MBR, DOS**
```bash
pacman -S grub os-prober
grub-install --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```

**UEFI, GPT**
```bash
bootctl install

nano /boot/loader/entries/arch.conf
	title		Arch Linux
	linux		/vmlinuz-linux
	initrd		/initramfs-linux.img
	options		root=/dev/sda2 rw

nano /boot/loader/loader.conf
	timeout 3
	default arch
```

## Restart and remove bootable media

```bash
exit
reboot
```

# 1. Basic settings

```bash
passwd
echo machine > /etc/hostname

useradd -m -G wheel maki
passwd maki

# uncomment %wheel ALL=(ALL) ALL
EDITOR=nano visudo

ip link # find network card name
systemctl enable dhcpd@enp0s3
systemctl start dhcpd@enp0s3

nano /etc/locale.gen # uncomment locale
locale-gen
localectl set-locale LANG=en_US.UTF-8

tzselect # PST is 2, 48, 21
timedatectl set-timezone "America/Los_Angeles"

hwclock --systohc --utc
timedatectl set-ntp true

nano /etc/pacman.conf # uncomment Color

pacman -Sy && reboot
```

# 2. Video drivers and window manager

## Video drivers

```bash
pacman -S xf86-video-vesa # default driver
pacman -S mesa # OpenGL
pacman -S # driver below, usually nvidia
```

|               |**Nvidia**        |**AMD**          |**Intel**       |**VMware**       |
|---------------|------------------|-----------------|----------------|-----------------|
|**Open Source**|xf86-video-nouveau|xf86-video-amdgpu|xf86-video-intel|xf86-video-vmware|
|               |                  |xf86-video-ati   |                |                 |
|               |                  |                 |                |             <br>|
|**Proprietary**|nvidia            |catalyst         |                |                 |
|               |nvidia-340xx      |                 |                |                 |
|               |nvidia-304xx      |                 |                |                 |

```bash
pacman -S xorg-server xorg-xinit xterm
```

## Window manager

```bash
pacman -S i3-gaps i3status dmenu ttf-roboto

nano .xinitrc
	exec i3

startx
```

# 3. Others

## Installing aurman

```bash
git clone https://aur.archlinux.org/aurman
sudo pacman -S expac python-requests python-regex python-dateutil pyalpm python-feedparser
gpg --recv 465022E743D71E39
makepkg -i
```

## Set a background

```bash
sudo pacman -S feh
vim ~/.config/i3/config
	exec --no-startup-id feh --bg-fill /media/the-witness.png
```

## Other applications

```bash
sudo pacman -S network-manager-applet rxvt-unicode baobab neofetch lxappearance arc-gtk-theme
aurman -S sublime-text-dev google-chrome-dev tamzen-font numix-circle-arc-icons-git
```

## i3wm config

```bash
vim ~/.config/i3/config
	for_window [class=".*"] border pixel 0
```

## VMware

```bash
sudo pacman -S open-vm-tools
sudo systemctl enable vmtoolsd
sudo systemctl start vmtoolsd
```