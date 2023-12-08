.386
.model flat,stdcall
option casemap: none
includelib kernel32.lib

DO_NOT_SHARE EQU 0
NULL EQU 0
FILE_ATTRIBUTE_NORMAL EQU 80h
GENERIC_WRITE EQU 40000000h
CreateFile EQU <CreateFileA>
WriteConsole EQU <WriteConsoleA>
HANDLE TEXTEQU <DWORD>
CREATE_ALWAYS EQU 2

CreateFile			PROTO, 
					lpFilename: PTR BYTE,
					dwDesiredAccess: DWORD,
					dwShareMode: DWORD,
					lpSecurityAttributes: DWORD,
					dwCreationDisposition: DWORD,
					dwFlagsAndAttributes: DWORD,
					hTemplateFile: DWORD

WriteFile			PROTO,
					hFile: HANDLE,
					lpBuffer: PTR BYTE,
					nNumberOfBytesToWrite: DWORD,
					lpNumberOfBytesWritten: PTR DWORD,
					lpOverlapped: PTR DWORD

CloseHandle			PROTO,
					hObject:DWORD

.data
buffer BYTE "это предложение было записано с помощью кода на ассемблере", 0dh, 0ah
bufSize = 60
filename BYTE "output.txt",0
fileHandle DWORD ?
bytesWritten DWORD ?

.code
WriteProc PROC
INVOKE CreateFile, ADDR filename, GENERIC_WRITE, DO_NOT_SHARE, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
mov fileHandle,eax
INVOKE WriteFile, fileHandle, ADDR buffer, bufSize, ADDR bytesWritten, 0
INVOKE CloseHandle, fileHandle
ret
WriteProc ENDP
END WriteProc