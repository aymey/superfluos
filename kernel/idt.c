#include <system.h>

typedef struct {
  unsigned short base_low;
  unsigned short sel; // kernel segment
  unsigned short zero;
  unsigned char flags;
  unsigned short base_high;
} __attribute__((packed)) idt_entry;

typedef struct {
  unsigned short limit;
  unsigned int base;
} __attribute__((packed)) idt_ptr;


idt_entry idt[256];
idt_ptr idtp;

extern void idt_load(void);

void idt_set_gate(unsigned char num, unsigned long base, unsigned short sel, unsigned char flags) {
    idt[num].base_low = base & 0xFFFF;
    idt[num].base_high = (base >> 16) & 0xFFFF;

    idt[num].sel = sel;
    idt[num].zero = 0;
    idt[num].flags = flags;
}

void idt_install(void) {
  idtp.limit = (sizeof(idt_entry)*256)-1;
  idtp.base = &idt;

  memset(&idt, 0, sizeof(idt_entry)*256);

  idt_load();
}
