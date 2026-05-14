#!/bin/sh
set -eu

ARCHIVE_URL="${RADFORGE_ARCHIVE_URL:-https://github.com/tangthiendat/radforge/archive/refs/heads/main.tar.gz}"
TMPDIR="$(mktemp -d 2>/dev/null || mktemp -d -t radforge)"

cleanup() {
    rm -rf "$TMPDIR"
}

trap cleanup EXIT INT TERM

curl -fsSL "$ARCHIVE_URL" | tar -xz -C "$TMPDIR"
sh "$TMPDIR/radforge-main/scripts/uninstall.sh" "$@"
