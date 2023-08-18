
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
;Zwei Folgen (von Bytes) S1 und S2 gleicher Länge werden angegeben. Erstelle die Folge D, wobei jedes Element die Summe der entsprechenden Elemente aus S1 und S2 ist.    
s1 db 1, 3, 6, 2, 3, 7   
l equ $-s1  
s2 db 6, 3, 8, 1, 2, 5
d times l db 0  

; our code starts here
segment code use32 class=code
    start:
        mov ecx, l   
        mov esi, 0   
        jecxz sfarsit   
        repeta:
            mov al, [s1+esi]    
            mov bl, [s2+esi]   
            add al, bl
            mov [d+esi], al
            inc esi
            loop repeta  
        sfarsit:   
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
