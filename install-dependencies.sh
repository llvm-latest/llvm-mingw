#!/bin/sh

# Install Essential Tools
sudo apt-get update
apt-get install -y \
    wget curl software-properties-common \
    git git-lfs \
    build-essential binutils clang lld llvm gcc g++ make cmake ninja-build \
    python3 python3-pip \
    zip unzip gettext autopoint less \
    nasm
apt-get clean -y
