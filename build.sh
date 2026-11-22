#!/bin/bash
set -euo pipefail

APP_NAME=${1:-test_app}
VERSION=${2:-1}

export PATH="$PATH:/home/appuser/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/bin"

echo "🔨 Building $APP_NAME..."

# Build
cargo build --release -p "$APP_NAME" --target thumbv7em-none-eabi

# Générer .bin
mkdir -p target
llvm-objcopy -O binary --set-section-flags .data=alloc,load,contents \
  "target/thumbv7em-none-eabi/release/$APP_NAME" \
  "target/${APP_NAME}.bin"

# Générer .wp2app (si resvg et wp2apps sont disponibles)
if command -v resvg &>/dev/null && command -v wp2apps &>/dev/null; then
  ICON_SVG="apps/$APP_NAME/icon.svg"
  if [ -f "$ICON_SVG" ]; then
    echo "🎨 Generating icon..."
    resvg -w 96 -h 96 "$ICON_SVG" target/icon.png
    wp2apps icon target/icon.png target/icon.wp2icon
    wp2apps pack "target/${APP_NAME}.bin" \
      --elf "target/thumbv7em-none-eabi/release/$APP_NAME" \
      --name "$APP_NAME" \
      --version "$VERSION" \
      --icon target/icon.wp2icon \
      --output "target/${APP_NAME}.wp2app"
    echo "✅ .wp2app generated: target/${APP_NAME}.wp2app"
  else
    echo "⚠️  No icon.svg found for $APP_NAME"
  fi
else
  echo "⚠️  resvg or wp2apps not found, skipping .wp2app generation"
fi

echo "✅ Build complete: target/${APP_NAME}.bin"
