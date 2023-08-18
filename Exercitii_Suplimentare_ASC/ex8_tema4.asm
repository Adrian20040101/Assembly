bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fread, fclose, fprintf              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fprintf msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll
                          
segment data use32 class=data
    nume_fisier db "input2.txt", 0            
    mod_acces db "w", 0                 
    descriptor_fis dd -1                      
    text db "Ana are 10 Mere!", 0                    
    len equ $-text                    
    text_de_scris resb len 
        

; our code starts here
segment code use32 class=code
    start:
        mov eax, 0
        mov ecx, len
        mov esi, 0
        jecxz final_repeta
        repeta:
            mov al, [text+esi]
            cmp al, 97
            jl litera_mare
            cmp al, 122
            jg nu_e_litera
            sub al, 32
            mov[text_de_scris+esi], al
            inc esi
            jmp end_if
            litera_mare:
            mov[text_de_scris+esi], al
            inc esi
            jmp end_if
            nu_e_litera:
            mov[text_de_scris+esi], al
            inc esi
            end_if:
        loop repeta
        final_repeta:
    
        push dword mod_acces
        push dword nume_fisier
        call [fopen]
        add esp, 4*2
        
        cmp eax, 0
        je final
        
        mov [descriptor_fis], eax
        push dword text_de_scris
        push dword [descriptor_fis]
        call [fprintf]
        add esp, 4*2
        
        push dword [descriptor_fis]
        call [fclose]
        add esp, 4
        final:
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
