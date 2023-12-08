.386; Тип процессора. (только 32-разрядный MASM.)
.model flat, stdcall ; Модель памяти и вызова подпрограмм, объявление включаемых (заголовочных) файлов, макросов, макроопределений, также внешних определений
option casemap: none ; Отключение чувствительности к регистрам
includelib kernel32.lib ; Подключение библиотеки kernel32.lib


SetConsoleTextAttribute PROTO,
                        handle:             DWORD,
                        attribute:          WORD  ; SetConsoleTextAttribute функция для того, чтобы установить цвет для текста в консоли

GetStdHandle            PROTO,
                        handle:             DWORD ; GetStdHandle извлекает дескриптор для стандартного ввода данных, стандартного вывода или стандартной ошибки устройства

ReadConsoleA            PROTO,
                        handle:             DWORD,
                        bufferPtr:          DWORD,
                        maxBytes:           DWORD,
                        bytesReadPtr:       DWORD,
                        __reserved:         DWORD ; ReadConsoleA читает символьный ввод данных из консольного буфера ввода и удаляет их из буфера

WriteConsoleA           PROTO,
                        handle:             DWORD,
                        bufferPtr:          DWORD,
                        maxBytes:           DWORD,
                        bytesWrittenPtr:    DWORD,
                        __reserved:         DWORD ; WriteConsoleA процедура, выводящая символы на экран

ExitProcess             PROTO,
                        code:               DWORD ; ExitProcess заканчивает работу процесса и всех его потоков.


.data ; раздел объявления инициализированных данных
    String              BYTE                1024 DUP(?)     ; резервация байтов для входной строки
    ConsoleHandleInput  DWORD               0               ; дескриптор для консольного ввода. Используется в ReadConsoleA
    ConsoleHandleOutput DWORD               0               ; дескриптор для консольного вывода. Используется в WriteConsoleA
    STD_INPUT_HANDLE    DWORD               -10             ; Код дескриптора по умолчанию для консольного ввода.        
    STD_OUTPUT_HANDLE   DWORD               -11             ; Код дескриптора по умолчанию для консольного вывода.        
    MaxInputBytes       DWORD               1024            ; Максимальная длина строки (байты)
    BytesWritten        DWORD               ?               ; Байты написанного слова
    BytesRead           DWORD               ?               ; Байты прочитанного слова
    CurrentColor        WORD                02h             ; Текущий цвет для вывода текста в консоль


.code                                              ; Раздел кода 
    main PROC                                      ; Основная функция(процедура,инструкция) PROC для последующего выполнения

       push STD_INPUT_HANDLE                       ; дескриптор для консольного ввода
       call GetStdHandle
       mov ConsoleHandleInput, eax

       push STD_OUTPUT_HANDLE                      ; дескриптор для консольного вывода
       call GetStdHandle
       mov ConsoleHandleOutput, eax

       push 0                                      ; Отправляет в стек значение 00000000
       push OFFSET BytesRead                       ; Помещение  в стек относительного адреса переменной BytesRead
       push MaxInputBytes                          ; Помещение  в стек MaxInputBytes
       push OFFSET String                          ; Помещение  в стек относительного адреса переменной String
       push ConsoleHandleInput                     ; Помещение  в стек дескриптора ConsoleHandleInput для считывания с клавиатуры
       call ReadConsoleA                           ; Считывание строки

       push 0                                      ; Отправляет в стек значение 00000000
       push OFFSET BytesRead                       ; Помещение  в стек относительного адреса переменной BytesRead
       push BytesRead                              ; Помещение  в стек BytesRead
       push OFFSET String                          ; Помещение  в стек относительного адреса переменной String
       push ConsoleHandleOutput                    ; Помещение  в стек дескриптора WriteConsoleA для вывода строки в консоль
       call WriteConsoleA                          ; Вывод строки

       $Loop:                                      ; Печать строки в цикле с изменением цвета
            cmp CurrentColor, 15                   ; Сравнение переменной Current color c 15
       jge $Exit                                   ; Выход, если CurrentColor >= 15
            
            push CurrentColor                      ; Установка текущего цвета
            push ConsoleHandleOutput               ; Описано выше
            call SetConsoleTextAttribute           ; Изменение цвета в консоли

            push 0                                 ; Отправляет в стек значение 00000000
            push OFFSET BytesRead                  ; Помещение  в стек относительного адреса переменной BytesRead
            push BytesRead                         ; Помещение  в стек BytesRead
            push OFFSET String                     ; Помещение  в стек относительного адреса переменной String
            push ConsoleHandleOutput               ; Помещение  в стек дескриптора WriteConsoleA для вывода строки в консоль
            call WriteConsoleA                     ; Вывод в консоль строки с измененным цветом
            inc CurrentColor                       ; увеличение переменной на единицу для изменения цвета
            
            jmp $Loop                              ; Переход на следующую итерацию цикла Loop
       $Exit:
            push 0                                 ; Отправляет в стек значение 00000000
            call ExitProcess                       ; Завершение программы
    main ENDP                                      ; Определяет конец процедуры
end main                                           ; Этой директивой завершается любая программа на ассемблере
