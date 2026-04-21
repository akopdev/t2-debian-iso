.EXPORT_ALL_VARIABLES:
.DEFAULT_GOAL: help

# The path to the aarch64 UEFI firmware.
# This path is specific to MacOS with, Qemu installed with  Homebrew.
# Change this variable if you're on a different system.
QEMU_BIOS_PATH ?= /opt/homebrew/share/qemu/edk2-aarch64-code.fd

# --[ JOBS ] ------------------------------------------------------------------

.PHONY: help 
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

.PHONY: init 
init:
	@docker buildx build --platform linux/amd64 -t iso-builder:latest --load .

.PHONY: build 
build: init ## Build custom Debian ISO disk
	@docker run -it --rm \
		--privileged \
		--platform linux/amd64 \
		-v $(CURDIR)/output:/output \
		iso-builder:latest


.PHONY: start 
start: ## Run Live Debian using QEMU
	@ISO_FILE=$$(ls $(CURDIR)/output/*.iso 2>/dev/null | head -n 1); \
	if [ -z "$$ISO_FILE" ]; then \
		echo "Error: No ISO found. Run 'make build' first."; \
		exit 1; \
	fi; \
	qemu-system-x86_64 \
			-machine q35 \
			-cpu Nehalem \
			-m 4G \
			-smp 4 \
			-cdrom "$$ISO_FILE" \
			-boot d \
			-device virtio-vga,xres=1280,yres=720 \
			-display cocoa,zoom-to-fit=on \
			-usb -device usb-tablet

.PHONY: flash
flash: ## Write ISO disk to external device
	@ISO_FILE=$$(ls $(CURDIR)/output/*.iso 2>/dev/null | head -n 1); \
	if [ -z "$$ISO_FILE" ] || [ ! -f "$$ISO_FILE" ]; then \
		echo "Error: ISO not found in $(CURDIR)/output/. Run 'make start' first."; \
		exit 1; \
	fi; \
	EXT_DISKS=$$(diskutil list external); \
	if [ -z "$$EXT_DISKS" ]; then \
		echo "Error: No external disks detected! Please plug in a USB drive and try again."; \
		exit 1; \
	fi; \
	echo "$$EXT_DISKS"; \
	echo "========================================"; \
	printf "Enter the disk identifier (e.g., disk2): "; \
	read TARGET_DISK; \
	if [ -z "$$TARGET_DISK" ]; then echo "Aborted."; exit 1; fi; \
	echo ""; \
	echo "⚠️  WARNING: This will PERMANENTLY ERASE all data on /dev/$$TARGET_DISK!"; \
	printf "Are you sure you want to continue? [y/N]: "; \
	read CONFIRM; \
	if [ "$$CONFIRM" != "y" ] && [ "$$CONFIRM" != "Y" ]; then echo "Aborted."; exit 1; fi; \
	echo "Unmounting disk..."; \
	diskutil unmountDisk /dev/$$TARGET_DISK; \
	echo "Flashing ISO... (This may take a few minutes)"; \
	sudo dd if="$$ISO_FILE" of=/dev/r$$TARGET_DISK bs=1m status=progress; \
	diskutil eject /dev/$$TARGET_DISK; \
	echo "========================================"; \
	echo "✅ Success: Live USB is ready to boot!"; \
	echo "========================================"


.PHONY: clean
clean: ## Remove generated ISOs and the Docker builder image
	@rm -f $(CURDIR)/output/*.iso
	@docker rmi iso-builder:latest || true
