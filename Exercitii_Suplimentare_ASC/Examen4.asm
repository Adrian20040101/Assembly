bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll

segment data use32 class=data
    sir_pozitiv times 100 dd 0
    len_pos dd 0
    len_neg dd 0
    sir_negativ times 100 dd 0
    format db "%d", 0
    dformat db "%d ", 0
    p db "P: ", 0
    newline db 10, "N: ",  0
    sformat db "%s", 0
    n dd 0
    keine db "Keine Zahl", 0

segment code use32 class=code
    start:
    
        mov esi, 0
        mov edi, 0
        while:
            push dword n
            push dword format
            call [scanf]
            add esp, 4*2
            
            cmp [n], dword 0
            je end_while
            
            cmp [n], dword 0
            jg positiv
            negativ:
                mov eax, [n]
                mov [sir_negativ + esi], eax
                add esi, 4
                add [len_neg], dword 1
                jmp while
            
            positiv:
                mov eax, [n]
                mov [sir_pozitiv + edi], eax
                add edi, 4
                add [len_pos], dword 1
                
        
        jmp while
        end_while:
        
        
        push dword p
        ;push dword sformat
        call [printf]
        add esp, 4*2
        
        mov ecx, [len_pos]
        mov esi, 0
        
        jecxz end_loop_pos
        loop_pos:
            push ecx
            push dword [sir_pozitiv + esi]
            push dword dformat
            call [printf]
            add esp, 4*2
            pop ecx
                
            add esi, 4
        loop loop_pos
        end_loop_pos:
        
            cmp [len_neg], dword 0
            jne nor_pr_pos
            
            push dword keine
            push dword sformat
            call [printf]
            add esp, 4*2
            
            nor_pr_pos:
        
        ;write a newline
        push dword newline
        push dword sformat
        call [printf]
        add esp, 4*2
        
        mov ecx, [len_neg]
        mov edi, 0
        
        jecxz end_loop
        loop_neg:
            push ecx
            push dword [sir_negativ + edi]
            push dword dformat
            call [printf]
            add esp, 4*2
            pop ecx
            
            add edi, 4
        loop loop_neg
        
        end_loop:
            cmp [len_neg], dword 0
            jne no_pr_neg
            
                push dword keine
                push dword sformat
                call [printf]
                add esp, 4*2
            
            no_pr_neg:
            
        push    dword 0      
        call    [exit]