#include <system.h>

void main() {

  *(char *)0xB8000 = 'a';
  // *(char *)0xB8006 = 'a';
  // const char *string_example = "123";
  // unsigned char *temp;
  // temp = memset((unsigned char *)0xB8000, 'a', 3);
  // // temp = memcpy((unsigned char *)0xB8006, (unsigned char *)0xB8000, 3);
  // temp = memset((unsigned char *)0xB8006, 94+strlen(string_example), 1);

  // memcpy((unsigned char *)0xB8000, (unsigned char *)0x8006, 1);

  for(;;);
  return;
}

unsigned char *memset(unsigned char *dest, unsigned char val, int count) {
  for(int i = 0; i < count; i++)
    *(dest+i) = val;

  return dest;
}

unsigned short *memsetw(unsigned short *dest, unsigned short val, int count) {
  for(int i = 0; i < count; i++)
    *(dest+i) = val;

  return dest;
}

unsigned char *memcpy(unsigned char* dest, const unsigned char* src, int count) {
  for(int i = 0; i < count; i++)
    *(dest+i) = *(src+i); // compiler already adds sizeof(*src) when doing pointer arithmatic addition, so just increasing by i is fine.

  return dest;
}

int strlen(const char *str) {
  int len = 0;
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
