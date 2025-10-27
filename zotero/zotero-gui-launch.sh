#!/usr/bin/env bash
set -euo pipefail

# --- config you may edit ---
USER_NAME="raven"
HOST_NAME="ac-nightfall"

ZOTERO_DIR="/home/raven/Zotero_linux-x86_64"
DISPLAY_NUM=":1"
RESOLUTION="1280x800x24"
VNC_PORT="5901"

VNC_PASSFILE="/home/raven/.vnc/passwd"
STATEFILE="/home/raven/.zotero-gui-session"
# --- end config ---

echo "[zotero-gui-start] checking for required binaries..."
need=(Xvfb x11vnc openbox xterm)
for bin in "${need[@]}"; do
    if ! command -v "$bin" >/dev/null 2>&1; then
        echo "ERROR: $bin not found in PATH."
        echo "Install deps on ${HOST_NAME}:"
        echo "  sudo apt update && sudo apt install -y xvfb x11vnc openbox xterm"
        exit 1
    fi
done

if [ ! -x "$ZOTERO_DIR/zotero" ]; then
    echo "ERROR: $ZOTERO_DIR/zotero not found or not executable."
    exit 1
fi

mkdir -p "$(dirname "$VNC_PASSFILE")"

echo "[zotero-gui-start] ensuring VNC password..."
if [ ! -f "$VNC_PASSFILE" ]; then
    echo "No VNC password found. You will be prompted to set one."
    x11vnc -storepasswd "$VNC_PASSFILE"
    chmod 600 "$VNC_PASSFILE"
else
    echo "Using existing password file at $VNC_PASSFILE"
fi

echo "[zotero-gui-start] starting Xvfb on $DISPLAY_NUM ($RESOLUTION)..."
Xvfb "$DISPLAY_NUM" -screen 0 "$RESOLUTION" &
XVFB_PID=$!
sleep 0.5
echo "  Xvfb PID: $XVFB_PID"

echo "[zotero-gui-start] starting openbox..."
DISPLAY="$DISPLAY_NUM" openbox &
OPENBOX_PID=$!
sleep 0.5
echo "  openbox PID: $OPENBOX_PID"

echo "[zotero-gui-start] starting xterm..."
DISPLAY="$DISPLAY_NUM" xterm &
XTERM_PID=$!
sleep 0.5
echo "  xterm PID: $XTERM_PID"

echo "[zotero-gui-start] starting x11vnc localhost:${VNC_PORT} ..."
# -bg backgrounds and writes logs to /tmp/x11vnc-zotero.log
x11vnc -display "$DISPLAY_NUM" \
    -localhost \
    -rfbport "$VNC_PORT" \
    -forever \
    -shared \
    -rfbauth "$VNC_PASSFILE" \
    -bg \
    -o /tmp/x11vnc-zotero.log

# We need the x11vnc PID for cleanup. Grab the newest x11vnc for this user.
X11VNC_PID=$(pgrep -u "$USER" x11vnc | tail -n1 || true)
echo "  x11vnc PID: ${X11VNC_PID:-unknown}"

echo "[zotero-gui-start] launching Zotero GUI..."
cd "$ZOTERO_DIR"
DISPLAY="$DISPLAY_NUM" MOZ_DISABLE_GPU_ACCELERATION=1 ./zotero &
ZOTERO_PID=$!
sleep 1
echo "  Zotero PID: $ZOTERO_PID"

echo "[zotero-gui-start] writing state to $STATEFILE ..."
cat > "$STATEFILE" <<EOF
XVFB_PID=$XVFB_PID
OPENBOX_PID=$OPENBOX_PID
XTERM_PID=$XTERM_PID
X11VNC_PID=$X11VNC_PID
ZOTERO_PID=$ZOTERO_PID
DISPLAY_NUM=$DISPLAY_NUM
VNC_PORT=$VNC_PORT
EOF
chmod 600 "$STATEFILE"

cat <<EOF

[zotero-gui-start] Zotero GUI session is live.

CONNECT FROM YOUR MAC:

1. In a new terminal on your Mac:
   ssh -L ${VNC_PORT}:localhost:${VNC_PORT} ${USER_NAME}@${HOST_NAME}

   Leave that SSH session running (this is the tunnel).

2. On your Mac, Finder -> Go -> Connect to Server... (⌘K)
   Server address:  vnc://localhost:${VNC_PORT}

3. When prompted, enter the VNC password you set for x11vnc.

You should now see:
  - an Openbox desktop
  - an xterm window
  - a live Zotero window

In Zotero:
  Edit -> Preferences -> Sync
    - Log in to Zotero
    - Enable automatic sync
    - (Optionally) enable file sync / attachments
  Let sync finish.
  Quit Zotero (File -> Quit) to persist credentials.

When you're done, SSH back into ${HOST_NAME} and run:
  ~/dotfiles/zotero/zotero-gui-stop.sh

EOF

