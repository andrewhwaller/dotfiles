#!/usr/bin/env bash
set -euo pipefail

# --- config you may edit ---
STATEFILE="/home/raven/.zotero-gui-session"
# --- end config ---

if [ ! -f "$STATEFILE" ]; then
    echo "[zotero-gui-stop] No state file at $STATEFILE."
    echo "Nothing to stop (maybe already cleaned up or rebooted)."
    exit 0
fi

# Source the PIDs
# shellcheck disable=SC1090
source "$STATEFILE"

echo "[zotero-gui-stop] Stopping Zotero GUI session..."
echo "  Zotero PID    : ${ZOTERO_PID:-?}"
echo "  x11vnc PID    : ${X11VNC_PID:-?}"
echo "  xterm PID     : ${XTERM_PID:-?}"
echo "  openbox PID   : ${OPENBOX_PID:-?}"
echo "  Xvfb PID      : ${XVFB_PID:-?}"

# Kill in a safe-ish order: Zotero first, then x11vnc, then desktop pieces
for pid in ${ZOTERO_PID:-} ${X11VNC_PID:-} ${XTERM_PID:-} ${OPENBOX_PID:-} ${XVFB_PID:-}; do
    if [ -n "${pid:-}" ] && kill -0 "$pid" 2>/dev/null; then
        kill "$pid" || true
    fi
done

sleep 1

echo "[zotero-gui-stop] Checking for survivors..."
ps aux | egrep 'Xvfb|x11vnc|openbox|xterm|zotero' | grep -v egrep || true

rm -f "$STATEFILE"

echo "[zotero-gui-stop] Done. Virtual desktop torn down."

