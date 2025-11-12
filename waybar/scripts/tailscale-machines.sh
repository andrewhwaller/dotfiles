#!/usr/bin/env bash

# List of machines to monitor (add hostnames here)
MACHINES=(
    "ac-nightfall"
    "overseer"
)

# Check if tailscale is installed
if ! command -v tailscale &> /dev/null; then
    echo '{"text": "TS Machines: N/A", "tooltip": "Tailscale not installed", "class": "disconnected"}'
    exit 0
fi

# Get tailscale status
status=$(tailscale status --json 2>/dev/null)

if [ $? -ne 0 ]; then
    echo '{"text": "TS Machines: Error", "tooltip": "Tailscale error", "class": "error"}'
    exit 0
fi

# Check if we're connected
backend_state=$(echo "$status" | grep -o '"BackendState"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"\([^"]*\)".*/\1/' | head -1)

if [ "$backend_state" != "Running" ]; then
    echo '{"text": "TS Machines: Offline", "tooltip": "Tailscale not running", "class": "disconnected"}'
    exit 0
fi

# If no machines configured, show placeholder
if [ ${#MACHINES[@]} -eq 0 ]; then
    echo '{"text": "TS: No machines configured", "tooltip": "Edit waybar/scripts/tailscale-machines.sh to add machines", "class": "warning"}'
    exit 0
fi

# Check each machine's status and store results
declare -a results
tooltip="Tailscale Machine Status:\n"
all_online=true
any_not_found=false

for machine in "${MACHINES[@]}"; do
    # Extract the entire peer entry for this machine (up to 30 lines to capture Online field)
    machine_info=$(echo "$status" | grep -A 30 "\"HostName\"[[:space:]]*:[[:space:]]*\"$machine\"")

    if [ -z "$machine_info" ]; then
        # Machine not found in tailscale network
        results+=("○ ${machine}")
        tooltip="${tooltip}○ ${machine}: Not found\n"
        all_online=false
        any_not_found=true
    else
        # Check if Online field is true (indicates machine is connected to Tailscale)
        is_online=$(echo "$machine_info" | grep -o '"Online"[[:space:]]*:[[:space:]]*[^,}]*' | sed 's/.*:[[:space:]]*//' | head -1)

        if [ "$is_online" = "true" ]; then
            results+=("● ${machine}")
            tooltip="${tooltip}● ${machine}: Online\n"
        else
            results+=("○ ${machine}")
            tooltip="${tooltip}○ ${machine}: Offline\n"
            all_online=false
        fi
    fi
done

# Format output in columns with 2 rows each
# Build two rows simultaneously
row1=""
row2=""
for (( i=0; i<${#results[@]}; i+=2 )); do
    # Add first item of the pair to row 1
    if [ $i -gt 0 ]; then
        row1="${row1}  "  # Add spacing between columns
    fi
    row1="${row1}${results[$i]}"

    # Add second item of the pair to row 2 (if it exists)
    if [ $((i+1)) -lt ${#results[@]} ]; then
        if [ $i -gt 0 ]; then
            row2="${row2}  "  # Add spacing between columns
        fi
        row2="${row2}${results[$((i+1))]}"
    fi
done

# Combine rows with newline
if [ -n "$row2" ]; then
    text="${row1}\n${row2}"
else
    text="${row1}"
fi

# Set class based on machine status
# Red if any not found, yellow if any offline, green if all online
if $any_not_found; then
    class="disconnected"
elif $all_online; then
    class="connected"
else
    class="warning"
fi

echo "{\"text\": \"${text}\", \"tooltip\": \"${tooltip}\", \"class\": \"${class}\"}"
