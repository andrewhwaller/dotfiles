#!/usr/bin/env bash
#
# Screenshot utility for Hyprland
#
# Usage: screenshot.sh [MODE] [--clipboard]
#   MODE: region, window, fullscreen, smart (default: smart)
#   --clipboard: Copy to clipboard instead of opening in editor

set -euo pipefail

# Configuration
SCREENSHOT_DIR="${SCREENSHOT_DIR:-$HOME/Pictures}"
COLLISION_THRESHOLD=20

# Parse arguments
MODE="${1:-smart}"
OUTPUT_MODE="${2:-}"

# Validate dependencies
check_dependencies() {
    local deps=(hyprctl jq slurp grim notify-send wl-copy)
    local missing=()

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done

    # Check for satty only if not using clipboard mode
    if [[ "$OUTPUT_MODE" != "--clipboard" ]] && ! command -v satty &> /dev/null; then
        missing+=("satty")
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        notify-send -u critical "Screenshot Error" "Missing dependencies: ${missing[*]}"
        echo "Error: Missing dependencies: ${missing[*]}" >&2
        exit 1
    fi
}

# Get geometry for smart mode collision detection
get_collision_geometry() {
    local x=$1 y=$2

    # Get all windows in the active workspace
    local windows
    windows=$(hyprctl -j clients | jq -r --argjson x "$x" --argjson y "$y" '
        map(select(.workspace.id == (input.monitors[] | select(.focused) | .activeWorkspace.id))) |
        map(select(
            $x >= .at[0] and
            $x <= (.at[0] + .size[0]) and
            $y >= .at[1] and
            $y <= (.at[1] + .size[1])
        )) |
        if length > 0 then
            .[0] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"
        else
            empty
        end
    ' < <(hyprctl -j monitors))

    if [[ -n "$windows" ]]; then
        echo "$windows"
        return 0
    fi

    # If no window found, check monitors
    local monitor
    monitor=$(hyprctl -j monitors | jq -r --argjson x "$x" --argjson y "$y" '
        map(select(
            $x >= .x and
            $x <= (.x + .width) and
            $y >= .y and
            $y <= (.y + .height)
        )) |
        if length > 0 then
            .[0] | "\(.x),\(.y) \(.width)x\(.height)"
        else
            empty
        end
    ')

    if [[ -n "$monitor" ]]; then
        echo "$monitor"
        return 0
    fi

    return 1
}

# Get region selection
get_region() {
    local mode=$1
    local geometry=""

    case "$mode" in
        region)
            geometry=$(slurp -d -b 1e1e2e99 -c cba6f7 -s 00000000 -w 2)
            ;;
        window)
            # Get list of windows on active workspace
            local windows
            windows=$(hyprctl -j clients | jq -r '
                map(select(.workspace.id == (input.monitors[] | select(.focused) | .activeWorkspace.id))) |
                map("\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1]) \(.title)")
            ' < <(hyprctl -j monitors))

            if [[ -z "$windows" ]]; then
                notify-send "Screenshot" "No windows found"
                return 1
            fi

            geometry=$(echo "$windows" | slurp -d -b 1e1e2e99 -c cba6f7 -s 00000000 -w 2)
            ;;
        fullscreen)
            # Get focused monitor geometry
            geometry=$(hyprctl -j monitors | jq -r '
                .[] | select(.focused) | "\(.x),\(.y) \(.width)x\(.height)"
            ')
            ;;
        smart)
            # Use slurp to get initial selection
            geometry=$(slurp -d -b 1e1e2e99 -c cba6f7 -s 00000000 -w 2) || return 1

            # Parse geometry to check if it's a small click
            local width height
            width=$(echo "$geometry" | awk '{print $2}' | cut -d'x' -f1)
            height=$(echo "$geometry" | awk '{print $2}' | cut -d'x' -f2)

            # If selection is very small, assume it's a click and find the window/monitor
            if [[ $width -lt $COLLISION_THRESHOLD && $height -lt $COLLISION_THRESHOLD ]]; then
                local x y
                x=$(echo "$geometry" | awk '{print $1}' | cut -d',' -f1)
                y=$(echo "$geometry" | awk '{print $1}' | cut -d',' -f2)

                local collision_geo
                if collision_geo=$(get_collision_geometry "$x" "$y"); then
                    geometry="$collision_geo"
                fi
            fi
            ;;
        *)
            echo "Unknown mode: $mode" >&2
            echo "Usage: $0 [region|window|fullscreen|smart] [--clipboard]" >&2
            return 1
            ;;
    esac

    echo "$geometry"
}

# Main screenshot logic
take_screenshot() {
    check_dependencies

    # Get the region to capture
    local geometry
    geometry=$(get_region "$MODE") || {
        notify-send "Screenshot" "Cancelled"
        exit 0
    }

    # Create temporary file
    local temp_file
    temp_file=$(mktemp -t screenshot-XXXXXX.png)

    # Take screenshot
    grim -g "$geometry" "$temp_file"

    # Handle output based on mode
    if [[ "$OUTPUT_MODE" == "--clipboard" ]]; then
        # Copy to clipboard with correct MIME type
        wl-copy --type image/png < "$temp_file"
        notify-send "Screenshot" "Copied to clipboard"
        rm "$temp_file"
    else
        # Create screenshot directory if it doesn't exist
        mkdir -p "$SCREENSHOT_DIR"

        # Generate filename with timestamp
        local timestamp
        timestamp=$(date +%Y%m%d-%H%M%S)
        local output_file="$SCREENSHOT_DIR/screenshot-$timestamp.png"

        # Open in satty for annotation
        satty --filename "$temp_file" --fullscreen --output-filename "$output_file" --early-exit --copy-command "wl-copy --type image/png"

        # Check if file was saved
        if [[ -f "$output_file" ]]; then
            notify-send "Screenshot" "Saved to $output_file"
        else
            notify-send "Screenshot" "Cancelled"
        fi

        # Clean up temp file
        rm -f "$temp_file"
    fi
}

# Run main function
take_screenshot
