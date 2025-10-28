# `zoteroctl` - Zotero Control Script

_Last updated: Oct 28, 2025_

## Overview

`zoteroctl` is a unified control script for managing Zotero on a headless Linux server. It provides an interactive menu and command-line interface for both:

1. **Headless service management** - systemd service that runs Zotero in the background
2. **GUI session management** - temporary VNC sessions for setup and troubleshooting

## Location

- **Script**: `~/dotfiles/scripts/zoteroctl`
- **Symlink**: `~/bin/zoteroctl` (added to PATH)
- **Dependencies**:
  - `~/dotfiles/zotero/zotero-gui-launch.sh`
  - `~/dotfiles/zotero/zotero-gui-status.sh`
  - `~/dotfiles/zotero/zotero-gui-stop.sh`

## Installation

```bash
# Create ~/bin if it doesn't exist
mkdir -p ~/bin

# Symlink the script from dotfiles
ln -sf ~/dotfiles/scripts/zoteroctl ~/bin/zoteroctl
chmod +x ~/dotfiles/scripts/zoteroctl

# Add ~/bin to PATH (fish shell)
fish_add_path ~/bin
```

## Usage Modes

### Interactive Mode

Launch the interactive menu:

```bash
zoteroctl
```

Provides a numbered menu with all available operations, organized into:
- **Headless Service** operations (1-9)
- **GUI Mode (VNC)** operations (g, s, x)
- **Help and Quit** (h, q)

### Command-Line Mode

Execute specific commands directly:

```bash
zoteroctl <command>
```

## Commands Reference

### Headless Service Commands

These manage the systemd user service (`zotero-headless.service`) that runs Zotero in the background.

| Command | Description |
|---------|-------------|
| `status` | Show systemd service status |
| `start` | Start the headless service |
| `stop` | Stop the headless service |
| `restart` | Restart the headless service |
| `logs` | View live service logs (follow mode) |
| `recent` | View last 50 lines of service logs |
| `ps`, `processes` | Check for running Zotero processes |
| `enable` | Enable service to start on boot (also runs `loginctl enable-linger`) |
| `disable` | Disable service autostart |

**Examples:**
```bash
zoteroctl status
zoteroctl restart
zoteroctl logs      # Press Ctrl+C to exit
zoteroctl enable
```

### GUI Session Commands

These manage temporary Xvfb + VNC sessions for accessing Zotero's graphical interface.

| Command | Description |
|---------|-------------|
| `gui`, `gui-launch` | Launch GUI session with Xvfb, x11vnc, openbox, and Zotero |
| `gui-status` | Check status of running GUI session |
| `gui-stop` | Stop GUI session and clean up all processes |

**Examples:**
```bash
# Start a GUI session
zoteroctl gui

# Check if it's running
zoteroctl gui-status

# Stop the session
zoteroctl gui-stop
```

**What `gui-launch` does:**
1. Starts Xvfb (virtual X server) on display :1
2. Starts openbox (lightweight window manager)
3. Starts xterm (terminal emulator)
4. Starts x11vnc on port 5901 with password protection
5. Launches Zotero GUI
6. Displays connection instructions for Mac/client
7. Saves PIDs to `~/.zotero-gui-session` for cleanup

**Connecting to GUI session:**
From your Mac:
```bash
# Terminal 1: SSH tunnel
ssh -L 5901:localhost:5901 <user>@<host>

# Then: Connect to VNC
# Finder → Go → Connect to Server (⌘K)
# vnc://localhost:5901
```

### Other Commands

| Command | Description |
|---------|-------------|
| `help`, `-h`, `--help` | Show help message with all commands |

## How It Works

### Architecture

```
zoteroctl (main script)
├── Headless Service Management
│   └── Controls systemd service: zotero-headless.service
│       └── Runs: ~/Zotero_linux-x86_64/zotero --headless
│
└── GUI Session Management
    ├── zotero-gui-launch.sh   (starts Xvfb + VNC + Zotero GUI)
    ├── zotero-gui-status.sh   (checks running processes)
    └── zotero-gui-stop.sh     (kills all GUI processes)
```

### Headless Service Details

The systemd service (`~/.config/systemd/user/zotero-headless.service`):

```ini
[Unit]
Description=Zotero Headless Background Service
After=network.target

[Service]
Type=simple
Environment="MOZ_HEADLESS=1"
ExecStart=/home/<user>/Zotero_linux-x86_64/zotero --headless
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
```

**Key features:**
- Runs on boot (when enabled with `loginctl enable-linger`)
- Auto-restarts on failure after 10 seconds
- Runs in headless mode (no GUI overhead)
- User service (doesn't require root)

### GUI Session Details

The GUI scripts use a state file (`~/.zotero-gui-session`) to track:
- Xvfb PID
- openbox PID
- xterm PID
- x11vnc PID
- Zotero PID
- Display number (:1)
- VNC port (5901)

This allows clean shutdown of all processes when running `gui-stop`.

## Script Internals

### Configuration Variables

```bash
SERVICE_NAME="zotero-headless.service"
DOTFILES_DIR="${HOME}/dotfiles"
GUI_LAUNCH="${DOTFILES_DIR}/zotero/zotero-gui-launch.sh"
GUI_STATUS="${DOTFILES_DIR}/zotero/zotero-gui-status.sh"
GUI_STOP="${DOTFILES_DIR}/zotero/zotero-gui-stop.sh"
```

### Helper Functions

- `check_gui_script()` - Validates GUI script exists and is executable
- `show_status()` - Wraps `systemctl --user status`
- `view_logs()` - Wraps `journalctl -f` for live logs
- `view_recent_logs()` - Wraps `journalctl -n 50` for recent logs
- `check_processes()` - Uses `ps aux | grep` to find Zotero processes
- `show_menu()` - Displays interactive menu
- `show_help()` - Displays command reference

### Interactive Menu Logic

The script detects whether arguments were provided:
- **No arguments** → Enter interactive loop with menu
- **With arguments** → Execute command and exit

The interactive menu:
1. Displays numbered options
2. Waits for user input
3. Executes corresponding function
4. Pauses for "Press Enter" (except for live logs and GUI launch)
5. Returns to menu (unless user quits)

## Common Use Cases

### Initial Setup

```bash
# 1. Install and configure Zotero GUI for first-time login
zoteroctl gui
# (Connect via VNC, sign in, install Better BibTeX)
zoteroctl gui-stop

# 2. Enable headless service for normal operation
zoteroctl enable
zoteroctl start
```

### Daily Operations

```bash
# Check if Zotero is running
zoteroctl status

# View what's happening
zoteroctl recent

# Restart if needed
zoteroctl restart
```

### Troubleshooting

```bash
# Check if processes are actually running
zoteroctl ps

# View live logs to debug issues
zoteroctl logs

# Access GUI to change settings
zoteroctl gui
# (Make changes via VNC)
zoteroctl gui-stop

# Restart headless service
zoteroctl restart
```

### Maintenance

```bash
# Temporarily stop Zotero
zoteroctl stop

# Do maintenance work...

# Start again
zoteroctl start

# Or disable autostart permanently
zoteroctl disable
```

## Error Handling

### GUI Script Not Found

If GUI scripts are missing or not executable:
```
GUI script not found or not executable: /home/user/dotfiles/zotero/zotero-gui-launch.sh
```

**Fix:**
```bash
chmod +x ~/dotfiles/zotero/*.sh
```

### Service Not Found

If systemd service doesn't exist:
```
Unit zotero-headless.service could not be found
```

**Fix:** Follow setup instructions in `docs/zotero-setup.md` section A3.

### Port Already in Use

If VNC port 5901 is already taken, GUI launch will fail.

**Fix:**
```bash
# Check what's using the port
ss -tulpn | grep 5901

# Stop existing GUI session
zoteroctl gui-stop

# Or kill the process manually
kill <pid>
```

## Tips

1. **Use `status` often** - It's the quickest way to verify Zotero is running
2. **GUI sessions are temporary** - Always stop them when done to free resources
3. **Logs are your friend** - Use `logs` or `recent` to debug issues
4. **Autostart is sticky** - Once enabled, Zotero will start on every boot until disabled
5. **Help is built-in** - Run `zoteroctl help` for a quick reference

## Related Files

- `docs/zotero-setup.md` - Complete setup guide for Zotero workflow
- `~/.config/systemd/user/zotero-headless.service` - Systemd service file
- `~/.zotero-gui-session` - GUI session state file (temporary)
- `~/.vnc/passwd` - VNC password file (created by gui-launch)
- `/tmp/x11vnc-zotero.log` - x11vnc log file

## Changelog

### 2025-10-28
- Initial creation with integrated GUI management
- Added help command
- Improved interactive menu organization
- Consolidated GUI script validation
- Added fish_add_path support for PATH setup
