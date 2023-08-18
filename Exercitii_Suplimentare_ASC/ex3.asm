bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fread, fclose, printf              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll
                          
segment data use32 class=data
    nume_fisier db "input2.txt", 0            
    mod_acces db "r", 0                 
    descriptor_fis dd -1                      
    nr_car_citite dd 0                     
    nr_cifre_pare dd 0                     
    len equ 100                             
    buffer resb len                         
    format db "Cifre pare gasite: %d", 0   

; our code starts here
segment code use32 class=code
    start:
        push dword mod_acces
        push dword nume_fisier
        call [fopen]
        add esp, 4*2
        
        cmp eax, 0
        je ende
        mov [descriptor_fis], eax
        loop:
            push dword [descriptor_fis]
            push dword len
            push dword 1
            push dword buffer
            call [fread]
            add esp, 4*4
            cmp eax, 0
            je cleanup
            mov [nr_car_citite], eax
            jmp loop
            
            cleanup:
            push dword [descriptor_fis]
            call [fclose]
            add esp, 4
        ende:
        mov esi, 0
        mov ebx, [nr_car_citite]
        
        start_loop:
            cmp ebx, 0
            je ende_start_loop
            cmp byte[buffer+esi], 48
            je increment_counter
            cmp byte[buffer+esi], 50
            je increment_counter
            cmp byte[buffer+esi], 52
            je increment_counter
            cmp byte[buffer+esi], 54
            je increment_counter
            cmp byte[buffer+esi], 56  ;ascii values
            je increment_counter
            jmp next_item
            increment_counter:
            inc dword [nr_cifre_pare]
            inc esi
            dec ebx
            jmp start_loop
            next_item:
            inc esi
            dec ebx
            jmp start_loop
        ende_start_loop:
        
        push dword [nr_cifre_pare]
        push dword format
        call [printf]
        add esp, 4*2
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
