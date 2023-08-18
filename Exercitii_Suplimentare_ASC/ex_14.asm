bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 2, 1, 3, 3, 4, 2, 6
    l1 equ $-a
    b db 4, 5, 7, 6, 2, 1
    l2 equ $-b
    r times l1 + l2 db 0

; our code starts here
segment code use32 class=code
    start:
        
        mov ecx, l2
        mov esi, 0
        jecxz sfarsit
        repeta_pentru_sirul_b: 
            mov ebx, ecx
            mov al, [b+ebx-1]
            mov [r+esi], al
            inc esi
        loop repeta_pentru_sirul_b
        mov ecx, l1
        mov esi, l2
        mov edx, 0
        repeta_pentru_sirul_a:
            mov al, [a+edx]
            cbw
            mov bl, 2
            mov ah, 0
            div bl
            cmp ah, 0
            jne sfarsit_repeta_pentru_sirul_a
            mul bl
            mov [r+esi], ax
            inc esi
            sfarsit_repeta_pentru_sirul_a:
            inc edx
        loop repeta_pentru_sirul_a
        sfarsit:
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
