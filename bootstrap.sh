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
if ! [ "$HOSTNAME" == "hephaestus" ]; then
    pac_install xorg-server xorg-xinit xorg-xset xorg-xrdb xorg-mkfontscale bspwm sxhkd rxvt-unicode
else
    # Allows X11 Forwarding over SSH
    # https://wiki.archlinux.org/index.php/OpenSSH#X11_forwarding
    pac_install xorg-xauth xorg-xhost
fi

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
if ! [ "$HOSTNAME" == "hephaestus" ]; then
    aur_install urxvt-resize-font-git
fi

# Install the ttf-iosevka font.
if ! [ "$HOSTNAME" == "hephaestus" ]; then
    aur_install ttf-iosevka
    # Generate the fonts.dir so that `xset fp /usr/share/fonts/local` works.
    (cd /usr/share/fonts &&\
        sudo mkfontscale &&\
        sudo mkfontdir)
fi

# Install noto-fonts to provide ttf-font and serve as a fallback for my preferred fonts.
pac_install noto-fonts

# Install tmux.
if ! [ "$HOSTNAME" == "hephaestus" ]; then
    pac_install tmux
fi

# Install Firefox.
pac_install firefox

if ! [ "$HOSTNAME" == "hephaestus" ]; then
    pac_install smartmontools
fi

pac_install docker
sudo gpasswd -a $user docker
if ! [ "$HOSTNAME" == "hephaestus" ]; then
    aur_install libnvidia-container-tools libnvidia-container
    aur_install nvidia-container-toolkit
fi

pac_install mlocate
sudo systemctl start updatedb.timer

if ! [ "$HOSTNAME" == "hephaestus" ]; then
    pac_install discord
fi

if ! [ "$HOSTNAME" == "hephaestus" ]; then
    pac_install rsync
fi

pac_install rustup sccache
rustup update stable

# Install rust utilities
if [ ! -f ~/.cargo/bin/rg ]; then
    cargo install ripgrep
fi

pac_install openssh
if ! [ -f $HOME/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519
fi

if ! [ "$HOSTNAME" == "hephaestus" ]; then
    pac_install dmenu
fi

# qt5-base is necessary for pinentry-qt to work
if ! [ "$HOSTNAME" == "hephaestus" ]; then
    pac_install pass qt5-base
fi

# For creating chroots
# See: https://wiki.archlinux.org/index.php/DeveloperWiki:Building_in_a_clean_chroot#Classic_way
if ! [ "$HOSTNAME" == "hephaestus" ]; then
    pac_install devtools
fi

if ! [ "$HOSTNAME" == "hephaestus" ]; then
    pac_install aws-cli
fi

if ! [ "$HOSTNAME" == "hephaestus" ]; then
    pac_install borg lftp
fi

# For connecting to Cisco AnyConnect VPN.
if [ "$HOSTNAME" == "hephaestus" ]; then
    pac_install openconnect
fi

# for the ping utility
#pac_install iputils

# for audio
if ! [ "$HOSTNAME" == "hephaestus" ]; then
    pac_install pulseaudio pavucontrol
fi

# Ale for code completion in VIM.
pac_install vim-ale

# xhost command for providing access to an application running in chroot to
# the graphical server.
# https://wiki.archlinux.org/index.php/chroot#Run_graphical_applications_from_chroot
if ! [ "$HOSTNAME" == "hephaestus" ]; then
    pac_install xorg-xhost
fi

#if [ "$HOSTNAME" == "hephaestus" ]; then
#    aur_install teams
#fi

# Install Java & utilities
if [ "$HOSTNAME" == "hephaestus" ]; then
    pac_install jdk-openjdk maven
fi

# Install QEMU for running virtual machines
if ! [ "$HOSTNAME" == "hephaestus" ]; then
    pac_install qemu-headless edk2-ovmf
fi

if ! [ "$HOSTNAME" == "hephaestus" ]; then
    pac_install scrot
fi
