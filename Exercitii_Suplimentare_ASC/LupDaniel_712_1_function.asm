bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global Functie       

; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    format db "%X ", 0
    sir_numere db 12, 100, 1, 5, 12, 6
    len equ $-sir_numere

; our code starts here
segment code use32 class=code public
        Functie:
        jecxz sfarsit
            repeta:
            mov eax, 0
            mov al, [sir_numere+esi]
            push dword eax
            push format
            call [printf]
            mov ecx, len
            mov ebx, esi
            sub ecx, ebx
            add esp, 4*2
            inc esi
        loop repeta
        sfarsit:
            ret
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
