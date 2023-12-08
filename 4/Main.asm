.386; ��� ����������. (������ 32-��������� MASM.)
.model flat, stdcall ; ������ ������ � ������ �����������, ���������� ���������� (������������) ������, ��������, ����������������, ����� ������� �����������
option casemap: none ; ���������� ���������������� � ���������
includelib kernel32.lib ; ����������� ���������� kernel32.lib


SetConsoleTextAttribute PROTO,
                        handle:             DWORD,
                        attribute:          WORD  ; SetConsoleTextAttribute ������� ��� ����, ����� ���������� ���� ��� ������ � �������

GetStdHandle            PROTO,
                        handle:             DWORD ; GetStdHandle ��������� ���������� ��� ������������ ����� ������, ������������ ������ ��� ����������� ������ ����������

ReadConsoleA            PROTO,
                        handle:             DWORD,
                        bufferPtr:          DWORD,
                        maxBytes:           DWORD,
                        bytesReadPtr:       DWORD,
                        __reserved:         DWORD ; ReadConsoleA ������ ���������� ���� ������ �� ����������� ������ ����� � ������� �� �� ������

WriteConsoleA           PROTO,
                        handle:             DWORD,
                        bufferPtr:          DWORD,
                        maxBytes:           DWORD,
                        bytesWrittenPtr:    DWORD,
                        __reserved:         DWORD ; WriteConsoleA ���������, ��������� ������� �� �����

ExitProcess             PROTO,
                        code:               DWORD ; ExitProcess ����������� ������ �������� � ���� ��� �������.


.data ; ������ ���������� ������������������ ������
    String              BYTE                1024 DUP(?)     ; ���������� ������ ��� ������� ������
    ConsoleHandleInput  DWORD               0               ; ���������� ��� ����������� �����. ������������ � ReadConsoleA
    ConsoleHandleOutput DWORD               0               ; ���������� ��� ����������� ������. ������������ � WriteConsoleA
    STD_INPUT_HANDLE    DWORD               -10             ; ��� ����������� �� ��������� ��� ����������� �����.        
    STD_OUTPUT_HANDLE   DWORD               -11             ; ��� ����������� �� ��������� ��� ����������� ������.        
    MaxInputBytes       DWORD               1024            ; ������������ ����� ������ (�����)
    BytesWritten        DWORD               ?               ; ����� ����������� �����
    BytesRead           DWORD               ?               ; ����� ������������ �����
    CurrentColor        WORD                02h             ; ������� ���� ��� ������ ������ � �������


.code                                              ; ������ ���� 
    main PROC                                      ; �������� �������(���������,����������) PROC ��� ������������ ����������

       push STD_INPUT_HANDLE                       ; ���������� ��� ����������� �����
       call GetStdHandle
       mov ConsoleHandleInput, eax

       push STD_OUTPUT_HANDLE                      ; ���������� ��� ����������� ������
       call GetStdHandle
       mov ConsoleHandleOutput, eax

       push 0                                      ; ���������� � ���� �������� 00000000
       push OFFSET BytesRead                       ; ���������  � ���� �������������� ������ ���������� BytesRead
       push MaxInputBytes                          ; ���������  � ���� MaxInputBytes
       push OFFSET String                          ; ���������  � ���� �������������� ������ ���������� String
       push ConsoleHandleInput                     ; ���������  � ���� ����������� ConsoleHandleInput ��� ���������� � ����������
       call ReadConsoleA                           ; ���������� ������

       push 0                                      ; ���������� � ���� �������� 00000000
       push OFFSET BytesRead                       ; ���������  � ���� �������������� ������ ���������� BytesRead
       push BytesRead                              ; ���������  � ���� BytesRead
       push OFFSET String                          ; ���������  � ���� �������������� ������ ���������� String
       push ConsoleHandleOutput                    ; ���������  � ���� ����������� WriteConsoleA ��� ������ ������ � �������
       call WriteConsoleA                          ; ����� ������

       $Loop:                                      ; ������ ������ � ����� � ���������� �����
            cmp CurrentColor, 15                   ; ��������� ���������� Current color c 15
       jge $Exit                                   ; �����, ���� CurrentColor >= 15
            
            push CurrentColor                      ; ��������� �������� �����
            push ConsoleHandleOutput               ; ������� ����
            call SetConsoleTextAttribute           ; ��������� ����� � �������

            push 0                                 ; ���������� � ���� �������� 00000000
            push OFFSET BytesRead                  ; ���������  � ���� �������������� ������ ���������� BytesRead
            push BytesRead                         ; ���������  � ���� BytesRead
            push OFFSET String                     ; ���������  � ���� �������������� ������ ���������� String
            push ConsoleHandleOutput               ; ���������  � ���� ����������� WriteConsoleA ��� ������ ������ � �������
            call WriteConsoleA                     ; ����� � ������� ������ � ���������� ������
            inc CurrentColor                       ; ���������� ���������� �� ������� ��� ��������� �����
            
            jmp $Loop                              ; ������� �� ��������� �������� ����� Loop
       $Exit:
            push 0                                 ; ���������� � ���� �������� 00000000
            call ExitProcess                       ; ���������� ���������
    main ENDP                                      ; ���������� ����� ���������
end main                                           ; ���� ���������� ����������� ����� ��������� �� ����������
