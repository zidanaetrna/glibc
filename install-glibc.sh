#!/bin/bash

set -e  # Berhenti jika ada error

GLIBC_VERSION="2.34"
GLIBC_DIR="/opt/glibc-${GLIBC_VERSION}"

# Cek apakah sudah terinstal
if [ -d "$GLIBC_DIR" ]; then
    echo "GLIBC $GLIBC_VERSION sudah terinstal di $GLIBC_DIR"
    exit 0
fi

# Update & install dependensi
echo "[*] Menginstal dependensi..."
apt update && apt install -y build-essential manpages-dev

# Download dan ekstrak GLIBC
echo "[*] Mengunduh GLIBC $GLIBC_VERSION..."
wget -q http://ftp.gnu.org/gnu/libc/glibc-${GLIBC_VERSION}.tar.gz
tar -xzf glibc-${GLIBC_VERSION}.tar.gz
cd glibc-${GLIBC_VERSION}

# Build & install
echo "[*] Mengkompilasi dan menginstal GLIBC..."
mkdir build && cd build
../configure --prefix="$GLIBC_DIR"
make -j$(nproc)
make install

# Cek instalasi
echo "[*] Verifikasi instalasi..."
"$GLIBC_DIR/lib/ld-${GLIBC_VERSION}.so" --version

echo "[✔] GLIBC $GLIBC_VERSION berhasil terinstal di $GLIBC_DIR"
