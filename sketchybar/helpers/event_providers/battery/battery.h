#include <IOKit/IOKitLib.h>
#include <IOKit/ps/IOPowerSources.h>
#include <IOKit/ps/IOPSKeys.h>
#include <stdbool.h>
#include <stdio.h>

struct battery {
    int percentage;
    bool is_charging;
};

static inline void battery_init(struct battery* battery) {
    battery->percentage = -1;
    battery->is_charging = false;
}

static inline void battery_update(struct battery* battery) {
    CFTypeRef power_sources = IOPSCopyPowerSourcesInfo();
    CFArrayRef sources = IOPSCopyPowerSourcesList(power_sources);

    if (CFArrayGetCount(sources) == 0) {
        printf("Error: Could not retrieve power source information.\n");
        CFRelease(sources);
        CFRelease(power_sources);
        return;
    }

    CFDictionaryRef source = IOPSGetPowerSourceDescription(power_sources, CFArrayGetValueAtIndex(sources, 0));

    if (!source) {
        printf("Error: Could not retrieve power source description.\n");
        CFRelease(sources);
        CFRelease(power_sources);
        return;
    }

    CFNumberRef percentage_ref = CFDictionaryGetValue(source, CFSTR(kIOPSCurrentCapacityKey));
    CFStringRef charging_ref = CFDictionaryGetValue(source, CFSTR(kIOPSPowerSourceStateKey));

    if (percentage_ref) {
        CFNumberGetValue(percentage_ref, kCFNumberIntType, &battery->percentage);
    }

    if (charging_ref) {
        battery->is_charging = CFEqual(charging_ref, CFSTR(kIOPSACPowerValue));
    }

    CFRelease(sources);
    CFRelease(power_sources);
}
