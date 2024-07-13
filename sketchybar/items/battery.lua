local battery_percent = sbar.add(
    "item",
    "widgets.battery",
    {
        position = "right",
        label = {
            string = "??%",
            font = {
                size = 12
            }
        }
    }
)

local function update_battery()
    sbar.exec(
        "system_profiler SPPowerDataType | grep 'State of Charge'",
        function(result)
            sbar.exec("echo 'system_profiler output: " .. result:gsub("'", "'\\''") .. "' >> /tmp/sketchybar_battery_debug.log")

            local percent = result:match("State of Charge %(%):%s*(%d+)")

            sbar.exec("echo 'Parsed percent: " .. tostring(percent) .. "' >> /tmp/sketchybar_battery_debug.log")

            percent = tonumber(percent)
            if not percent then
                sbar.exec("echo 'Error: Could not parse battery percentage' >> /tmp/sketchybar_battery_debug.log")
                return
            end

            local percent_string = string.format("%d%%", percent)
            sbar.exec("echo 'Setting percent: " .. percent_string .. "' >> /tmp/sketchybar_battery_debug.log")
            battery_percent:set({
                label = {
                    string = percent_string
                }
            })
        end
    )
end

sbar.add(
    "event",
    "battery_update",
    {
        update_freq = 60,
        action = update_battery
    }
)

-- Initial update
update_battery()

-- Debug: Print a message to confirm the script has loaded
sbar.exec("echo 'Battery widget script loaded' >> /tmp/sketchybar_battery_debug.log")
