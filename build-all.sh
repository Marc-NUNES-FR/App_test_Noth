#!/bin/bash
set -euo pipefail

echo "🚀 Building all apps..."

for app_dir in apps/*/; do
  APP_NAME=$(basename "$app_dir")
  echo ""
  echo "=========================================="
  echo "🔨 Building $APP_NAME..."
  echo "=========================================="
  ./build.sh "$APP_NAME"
done

echo ""
echo "✅ All apps built successfully!"
echo "Files generated in target/ directory"
