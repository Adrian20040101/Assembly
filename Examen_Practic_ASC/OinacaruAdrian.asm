bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, fopen, fclose, fprintf, printf, scanf,fread      
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll    
import fopen msvcrt.dll
import printf msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll
import scanf msvcrt
import fread msvcrt


; our data is declared here (the variables needed by our program)
segment data use32 class=data  
file_name db "pruefung.txt", 0 
file_name_output db "output.txt", 0 
access_mode db "r", 0      
access_mode_write db "w", 0      
file_descriptor dd -1       
len equ 100                 
text times (len+1) db 0  
exists dd 0
sum dd 0  
format db "%d", 0
format_keine db "Keine Ziffer", 0

; our code starts here
segment code use32 class=code
    start:
         ;wir lesen die Data from file
         push dword access_mode
         push dword file_name
         call [fopen]
         add esp, 4*2
         
         mov [file_descriptor], eax
         
         cmp eax, 0
         je final
         
         push dword [file_descriptor]
         push dword len
         push dword 1
         push dword text
         call [fread]
         add esp, 4*4
         
         ;wir uberprufen ob es eine ziffer ist
         verificare:
         mov ecx, eax
         mov esi, 0
         jecxz gata
         repeta:
            mov al, [text+esi]
            cmp al, '0'
            jl not_number
             
            cmp al, '9'
            jg not_number
             
            sub al, 48
            add [sum], al
            mov [exists], dword 1
            inc esi
            
           not_number:
           inc esi
           loop repeta
   
         gata:
         
         formatare:
         mov eax, [sum]
         mov ebx, 0 ; in ebx speichern wir die Summe
            
            sum_of_digits:
                mov edx, 0 ; wir telien mit 10 und addieren den Rest
                mov ecx, 10
                div ecx
                add ebx, edx
                cmp eax, 0
                
               
                je sum_is_ready
            jmp sum_of_digits
         ;wir uberprufen ob es grosser al 10 ist
         sum_is_ready:
         mov [sum], ebx
         cmp ebx, 9
         jg formatare
         
         ;wir bereiten den file fur das schreiben vor
         push dword access_mode_write
         push dword file_name_output
         call [fopen]
         add esp, 4*2
         
         mov [file_descriptor], eax
         
         cmp eax, 0
         je final
         ;wir uberprufen ob keine ziffer gelesen wurden
         cmp dword [exists], 1
         je mai_departe
         push dword format_keine
         push dword [file_descriptor]
         call [fprintf]
         add esp, 4*2
         jmp final
         mai_departe:
         ;wir schreiben die fertige Summe
         push dword [sum]
         push dword format
         push dword [file_descriptor]
         call [fprintf]
         add esp, 4*3
         
         push dword [file_descriptor]
         call [fclose]
         add esp, 4
         
         
         
         final:
         
        ;der Algorithmus nimmt alle Charakteren von der gegebenen Datei und uberpruft ob sie Ziffern sind, falls das der Fall ist, werden sie zu eine Variabile sum addiert, dann wird diese uberpruft, ob man noch eine summe erhalten kann, und am ende schreibt es die fertige summe in die datei
        push    dword 0
        call    [exit]