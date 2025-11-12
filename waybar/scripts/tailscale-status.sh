#!/usr/bin/env bash

# Check if tailscale is installed
if ! command -v tailscale &> /dev/null; then
    echo '{"text": "● TS: Not Installed", "tooltip": "Tailscale not installed", "class": "disconnected"}'
    exit 0
fi

# Get tailscale status
status=$(tailscale status --json 2>/dev/null)

if [ $? -ne 0 ]; then
    echo '{"text": "● TS: Error", "tooltip": "Tailscale error", "class": "error"}'
    exit 0
fi

# Parse status using grep and sed
backend_state=$(echo "$status" | grep -o '"BackendState"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"\([^"]*\)".*/\1/' | head -1)
hostname=$(echo "$status" | grep -o '"HostName"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"\([^"]*\)".*/\1/' | head -1)

# Check for active SSH connections to Tailscale IPs (100.x.x.x range)
ssh_connections=""
ssh_count=0

# Get established SSH connections to 100.x.x.x IPs
ssh_ips=$(ss -tnp 2>/dev/null | grep -E "ESTAB.*:22" | grep -oE "100\.[0-9]+\.[0-9]+\.[0-9]+" | sort -u)

if [ -n "$ssh_ips" ]; then
    while IFS= read -r ip; do
        # Find the hostname for this IP from tailscale status
        ts_hostname=$(echo "$status" | grep -B 5 "\"$ip\"" | grep -o '"HostName"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"\([^"]*\)".*/\1/' | head -1)
        # Skip if it's the current machine (don't show self-connections)
        if [ -n "$ts_hostname" ] && [ "$ts_hostname" != "$hostname" ]; then
            if [ -z "$ssh_connections" ]; then
                ssh_connections="$ts_hostname"
            else
                ssh_connections="$ssh_connections, $ts_hostname"
            fi
            ssh_count=$((ssh_count + 1))
        fi
    done <<< "$ssh_ips"
fi

# Determine output based on state
case "$backend_state" in
    "Running")
        if [ $ssh_count -gt 0 ]; then
            text="● TS: ${hostname} → ${ssh_connections}"
            tooltip="Tailscale: Connected as ${hostname}\nSSH active to: ${ssh_connections}"
        else
            text="● TS: ${hostname}"
            tooltip="Tailscale: Connected as ${hostname}\nNo active SSH sessions"
        fi
        class="connected"
        ;;
    "Stopped"|"NoState")
        text="● TS: DOWN"
        tooltip="Tailscale: Disconnected"
        class="disconnected"
        ;;
    *)
        text="● TS: ${backend_state}"
        tooltip="Tailscale: ${backend_state}"
        class="warning"
        ;;
esac

echo "{\"text\": \"${text}\", \"tooltip\": \"${tooltip}\", \"class\": \"${class}\"}"
