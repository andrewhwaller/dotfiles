#!/usr/bin/env bash
set -euo pipefail

# --- config you may edit ---
STATEFILE="/home/raven/.zotero-gui-session"
# --- end config ---

echo "[zotero-gui-status] Active processes:"
ps aux | egrep 'Xvfb|x11vnc|openbox|xterm|zotero' | grep -v egrep || true

echo
if [ -f "$STATEFILE" ]; then
    echo "[zotero-gui-status] Current session state ($STATEFILE):"
    cat "$STATEFILE"
else
    echo "[zotero-gui-status] No session state file found."
fi

