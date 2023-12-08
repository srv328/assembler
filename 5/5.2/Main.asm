.386
.model flat,stdcall
includelib kernel32.lib

GENERIC_READ EQU 80000000h
DO_NOT_SHARE EQU 0
NULL EQU 0
OPEN_EXISTING EQU 3
FILE_ATTRIBUTE_NORMAL EQU 80h
STD_OUTPUT_HANDLE EQU -11
GENERIC_WRITE EQU 40000000h
FILE_END EQU 2
CreateFile EQU <CreateFileA>
WriteConsole EQU <WriteConsoleA>
HANDLE TEXTEQU <DWORD>

CreateFile		PROTO,
				lpFilename: PTR BYTE,
				dwDesiredAccess: DWORD,
				dwShareMode: DWORD,
				lpSecurityAttributes: DWORD,
				dwCreationDisposition: DWORD,
				dwFlagsAndAttributes: DWORD,
				hTemplateFile: DWORD

ReadFile		PROTO,
				hFile: HANDLE,
				lpBuffer: PTR BYTE,
				nNumberOfBytesToRead: DWORD,
				lpNumberOfBytesRead: PTR DWORD,
				lpOverlapped: PTR DWORD

WriteConsole	PROTO, 
				hConsoleOutput: HANDLE,
				lpBuffer: PTR BYTE,
				nNumberOfCharsToWrite: DWORD,
				lpNumberOfCharsWritten: PTR DWORD,
				lpReserved: DWORD

GetStdHandle    PROTO,
				nStdHandle:HANDLE

WriteFile		PROTO,
				hFile: HANDLE,
				lpBuffer: PTR BYTE,
				nNumberOfBytesToWrite: DWORD,
				lpNumberOfBytesWritten: PTR DWORD,
				lpOverlapped: PTR DWORD

SetFilePointer  PROTO,
				hFile: HANDLE,
				lDistanceToMove: SDWORD,
				lpDistanceToMoveHigh: PTR SDWORD,
				dwMoveMethod: DWORD

CloseHandle		PROTO,
				hObject:DWORD

.data
buffer BYTE 100 DUP(?)
bAffer BYTE 100 DUP("new_string ")
bufSize = 11
filename BYTE "output.txt",0
fileHandle DWORD ?
byteCount DWORD ?

.code
ReadProc PROC
INVOKE CreateFile, ADDR filename, GENERIC_READ, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
mov fileHandle,eax
INVOKE ReadFile, fileHandle, ADDR buffer, 100, ADDR byteCount, 0
INVOKE CloseHandle, fileHandle

INVOKE GetStdHandle, STD_OUTPUT_HANDLE
mov fileHandle, eax
INVOKE WriteConsole, fileHandle, ADDR buffer, 100, ADDR byteCount, 0

INVOKE CreateFile, ADDR filename, GENERIC_WRITE, DO_NOT_SHARE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
mov fileHandle,eax
INVOKE SetFilePointer, fileHandle, 0, 0, FILE_END
INVOKE WriteFile, fileHandle, ADDR bAffer, bufSize, ADDR byteCount, 0
INVOKE CloseHandle, fileHandle

ret
ReadProc ENDP
END ReadProc