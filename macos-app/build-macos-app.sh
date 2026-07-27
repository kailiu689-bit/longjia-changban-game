#!/bin/zsh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="$ROOT/龙甲·长坂战域.app"
CONTENTS="$APP/Contents"
RESOURCES="$CONTENTS/Resources"

rm -rf "$CONTENTS/_CodeSignature"
mkdir -p "$CONTENTS/MacOS" "$RESOURCES/assets/mech-three-kingdoms"
swiftc "$ROOT/macos-app/main.swift" -framework Cocoa -framework WebKit -o "$CONTENTS/MacOS/LongjiaChangban"
cp "$ROOT/macos-app/Info.plist" "$CONTENTS/Info.plist"
cp "$ROOT/macos-app/AppIcon.icns" "$RESOURCES/AppIcon.icns"
cp "$ROOT/mech-three-kingdoms.html" "$RESOURCES/mech-three-kingdoms.html"
rsync -a --delete "$ROOT/assets/mech-three-kingdoms/" "$RESOURCES/assets/mech-three-kingdoms/"
plutil -lint "$CONTENTS/Info.plist"
