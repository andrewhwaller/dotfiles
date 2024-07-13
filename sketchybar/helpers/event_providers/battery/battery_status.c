#include "battery.h"
#include "../sketchybar.h"
#include <unistd.h>

int main(int argc, char** argv) {
    float update_freq;
    if (argc < 3 || (sscanf(argv[2], "%f", &update_freq) != 1)) {
        printf("Usage: %s \"<event-name>\" \"<event_freq>\"\n", argv[0]);
        exit(1);
    }

    struct battery battery;
    battery_init(&battery);

    // Setup the event in sketchybar
    char event_message[512];
    snprintf(event_message, 512, "--add event '%s'", argv[1]);
    sketchybar(event_message);

    char trigger_message[512];
    for (;;) {
        // Acquire new info
        battery_update(&battery);

        // Prepare the event message
        snprintf(trigger_message, 512,
                 "--trigger '%s' percentage=%d is_charging=%d",
                 argv[1],
                 battery.percentage,
                 battery.is_charging);

        // Trigger the event
        sketchybar(trigger_message);

        // Wait
        usleep(update_freq * 1000000);
    }

    return 0;
}
