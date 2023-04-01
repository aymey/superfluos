void printk(char *string, int colour) {
    char *memory = (char *) 0xB8000;

    while(*string != 0) {
        *memory++ = *string++;
        *memory++ = colour;
    }
}
