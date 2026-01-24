#!/bin/sh

# Install Essential Tools
apt-get update -qq
apt-get install -qqy \
    wget curl software-properties-common \
    git git-lfs \
    build-essential binutils binutils-dev \
    clang lld llvm gcc g++ make cmake ninja-build \
    python3 python3-pip \
    zip unzip xz-utils p7zip-full gettext autopoint less \
    nasm
apt-get clean -y
