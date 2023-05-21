#include "system.h"

void main() {
    // *(char *)0xB8000 = 'a';
    // *(char *)0xB8006 = 'a';
    unsigned char *temp;
    temp = memset((unsigned char *)0xB8000, 'a', 1);
    temp = memcpy((unsigned char *)0xB8006, (unsigned char *)0xB8000, 1);

    // memcpy((unsigned char *)0xB8000, (unsigned char *)0x8006, 1);

    for(;;);
}

unsigned char *memset(unsigned char *dest, int ch, int count) {
    for(int i = 0; i < count; i++)
        *(dest+i) = ch;

    return dest;
}

unsigned char *memcpy(unsigned char* dest, unsigned char* src, int count) {
    for(int i = 0; i < count; i++)
        *(dest+i) = *(src+i);
    return dest;
}
