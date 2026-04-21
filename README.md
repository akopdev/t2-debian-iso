# t2-debian-iso

Custom Debian live ISO for Apple T2 Macs. Bundles T2-specific kernel, drivers 
and custom software with pre-loaded dotfiles.

## What's included

- T2 kernel and drivers
- i3 window manager


## Usage

```bash
# Build the ISO disk
make build

# Run live disk in QEMU
make start

# Remove generated ISOs and the builder image
make clean
```

Run `make` with no arguments to see all available targets.
