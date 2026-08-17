# t2-debian-iso

Very opinionated Debian Live ISO for my old Apple MacBook Pro 13".


## About

Old Apple Intel-based devices have been shipped with a custom ARM chip T2, aimed
to protect the device and control its features, like Secure Boot, Touch ID, etc.
The [T2 Linux](https://wiki.t2linux.org/) project brings Linux support to Apple devices
with a set of Linux kernel patches and drivers that allow running major distributions
on old machines.

This project builds a Live Debian Trixie ISO disk that is fully
customized for my needs: it comes with a window manager of my choice ([i3wm](https://i3wm.org/)),
my set of CLI tools and my personal [dotfiles](https://github.com/akopdev/dotfiles).

For a more generic distribution I recommend checking out [Aditya Garg's t2-ubuntu-repo](https://github.com/AdityaGarg8/t2-ubuntu-repo)
project that inspired me a lot. Unlike Aditya, I fully automated the build process,
including pre-building WiFi/Bluetooth firmware, usually done manually after first start,
so you will be able to surf the web right after boot without juggling with ethernet-over-USB.

T2 Debian is designed to work well from a USB stick, but you can install it on a device
as well. It comes with the [Calamares](https://github.com/calamares/calamares) installer and a custom
config to simplify the process.

If you are interested in building the same setup for yourself, I encourage you
to fork this repo and modify it. Feel free to open PRs/issues with relevant improvements.

## What is inside

- T2 kernel and drivers
- i3 window manager: x11, i3blocks, rofi
- Homebrew package manager

## How to build

Normally I build the ISO on my Mac mini with an M5 chip, but you can run a GitHub Action that 
comes with this repo.

I write a straightforward makefile that covers most of my needs:

```bash
# Build the ISO disk
make build

# Write ISO on USB stick
make flash
```
In the early stages of this project, I was running the built ISO in QEMU with `make start`,
but it turned out to be super slow due to cross-platform emulation. Anyway, it is 
still there if you need it.

Run `make` with no arguments to see all available targets.

## Credits

This project builds on work from the T2 Linux community and other open-source
projects:

- [T2 Linux](https://wiki.t2linux.org/) and [Aditya Garg's t2-ubuntu-repo](https://github.com/AdityaGarg8/t2-ubuntu-repo) T2 kernel, drivers, and the `firmware.sh` tooling 
- [kholia/OSX-KVM](https://github.com/kholia/OSX-KVM) used to download the macOS recovery image that the Wi-Fi/Bluetooth firmware is extracted from.
- [kekrby/t2-better-audio](https://github.com/kekrby/t2-better-audio) ALSA/PipeWire mixer profiles for T2 audio.
