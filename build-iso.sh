#!/bin/bash
set -e

source /etc/os-release
CODENAME=$VERSION_CODENAME

echo "=> Initializing live-build configuration..."
lb config \
    --binary-images iso-hybrid \
    --iso-volume "DEBIANT2" \
    --bootloaders "grub-efi,syslinux" \
    --distribution "${CODENAME}" \
    --linux-packages "linux" \
    --linux-flavours "t2" \
    --archive-areas "main contrib non-free non-free-firmware" \
    --debootstrap-options "--include=ca-certificates,gnupg" \
    --bootappend-live "boot=live components quiet splash username=akop"

echo "=> T2 reposity configuration..."
mkdir -p config/archives
curl -s --compressed "https://adityagarg8.github.io/t2-ubuntu-repo/KEY.gpg" -o config/archives/t2.key.chroot
echo "deb https://adityagarg8.github.io/t2-ubuntu-repo/ ./" > config/archives/t2.list.chroot
echo "deb https://github.com/AdityaGarg8/t2-ubuntu-repo/releases/download/${CODENAME} ./" >> config/archives/t2.list.chroot

echo "=> Configuring WezTerm Repository..."
curl -fsSL https://apt.fury.io/wez/gpg.key -o config/archives/wezterm.key.chroot
echo "deb https://apt.fury.io/wez/ * *" > config/archives/wezterm.list.chroot

echo "=> Pre-loading dotfiles and wallpapers..."
mkdir -p config/includes.chroot/etc/skel/{Projects,.config}
git clone https://github.com/akopdev/dotfiles.git config/includes.chroot/etc/skel/.dotfiles
git clone https://github.com/akopdev/wallpapers.git config/includes.chroot/etc/skel/wallpapers

echo "=> Starting live-build process..."
lb build

echo "=> Copying finished ISO to output directory..."
if ls *.iso 1> /dev/null 2>&1; then
    cp *.iso /output/
    echo "=> Build complete! Check your output folder."
else
    echo "=> Build failed. ISO not found. Here is what is in the directory:"
    ls -la
    exit 1
fi
