FROM --platform=linux/amd64 debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    curl \
    gnupg \
    live-build \
    libarchive-tools \
    grub-efi-amd64-bin \
    mtools \
    dosfstools \ 
    syslinux-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build-env

COPY build-iso.sh .
COPY config ./config 

ENTRYPOINT ["./build-iso.sh"]
