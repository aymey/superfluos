#include <system.h>

void main(void) {
    init();
    unsigned char *test = "test";
    puts(test);

    for(;;);
    return;
}

unsigned char *memset(unsigned char *dest, unsigned char val, size_t count) {
    for(int i = 0; i < count; i++)
        *(dest+i) = val;

    return dest;
}

unsigned short *memsetw(unsigned short *dest, unsigned short val, size_t count) {
    for(int i = 0; i < count; i++)
        *(dest+i) = val;

    return dest;
}

unsigned char *memcpy(unsigned char* dest, const unsigned char* src, size_t count) {
    for(int i = 0; i < count; i++)
        *(dest+i) = *(src+i); // compiler already adds sizeof(*src) when doing pointer arithmatic addition, so just increasing by i is fine.

    return dest;
}

size_t strlen(const char *str) {
    size_t len = 0;
    while(*str++)
        len++;

    return len;
}

unsigned char inportb (unsigned short _port) {
    unsigned char rv;
    __asm__ __volatile__ ("inb %1, %0" : "=a" (rv) : "dN" (_port));
    return rv;
}

void outportb (unsigned short _port, unsigned char _data) {
    __asm__ __volatile__ ("outb %1, %0" : : "dN" (_port), "a" (_data));
}
