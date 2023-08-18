bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fprintf, fopen, fclose, printf, fread               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll
import printf msvcrt.dll
import fread msvcrt.dll

                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    file_name_input db "pruefung.txt", 0
    file_name_output db "output.txt", 0
    acces_mode_read db "r", 0
    acces_mode_write db "w", 0
    file_descriptor_input dd -1
    file_descriptor_output dd -1
    
    len equ 100
    buffer times (len + 1) db 0
    numar_caractere_citite dd 0
    format db "%s", 0

; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;open the file "input.txt" with fopen with mode "r"
        ;fopen(file_name_input, acces_mode_read)
        ;eax = file_descriptor_input
        push dword acces_mode_read
        push dword file_name_input
        call [fopen]
        add esp, 4 * 2
        
        ;check if the file was successfully opened
        
        cmp eax, 0
        je final
        
        mov [file_descriptor_input], eax
        
        ;open the file "output1.txt" with fopen with mode "w"
        ;fopen(file_name_output, acces_mode_write)
        ;eax = file_descriptor_output
        push dword acces_mode_write
        push dword file_name_output
        call [fopen]
        add esp, 4 * 2
        
        mov [file_descriptor_output], eax
        
        ;to read more than 100 characters we need a while loop
        
        bucla:
            ;read contents from file "input.txt" with fread
            ;fread(buffer, 1, len, file_descriptor_input)
            ;eax = number of characters read from file
            ;buffer = the content of the file
            push dword [file_descriptor_input]
            push dword len
            push dword 1
            push dword buffer
            call [fread]
            add esp, 4 * 4
            
            cmp eax, 0 ;no more characters in file, it means eax = 0
            je cleanup
            
            mov [numar_caractere_citite], eax ;save the number of characters read in numar_caractere_citite
            
            ;use printf to print text to screen
            ;printf(buffer, format)
            push dword format
            push dword buffer
            call [printf]
            add esp, 4 * 2
            
            ;use fprintf to write the buffer to the file "output1.txt"
            ;fprintf(file_descriptor_output, format, buffer)
            push dword buffer
            push dword format
            push dword [file_descriptor_output]
            call [fprintf]
            add esp, 4 * 3
            
            mov edi, 0
            
            clear_buffer:
                ;we need to clear the buffer
                ;to get rid of the text in buffer
                cmp edi, len
                je end_clear_buffer
                
                mov al, 0
                
                mov [buffer + edi], al
                inc edi
                
            jmp clear_buffer
            
            end_clear_buffer:
            
            jmp bucla
            
            
            
        cleanup:
        ; we use fclose to close the file "input.txt"
        ;fclose(file_descriptor_input)
        push dword [file_descriptor_input]
        call [fclose]
        add esp, 4
        
        ;we use fclose to close the file "output1.txt"
        ;fclose(file_descriptor_output)
        push dword [file_descriptor_output]
        call [fclose]
        add esp, 4
        
    final:
    
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program