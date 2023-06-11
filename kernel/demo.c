#include "system.h"

void approx_sleep(unsigned int seconds) {
    unsigned int clock_rate = 105000000; // similar clock rate 'emulation' of qemu (not really but oh well)

    for(int i = 0; i < seconds * clock_rate; i++)
        asm volatile("nop");
}

void liquid() {
    putc('o');
    approx_sleep(1);
}
