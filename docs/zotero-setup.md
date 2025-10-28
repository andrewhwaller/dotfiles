````markdown
# Remote Zotero + Skim + `rfs` — New-Machine Setup
_Last updated: Oct 27, 2025_

This guide lets you recreate the exact workflow on **any** new pair of machines:

- a **remote Linux server** (headless) that runs Zotero and maintains a live `Zotero.bib`
- a **local Mac** that mounts remote project folders and views PDFs in Skim

No LaTeX compile details are included—this is only about Zotero sync, the Better BibTeX export, mounting, and viewing.

---

## Variables you’ll substitute

- `<remote-user>` — your username on the remote Linux server
- `<remote-host>` — the SSH host (IP or DNS) of that server
- `<remote-home>` — usually `/home/<remote-user>`

Examples below show both the variable and a concrete example the first time.

---

## Part A — Remote Linux server (one-time setup)

### A1) Install Zotero (user-local, no desktop environment required)

1) Copy the Zotero Linux tarball to the server and extract into your home:
```bash
cd ~
tar xvjf Zotero-<version>_linux-x86_64.tar.bz2
# Result: ~/Zotero_linux-x86_64/ (contains 'zotero', 'zotero-bin', etc.)
````

2. Install runtime libraries + virtual display tools (Ubuntu 24.04 family):

```bash
sudo apt update
sudo apt install -y \
  libgtk-3-0t64 \
  libdbus-glib-1-2 \
  libxt6t64 \
  libx11-xcb1 \
  libnss3 \
  libasound2t64 \
  libxrender1 \
  libxext6 \
  libxdamage1 \
  libxfixes3 \
  libxcomposite1 \
  libxi6 \
  libatk1.0-0t64 \
  libatk-bridge2.0-0t64 \
  libxrandr2 \
  libgbm1 \
  libpango-1.0-0 \
  libpangocairo-1.0-0 \
  libcairo2 \
  fonts-liberation \
  xvfb \
  x11vnc
```

### A2) First-time Zotero login via a temporary virtual display

*On the server:*

```bash
Xvfb :1 -screen 0 1280x800x24 &
x11vnc -display :1 -rfbport 5901 -localhost -nopw &
export DISPLAY=:1
export MOZ_DISABLE_GPU_ACCELERATION=1
~/Zotero_linux-x86_64/zotero &
```

*On the Mac (in another terminal):*

```bash
ssh -L 5901:localhost:5901 <remote-user>@<remote-host>
open vnc://localhost:5901
```

In the VNC’d Zotero window:

* Sign in to Zotero and enable Sync
* Install the **Better BibTeX** add-on (`.xpi`) via “Install from file…”

(You can `scp` the `.xpi` up first if needed, e.g. `scp ~/Downloads/zotero-better-bibtex.xpi <remote-user>@<remote-host>:~`.)

You can stop `x11vnc`/`Xvfb` after this; Zotero is now configured.

### A3) Better BibTeX auto-export to a portable path

Create a per-user TEXMF tree and point the auto-export there:

```bash
mkdir -p <remote-home>/texmf/bibtex/bib
# e.g., mkdir -p /home/<remote-user>/texmf/bibtex/bib
```

In Zotero (same VNC session):

* Right-click **My Library → Export Library…**
* Format: **Better BibTeX**
* Check: **Keep updated** / **Automatically update**
* File: `<remote-home>/texmf/bibtex/bib/Zotero.bib`

  * e.g., `/home/<remote-user>/texmf/bibtex/bib/Zotero.bib`

Zotero will keep that `Zotero.bib` current on the server automatically.

> Tip: Any time you need Zotero to run again headless, start `Xvfb :1` (if not running), set `DISPLAY=:1` and `MOZ_DISABLE_GPU_ACCELERATION=1`, then launch `~/Zotero_linux-x86_64/zotero &`.

---

## Part B — Local Mac setup

### B1) Install macFUSE + sshfs (macOS)

```bash
brew install --cask macfuse
brew tap gromgit/fuse
brew install gromgit/fuse/sshfs-mac
```

If macOS blocks the extension: System Settings → Privacy & Security → allow macFUSE, then rerun the sshfs install if needed.

### B2) Create standard dirs and add `~/bin` to PATH (fish)

```bash
mkdir -p ~/mnt
mkdir -p ~/bin
fish_add_path ~/bin   # persists for future fish sessions
```

### B3) Install helper scripts from dotfiles

The dotfiles repo includes utilities that streamline remote access and filesystem mounting:

```bash
# Symlink all scripts from dotfiles
ln -sf ~/dotfiles/scripts/rfs ~/bin/rfs
ln -sf ~/dotfiles/scripts/tailscale-ssh ~/bin/ts
chmod +x ~/dotfiles/scripts/rfs
chmod +x ~/dotfiles/scripts/tailscale-ssh
```

Quick check:

```bash
rfs list
ts --help  # or just run 'ts' to launch the interactive selector
```

#### `rfs` (Remote Filesystem) usage

The `rfs` script simplifies mounting, managing, and accessing remote directories via sshfs.

**Mount any remote directory:**

```bash
rfs mount <remote-user>@<remote-host>:/absolute/remote/path [local-name]
# example:
# rfs mount <remote-user>@<remote-host>:/home/<remote-user>/thesis thesis
# → available at: ~/mnt/thesis
```

**Open a mount in Finder:**

```bash
rfs open thesis
```

**List all active mounts:**

```bash
rfs list
```

**Unmount a directory:**

```bash
rfs unmount thesis
```

(If "resource busy," close Skim/Finder tabs using that path and retry.)

#### `tailscale-ssh` (Interactive Tailscale host selector)

The `tailscale-ssh` script (aliased as `ts`) provides an interactive fzf-powered menu to connect to any machine on your Tailscale network.

**Launch interactive host selector:**

```bash
ts
# or
tailscale-ssh
```

This will:
1. Show all online Tailscale hosts with their OS and network stats
2. Let you select a host using fzf (navigate with tab/shift-tab)
3. Optionally specify a different username
4. Automatically forward your nvim theme and tmux environment

**Features:**
- Auto-detects Tailscale binary (macOS or Linux)
- Displays human-readable network stats (tx/rx)
- Forwards `NVIM_THEME` from `~/.config/current_nvim_theme`
- Forwards `TMUX` environment when running inside tmux
- Styled terminal output with clear connection status

**Tip:** Use this when connecting to your remote server for Zotero management or mounting project directories with `rfs`.

### B4) Skim setup for smooth local viewing

Open any PDF from the mounted folder with Skim:

```bash
open -a Skim ~/mnt/thesis/main.pdf
```

Enable auto-reload (Skim → Preferences → General/Sync):

* **Check for file changes**
* **Reload automatically** (wording may vary)

Optional (recommended): add a **manual reload** shortcut for instant refresh without reopening:

* macOS → System Settings → Keyboard → Keyboard Shortcuts → **App Shortcuts**
* Add new:

  * **Application:** Skim
  * **Menu Title:** the exact label of Skim’s reload action (often **“Revert to Saved”** or **“Last Saved Version”**)
  * **Shortcut:** ⌘⌥R (or your choice)

You can also set via CLI (adjust the menu title to match your Skim):

```bash
defaults write net.sourceforge.skim-app.skim NSUserKeyEquivalents -dict-add "Revert to Saved" "@~r"
```

---

## Part C — Daily use

1. Mount a project directory:

```bash
rfs mount <remote-user>@<remote-host>:/home/<remote-user>/thesis thesis
```

2. View PDFs locally:

```bash
open -a Skim ~/mnt/thesis/main.pdf
```

Skim will usually auto-reload within ~1–2s when the PDF changes on the server. Use your custom shortcut (e.g. ⌘⌥R) to force an immediate reload without closing the PDF.

3. When finished:

```bash
rfs unmount thesis
```

---

## Quick checklist

* [ ] Server: Zotero extracted to `~/Zotero_linux-x86_64/`
* [ ] Server: runtime deps + `xvfb` + `x11vnc` installed
* [ ] Server: one-time Zotero sign-in via `Xvfb :1` + VNC
* [ ] Server: Better BibTeX auto-export → `<remote-home>/texmf/bibtex/bib/Zotero.bib`
* [ ] Mac: macFUSE + sshfs installed
* [ ] Mac: `~/mnt` + `~/bin` exist; `fish_add_path ~/bin` done
* [ ] Mac: `rfs` symlinked from dotfiles and executable
* [ ] Mac: Skim auto-reload enabled; optional “Revert” shortcut set

```

::contentReference[oaicite:0]{index=0}
```

