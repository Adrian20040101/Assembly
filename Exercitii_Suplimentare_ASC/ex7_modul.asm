bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start
; declare external functions needed by our program
extern exit, printf, scanf, fprintf, fopen, fclose          ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
import fprintf msvcrt.dll
import scanf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll 

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    
array: resb 16         ; Reserve 16 bytes for the array
fmt_in: db '%x', 0    ; Format string for reading a hexadecimal number from the keyboard
fmt_out: db '%d ', 0  ; Format string for printing a decimal number


; our code starts here
segment code use32 class=code
start:
    mov ecx, 16           ; Set ECX to the number of elements in the array
    mov ebx, array        ; Set EBX to the address of the first element in the array

read_loop:
    push dword fmt_in
    call [scanf]            ; Read a hexadecimal number from the keyboard and store it in the array
    add esp, 4
    mov eax, [ebx]        ; Load the current element from the array into EAX
    push dword eax
    push dword fmt_out
    call [printf]           ; Print EAX as a decimal number
    add esp, 4
    add ebx, 4            ; Move to the next element in the array
    loop read_loop        ; Repeat the loop until ECX is 0
    ret                   ; Return from the function
