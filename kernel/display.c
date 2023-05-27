#include "system.h"

#define SCREEN_WIDTH 80
#define SCREEN_HEIGHT 25
#define VIDEO_MEMORY 0xB8000

unsigned short *text_ptr = (unsigned short *)VIDEO_MEMORY;
int attribute = 0x0F;
int csr_x = 0, csr_y = 0;

void scroll(void) {
    unsigned int chunk, blank = 0x20 | (attribute << 8);

    if(csr_y >= SCREEN_HEIGHT) {
        chunk = csr_y - SCREEN_HEIGHT + 1;
        memcpy((unsigned char *)text_ptr, (unsigned char *)text_ptr + chunk * SCREEN_WIDTH, (SCREEN_HEIGHT - chunk) * SCREEN_WIDTH); //TODO: x2?

        memsetw(text_ptr + (SCREEN_HEIGHT - chunk) * SCREEN_WIDTH, blank, SCREEN_WIDTH);
        csr_y = SCREEN_HEIGHT - 1;
    }
}

void move_cursor(void) {
    // index = (y_value * width_of_screen) + x_value
    unsigned int index = (csr_y * SCREEN_WIDTH) + csr_x;

    // CRT control registers
    outportb(0x3D4, 14);
    outportb(0x3D5, index >> 8);
    outportb(0x3D4, 15);
    outportb(0x3D5, index);
}

void clear_screen(void) {
    unsigned int blank = 0x20 | (attribute << 8);

    for(int i = 0; i < SCREEN_HEIGHT; i++)
        memsetw(text_ptr + (SCREEN_WIDTH * i), blank, SCREEN_WIDTH);

    csr_x = 0;
    csr_y = 0;
    move_cursor();
}

void putc(const unsigned char c) {
    const int attrib = attribute << 8;

    switch(c) {
        case 0x08: // backspace
            if(csr_x)
                csr_x++;
            break;
        case 0x09: // tab
            csr_x = (csr_x + 8) & ~(8 - 1); // TODO: what is the significance of flipped 7 instead of writing 0b000? wtf is this magic number that brans kernel development tutorial uses?
            break;
        case '\r': // Carriage return
            csr_x = 0;
            break;
        case '\n': // newline
            csr_x = 0;
            csr_y++;
            break;
        default:
            break;
    }

    if(c >= ' ')
        *(text_ptr + (csr_y * SCREEN_HEIGHT + csr_x++)) = c | attrib;

    if(csr_x >= SCREEN_WIDTH) {
        csr_x = 0;
        csr_y++;
    }

    scroll();
    move_cursor();
}

void puts(const unsigned char *text) {
    for(int i = 0; i < strlen((const char *)text); i++)
        putc(text[i]);
}

void set_text_colour(const unsigned char foreground, const unsigned char background) {
    attribute = (background << 8) | (foreground & 0x0F);
}
