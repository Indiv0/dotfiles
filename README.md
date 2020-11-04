# dotfiles
My personal Linux dotfiles.

These dotfiles are meant to be installed on a fresh Arch Linux system, and are
highly personalized. I strongly recommend you read them thoroughly before use,
or only take relevant bits and pieces.

Most of the software configured in these dotfiles is installed by
[`bootstrap.sh`][/bootstrap.sh]. This script should ideally be run after
approximately these commands to configure an Arch Linux install:

```sh
pacman -S base-devel
less /etc/fstab
ln -sf /usr/share/zoneinfo/Canada/Eastern /etc/localtime
hwclock --systohc
pacman -S vim
vim /etc/locale.gen 
locale-gen
vim /etc/locale.conf
vim /etc/hostname
vim /etc/hosts
vim /etc/mkinitcpio.conf 
mkinitcpio -P
pacman -S intel-ucode
bootctl install
vim /boot/loader/entries/arch.conf
vim /boot/loader/loader.conf 
vim /etc/systemd/network/20-wired.network
systemctl start systemd-networkd
systemctl enable systemd-networkd
systemctl start systemd-resolved
systemctl enable systemd-resolved
pacman -S linux-lts
cp /boot/loader/entries/arch.conf /boot/loader/entries/arch-lts.conf
vim /boot/loader/entries/arch-lts.conf
vim /etc/modprobe.d/blacklist.conf
pacman -S xorg-server
pacman -S xorg-xinit
useradd -m indiv0
passwd indiv0
# Swap file size, if using hibernation, should be
# equal to round(sqrt(RAM)). For 32GB of
# RAM that's 38912MB.
# See: https://help.ubuntu.com/community/SwapFaq#How_much_swap_do_I_need.3F
dd if=/dev/zero of=/swapfile bs=1M count=38912
mkswap /swapfile
chmod 600 /swapfile
swapon /swapfile
# For information on adding the swapfile
# to fstab, see:
# https://confluence.jaytaala.com/display/TKB/Use+a+swap+file+and+enable+hibernation+on+Arch+Linux+-+including+on+a+LUKS+root+partition#UseaswapfileandenablehibernationonArchLinuxincludingonaLUKSrootpartition-Createandenableswapfileonrootpartition
# NOTE: when using a swap file for
# hibernation, the resume parameter must
# point to the unlocked/mapped device that
# contains the file system with the swap
# file.
# See: https://wiki.archlinux.org/index.php/Dm-crypt/Swap_encryption#Using_a_swap_file
# NOTE: you can get the swap_file_offset to use for the resume_offset parameter with:
# `filefrag -v /swapfile | awk '{ if($1=="0:"){print $4}}'
# See: https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate#Hibernation_into_swap_file
vim /etc/fstab
EDITOR=vim visudo
systemctl start systemd-timesyncd
systemctl enable systemd-timesyncd
echo "nameserver 1.1.1.1" >> /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
```
