#!/bin/bash
set -e

# Update package index
sudo apt update

# Install necessary apt packages
sudo apt install -y \
    nano\
    zlib1g-dev\
    silversearcher-ag \
    beanstalkd \
    gdb \
    screen \
    patchelf \
    apt-transport-https \
    ca-certificates \
    clang-9 \
    libclang-9-dev \
    gcc-7 \
    g++-7 \
    sudo \
    curl \
    wget \
    build-essential \
    make \
    cmake \
    ninja-build \
    git \
    subversion \
    python3 \
    python3-dev \
    python3-pip \
    autoconf \
    automake \
    locales

# Generate and configure locale en_US.UTF-8
sudo locale-gen en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8

# Upgrade pip and install Python packages
sudo python3 -m pip install --upgrade pip
sudo python3 -m pip install greenstalk psutil

# Set clang-9 and llvm-9 as default versions using update-alternatives
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-9 10 \
  --slave /usr/bin/clang++ clang++ /usr/bin/clang++-9 \
  --slave /usr/bin/opt opt /usr/bin/opt-9

sudo update-alternatives --install /usr/lib/llvm llvm /usr/lib/llvm-9 20 \
  --slave /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-9 \
  --slave /usr/bin/llvm-link llvm-link /usr/bin/llvm-link-9


echo "[+] SieveFuzz preinstall step complete."
