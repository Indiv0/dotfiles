#!/bin/sh
set -e

pac_install () {
    sudo pacman --sync --needed --noconfirm $@
}

aur_install () {
    directory=${2:-$1}
    (cd $HOME/src/aur &&\
        auracle clone $1 &&\
        cd $directory &&\
        makepkg --syncdeps --install --needed --noconfirm)
}

user=$(id --user --name)

# Install man to be able to view man pages for programs.
pac_install man

# Install xorg-server and xorg-xinit to be able to run X.
# Install bspwm and sxhkd for a tiling WM & keybind manager.
# Install rxvt-unicode for a terminal console server & client.
# Install xorg-xset for setting the X font path. This is necessary for rxvt-unicode to see fonts like ttf-iosevka.
# Install xorg-xrdb for setting font settings, etc. for rxvt-unicode.
pac_install xorg-server xorg-xinit xorg-xset xorg-xrdb xorg-mkfontscale bspwm sxhkd rxvt-unicode

# Install base-devel to be able to compile & install packages from the AUR.
pac_install base-devel
mkdir --parents $HOME/src/aur

# Install auracle-git to manage AUR packages.
if ! [ -f $HOME/src/aur/auracle-git/PKGBUILD ]; then
    mkdir $HOME/src/aur/auracle-git
    curl --location https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=auracle-git > $HOME/src/aur/auracle-git/PKGBUILD
fi
(cd $HOME/src/aur/auracle-git &&\
    makepkg --syncdeps --install --needed --noconfirm)

# Install urxvt-resize-font-git for resizing urxvt font size on-the-fly.
# See: https://blog.khmersite.net/2017/12/change-the-urxvt-font-size-on-the-fly/
aur_install urxvt-resize-font-git

# Install the ttf-iosevka font.
aur_install ttf-iosevka
# Generate the fonts.dir so that `xset fp /usr/share/fonts/local` works.
(cd /usr/share/fonts &&\
    sudo mkfontscale &&\
    sudo mkfontdir)

# Install noto-fonts to provide ttf-font and serve as a fallback for my preferred fonts.
pac_install noto-fonts

# Install tmux.
pac_install tmux

# Install Firefox.
pac_install firefox

pac_install smartmontools

pac_install docker
sudo gpasswd -a $user docker
aur_install libnvidia-container-tools libnvidia-container
aur_install nvidia-container-toolkit

pac_install mlocate
sudo systemctl start updatedb.timer

pac_install discord

pac_install rsync

pac_install rustup sccache
rustup update stable

pac_install openssh
if ! [ -f $HOME/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519
fi

pac_install dmenu

# qt5-base is necessary for pinentry-qt to work
pac_install pass qt5-base

# For creating chroots
# See: https://wiki.archlinux.org/index.php/DeveloperWiki:Building_in_a_clean_chroot#Classic_way
pac_install devtools

pac_install aws-cli

pac_install borg lftp

# For connecting to Cisco AnyConnect VPN.
if [ "$MACHINE" == "work" ]; then
    pac_install openconnect
fi

# for the ping utility
#pac_install iputils

# for audio
pac_install pulseaudio pavucontrol

# Ale for code completion in VIM.
pac_install vim-ale

# xhost command for providing access to an application running in chroot to
# the graphical server.
# https://wiki.archlinux.org/index.php/chroot#Run_graphical_applications_from_chroot
pac_install xorg-xhost

if [ "$MACHINE" == "work" ]; then
    aur_install teams
fi
