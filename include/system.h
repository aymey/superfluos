#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* main */
unsigned char *memset(unsigned char *dest, unsigned char val, int count); // TODO: include stddef.h for size_t type
unsigned short *memsetw(unsigned short *dest, unsigned short val, int count);
unsigned char *memcpy(unsigned char *dest, const unsigned char *src, int count); // TODO: should i use void*?
int strlen(const char *str);
unsigned char inportb(unsigned short _port);
void outportb(unsigned short _port, unsigned char _data); // http://www.osdever.net/FreeVGA/vga/crtcreg.htm

/* screen */
void scroll(void);
void move_cursor(void);
void clear_screen(void);
void putc(const unsigned char c);
void puts(const unsigned char *text);
void set_text_colour(const unsigned char forecolour, const unsigned char backcolour);

/* GDT */
void gdt_flush(void);
void gdt_set_gate(int num, unsigned long base, unsigned long limit, unsigned char access, unsigned char gran);
void gdt_install(void);

/* IDT */
void idt_load(void);
void idt_set_gate(unsigned char num, unsigned long base, unsigned short sel, unsigned char flags);
void idt_install(void);

/* ISR */
void isr_install(void);
// Stack after an ISR
typedef struct {
    unsigned int gs, fs, es, ds;
    unsigned int edi, esi, ebp, esp, ebx, edx, ecx, eax; // pushed by 'pusha'
    unsigned int int_no, err_code; // for 'push byte' and error codes
    unsigned int eip, cs, eflags, useresp, ss; // automatically pushed by processor
} regs;
void fault_handler(regs *r);

#endif // __SYSTEM_H_
