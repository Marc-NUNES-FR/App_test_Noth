#!/bin/bash
set -euo pipefail

# Nom de l'application
APP_NAME="app_test_noth"
VERSION=1

# Ajouter llvm-objcopy au PATH
export PATH="$PATH:/home/appuser/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/bin"

# Compiler l'application
echo "Building $APP_NAME..."
cargo build --release -p "$APP_NAME" --target thumbv7em-none-eabi

# Créer le dossier target s'il n'existe pas
mkdir -p target

# Convertir l'ELF en binaire
ELF_PATH="target/thumbv7em-none-eabi/release/$APP_NAME"
BIN_PATH="target/$APP_NAME.bin"

if [ -f "$ELF_PATH" ]; then
    echo "Converting ELF to binary..."
    llvm-objcopy -O binary --set-section-flags .data=alloc,load,contents "$ELF_PATH" "$BIN_PATH"
else
    echo "Error: ELF file not found at $ELF_PATH"
    exit 1
fi

# Vérifier la taille
BIN_SIZE=$(stat -c%s "$BIN_PATH")
echo "Binary size: $BIN_SIZE bytes"

if [ "$BIN_SIZE" -gt 131072 ]; then
    echo "Error: Binary too large (max 128 KiB)"
    exit 1
fi

echo "Build successful!"
echo "Binary: $BIN_PATH"
echo "To create .wp2app, run: wp2apps pack $BIN_PATH --elf $ELF_PATH --name 'Test App' --version $VERSION --output target/$APP_NAME.wp2app"
