#!/bin/sh
set -e

user=$(id --user --name)

# Install man to be able to view man pages for programs.
sudo pacman --sync --needed --noconfirm man

# Install xorg-server and xorg-xinit to be able to run X.
# Install bspwm and sxhkd for a tiling WM & keybind manager.
# Install rxvt-unicode for a terminal console server & client.
# Install xorg-xset for setting the X font path. This is necessary for rxvt-unicode to see fonts like ttf-iosevka.
# Install xorg-xrdb for setting font settings, etc. for rxvt-unicode.
sudo pacman --sync --needed --noconfirm xorg-server xorg-xinit xorg-xset xorg-xrdb xorg-mkfontscale bspwm sxhkd rxvt-unicode

# Install base-devel to be able to compile & install packages from the AUR.
sudo pacman --sync --needed --noconfirm base-devel
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
(cd $HOME/src/aur &&\
    auracle clone urxvt-resize-font-git &&\
    cd urxvt-resize-font-git &&\
    makepkg --syncdeps --install --needed --noconfirm)

# Install the ttf-iosevka font.
(cd $HOME/src/aur &&\
    auracle clone ttf-iosevka &&\
    cd ttf-iosevka &&\
    makepkg --syncdeps --install --needed --noconfirm)
# Generate the fonts.dir so that `xset fp /usr/share/fonts/local` works.
(cd /usr/share/fonts &&\
    sudo mkfontscale &&\
    sudo mkfontdir)

# Install noto-fonts to provide ttf-font and serve as a fallback for my preferred fonts.
sudo pacman --sync --needed --noconfirm noto-fonts

# Install tmux.
sudo pacman --sync --needed --noconfirm tmux

# Install Firefox.
sudo pacman --sync --needed --noconfirm firefox

sudo pacman --sync --needed --noconfirm smartmontools

sudo pacman --sync --needed --noconfirm docker
sudo gpasswd -a $user docker
(cd $HOME/src/aur &&\
    auracle clone libnvidia-container-tools &&\
    cd libnvidia-container &&\
    makepkg --syncdeps --install --needed --noconfirm)
(cd $HOME/src/aur &&\
    auracle clone nvidia-container-toolkit &&\
    cd nvidia-container-toolkit &&\
    makepkg --syncdeps --install --needed --noconfirm)

sudo pacman --sync --needed --noconfirm mlocate
sudo systemctl start updatedb.timer

sudo pacman --sync --needed --noconfirm discord

sudo pacman --sync --needed --noconfirm rsync

sudo pacman --sync --needed --noconfirm rustup sccache
rustup update stable

sudo pacman --sync --needed --noconfirm openssh
if ! [ -f $HOME/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519
fi

sudo pacman --sync --needed --noconfirm dmenu

sudo pacman --sync --needed --noconfirm pass

# For creating chroots
# See: https://wiki.archlinux.org/index.php/DeveloperWiki:Building_in_a_clean_chroot#Classic_way
sudo pacman --sync --needed --noconfirm devtools

sudo pacman --sync --needed --noconfirm aws-cli
