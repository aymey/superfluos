typedef unsigned long long uint64_t;
typedef int bool;

#define true 1
#define false 0

#define PRINTF_STATE_NORMAL         0
#define PRINTF_STATE_LENGTH         1
#define PRINTF_STATE_LENGTH_SHORT   2
#define PRINTF_STATE_LENGTH_LONG    3
#define PRINTF_STATE_SPEC           4

#define PRINTF_LENGTH_DEFAULT       0
#define PRINTF_LENGTH_SHORT_SHORT   1
#define PRINTF_LENGTH_SHORT         2
#define PRINTF_LENGTH_LONG          3
#define PRINTF_LENGTH_LONG_LONG     4


void printk(char *string, int colour);
void kprintf(char *string, ...);
int *printk_fnumber(int *argp, int length, bool sign, int radix);
uint64_t __umoddi3(uint64_t dividend, uint64_t divisor);
uint64_t __udivdi3(uint64_t dividend, uint64_t divisor);

void printk(char *string, int colour) {
   char *memory = (char *) 0xB8000;

   while(*string) {
       *memory++ = *string++;
       *memory++ = colour;
   }
}

void test() {
   // kprintf("test, 123, %%, %d, %u", -11, 11);
   // kprintf("test, 123,");
   printk("a", 2);
   // char *string = "ss";
}

void kprintf(char *string, ...) {
   int *argp = (int *)&string;
   int state = PRINTF_STATE_NORMAL;
   int length = PRINTF_LENGTH_DEFAULT;
   int radix = 10;

   argp++;

   while(*string) {
       switch(state) {
           case PRINTF_STATE_NORMAL:
               switch(*string) {
                   case '%':
                       state = PRINTF_STATE_LENGTH;
                       break;
                   default:
                       printk(string, 1);
                       break;
               }
               break;
           case PRINTF_STATE_LENGTH:
               switch(*string) {
                   case 'h':
                       length = PRINTF_LENGTH_SHORT;
                       state = PRINTF_STATE_LENGTH_SHORT;
                       break;
                   case 'l':
                       length = PRINTF_LENGTH_LONG;
                       state = PRINTF_STATE_LENGTH_LONG;
                       break;
                   default:
                       goto PRINTF_STATE_SPEC_;
                       break;
               }
               break;
           case PRINTF_STATE_LENGTH_SHORT:
               switch(*string) {
                   case 'h':
                       length = PRINTF_LENGTH_SHORT_SHORT;
                       state = PRINTF_STATE_SPEC;
                       break;
                   default:
                       goto PRINTF_STATE_SPEC_;
                       break;
               }
               break;
           case PRINTF_STATE_LENGTH_LONG:
               switch(*string) {
                   case 'l':
                       length = PRINTF_LENGTH_LONG_LONG;
                       state = PRINTF_STATE_SPEC;
                   default:
                       goto PRINTF_STATE_SPEC_;
                       break;
               }
               break;
           case PRINTF_STATE_SPEC:
           PRINTF_STATE_SPEC_:
               switch(*string) {
                   case 'd':
                   case 'i':
                       radix = 10;
                       argp = printk_fnumber(argp, length, true, radix);
                       break;
                   case 'u':
                       radix = 10;
                       argp = printk_fnumber(argp, length, false, radix);
                       break;
                   case 'X':
                   case 'x':
                   case 'p':
                       radix = 16;
                       argp = printk_fnumber(argp, length, false, radix);
                       break;
                   case 'o':
                       radix = 8;
                       argp = printk_fnumber(argp, length, false, radix);
                       break;
                   case 'c':
                       printk((char *)argp, 1);
                       argp++;
                       break;
                   case 's':
                       printk(*(char **)argp, 1);
                       argp++;
                       break;
                   case '%':
                       printk("%", 1);
                       break;
                   default:
                       break;
               }
               state = PRINTF_STATE_NORMAL;
               length = PRINTF_LENGTH_DEFAULT;
               radix = 10;
               break;
       }
       string++;
   }
}

int *printk_fnumber(int *argp, int length, bool sign, int radix) {
    const char hex_chars[] = "0123456789abcdef";
    char buffer[32];
    unsigned long long number;
    int pos = 0;

    switch(length) {
        case PRINTF_LENGTH_SHORT_SHORT:
        case PRINTF_LENGTH_SHORT:
        case PRINTF_LENGTH_DEFAULT:
            if(sign) {
                int n = *argp;
                if(n < 0)
                    n = -n;
                number = n;
            } else
                number = *(unsigned int*)argp;
            argp++;
            break;
        case PRINTF_LENGTH_LONG:
            if(sign) {
                long int n = *(long int*)argp;
                if(n < 0)
                    n = -n;
                number = n;
            } else
                number = *(unsigned long int*)argp;
            argp += 2;
            break;
        case PRINTF_LENGTH_LONG_LONG:
            if(sign) {
                long long int n = *(long long int*)argp;
                if(n < 0)
                    n = -n;
                number = (unsigned long long)n;
            } else
                number = *(unsigned long long int*)argp;
            argp += 4;
            break;
    }

    do {
        int rem = number % radix;
        number /= radix;
        buffer[pos++] = hex_chars[rem];
    } while(number > 0);

    if(!sign)
        buffer[pos++] = '-';

    while(--pos >= 0)
        printk(&buffer[pos], 1);

    return argp;

}

uint64_t __umoddi3(uint64_t dividend, uint64_t divisor) {
    uint64_t quotient = 0;
    uint64_t remainder = 0;
    uint64_t bit = 1;

    // Align divisor and dividend
    while ((uint64_t)(divisor) > 0 && divisor < dividend) {
        divisor <<= 1;
        bit <<= 1;
    }

    while (bit > 0 && dividend >= divisor) {
        if (dividend >= divisor) {
            dividend -= divisor;
            quotient |= bit;
        }

        bit >>= 1;
        divisor >>= 1;
    }

    remainder = dividend;
    return remainder;
}

uint64_t __udivdi3(uint64_t dividend, uint64_t divisor) {
    uint64_t quotient = 0;
    uint64_t bit = 1;

//     // Align divisor and dividend
    while ((uint64_t)(divisor) > 0 && divisor < dividend) {
        divisor <<= 1;
        bit <<= 1;
    }

    while (bit > 0) {
        if (dividend >= divisor) {
            dividend -= divisor;
            quotient |= bit;
        }

        bit >>= 1;
        divisor >>= 1;
    }

    return quotient;
}
