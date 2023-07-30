#include <system.h>

// we already loaded a temporary gdt from the bootloader to switch to protected mode but this offers more flexabiltiy

typedef struct {
    unsigned short limit_low;
    unsigned short base_low;
    unsigned char base_high;
    unsigned char base_middle;
    unsigned char access;
    unsigned char granularity;
} __attribute__((packed)) gdt_entry;

typedef struct {
    unsigned short limit;
    unsigned int base;
} __attribute__((packed)) gdt_ptr;

gdt_entry gdt[3];
gdt_ptr gdtp;

extern void gdt_flush(void);

void gdt_set_gate(int num, unsigned long base, unsigned long limit, unsigned char access, unsigned char gran) {
    gdt[num].base_low = base & 0xFFFF;
    gdt[num].base_middle = (base >> 16) & 0xFF;
    gdt[num].base_high = (base >> 24) & 0xFF;

    gdt[num].limit_low = limit & 0xFFFF;
    gdt[num].granularity = (limit >> 16) & 0x0F;

    gdt[num].granularity |= (gran & 0xF0);
    gdt[num].access = access;
}

void gdt_install(void) {
    gdtp.limit = (sizeof(gdt_entry) * 3) - 1;
    gdtp.base = &gdt;

    /* NULL descriptor */
    gdt_set_gate(0, 0, 0, 0, 0);

    /* CODE segment */
    gdt_set_gate(1, 0, 0xFFFF, 0x9A, 0xCF); // 0xFFFFFFFF or 0xFFFF ?

    /* DATA segment */
    gdt_set_gate(2, 0, 0xFFFF, 0x92, 0xCF);

    gdt_flush();
}
