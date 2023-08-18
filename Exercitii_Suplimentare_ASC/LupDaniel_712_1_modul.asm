bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf             ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
        
                  ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
extern Functie

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    format db "%X ", 0
    sir_numere db 12, 100, 1, 5, 12, 6
    len equ $-sir_numere
    message db "Die Zahlen von der Reihe in Basis 16: ", 0

; our code starts here
segment code use32 class=code
    start:
        push message
        call [printf]
        add esp, 4
        mov ecx, len
        mov esi, 0
        call Functie
        sfarsit:
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
