#include <stdio.h>
int main()
{
    unsigned short a = 'a';
    _asm {
        mov ax, 1111111111110100b
        xor ax, 1111111111111011b //ax = 0000000000001011b
        or ax,  1111111111110100b // ax = 1111111111111111b
        shr ax, 100b //ax = 0000000011111111b
        mov a, ax
    }
    printf("%d", a);
    getchar();
}
