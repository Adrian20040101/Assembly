bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
import scanf msvcrt.dll


segment data use32 class=data
    a dd 0
    message1 db "a = ", 0
    b dd 0
    message2 db "b = ", 0
    rezultat dq 0
    format1 db "%d", 0
    format2 db "Produkt ist: %d", 0 
; our code starts here
segment code use32 class=code
    start:
        push dword message1
        call [printf]
        add esp, 4*1
   
        push dword a
        push dword format1
        call [scanf]
        add esp, 4*2
        
        push dword message2
        call [printf]
        add esp, 4*1
        
        push dword b
        push dword format1
        call [scanf]
        add esp, 4*2
        
        
        mov eax, [a]            
        mov ecx, eax            
        mov ebx, [b]            
        mul ebx                
        mov [rezultat+0], eax   
        mov [rezultat+4], edx
  
        push dword [rezultat]
        push dword format2
        call [printf]
        add esp, 4*2
        
       
        push    dword 0         ; push the parameter for exit onto the stack
        call    [exit]          ; call exit to terminate the program
