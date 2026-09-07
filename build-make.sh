#!/bin/sh
#
# Copyright (c) 2018 Martin Storsjo
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

set -e

. ./logging.sh

unset HOST

while [ $# -gt 0 ]; do
    case "$1" in
    --host=*)
        HOST="${1#*=}"
        ;;
    *)
        PREFIX="$1"
        ;;
    esac
    shift
done
if [ -z "$PREFIX" ]; then
    echo $0 [--host=triple] dest
    exit 1
fi

mkdir -p "$PREFIX"
PREFIX="$(cd "$PREFIX" && pwd)"

: ${CORES:=$(nproc 2>/dev/null)}
: ${CORES:=$(sysctl -n hw.ncpu 2>/dev/null)}
: ${CORES:=4}

if [ ! -d make ]; then
    git clone --depth 1 https://github.com/mirror/make.git
fi

cd make

if [ -n "$HOST" ]; then
    CONFIGFLAGS="$CONFIGFLAGS --host=$HOST"
    CROSS_NAME=-$HOST
fi

[ -z "$CLEAN" ] || rm -rf build$CROSS_NAME
mkdir -p build$CROSS_NAME
cd build$CROSS_NAME
../configure --prefix="$PREFIX" $CONFIGFLAGS --program-prefix=mingw32- --enable-job-server LDFLAGS="-Wl,-s"
make -j$CORES
make install-binPROGRAMS
mkdir -p "$PREFIX/share/make"
install -m644 ../COPYING "$PREFIX/share/make/COPYING.txt"
