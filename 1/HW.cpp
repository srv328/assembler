#include <stdio.h>
int main()
{
    short a = 'a';
    _asm{
        mov ax, 33
        add ax, 4
        mov bl, 2
        div bl
        mov ah, 0
        sub ax, 17
        mov bx, ax
        mov ax, 4
        mov cx, 6
        mul cx
        mov cx, ax
        mov ax, 250
        sub ax, cx
        div bx
        mov ah, 0
        mov bx, 2
        add bx, 4
        mul bl
        sub ax, 17
        mov a, ax
    }
    printf("%d", a);
    getchar();
}
