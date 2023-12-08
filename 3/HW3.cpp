#include <iostream>
using namespace std;

int main()
{
    signed short x, a, result; 
    setlocale(LC_ALL, "Russian");
    cout << "Введите x: ";
    cin >> x;
    cout << "Введите a: ";
    cin >> a;
    _asm {
        mov cx, a;
        mov bx, x;
        cmp bx, cx;
        jg more; //переход на метку more, если x>a
        jle less_or_equal; //переход на метку less_or_equal, если x<=a
        jmp end_y1;//безусловный переход на метку end_y1 
    more:
        mov ax, bx;
        sub ax, cx;
        jmp end_y1;
    less_or_equal:
        mov ax, 5;
        jmp end_y1;
    end_y1:
        mov result, ax;
        cmp cx, bx;
        jg more_two; //переход на метку more_two, если a>x
        jle less_or_equal_two; //переход на метку less_or_equal_two, если a<=x
        jmp end_y2; //безусловный переход на метку end_y2 
    more_two:
        mov ax, a;
        jmp end_y2;
    less_or_equal_two:
        mov ax, a;
        mul bx;
        jmp end_y2;
    end_y2:
        mul result;
        mov result, ax;
    }
    cout << "Ответ: "<< result;
}

