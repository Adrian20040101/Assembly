bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start
global maxim
global a
global format

; declare external functions needed by our program
;extern Det_Max_Func
extern exit, printf, gets, fprintf, fopen, fclose          ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
import fprintf msvcrt.dll
import gets msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll 

; our data is declared here (the variables needed by our program)
segment data use32 class=data
;Lesen Sie eine Zeichenkette mit vorzeichenlosen Zahlen zur Basis 10 von der Tastatur. Ermitteln Sie den maximalen Wert der Zeichenkette und schreiben Sie ihn in die Datei max.txt (sie wird erstellt) zur Basis 16.    
format db "%d", 0                  ; format welches wir bei dem Lesen in Basis 10 benutzen
a dd 0                                             
message db "a = ", 0                                                ; Nachricht welches wir benutzen um die Werte auf dem Bildschirm zu anzeigen
maxim dd 0                                                          ; Variabile die den maximalen Wert speichert
format_max db "Maximum von dieser Reihe ist: %X (in Basis 16)", 0   ; format welches wir bei der Schreibung in Basis 16 benutzen
file_name db "max.txt",0                                            ; Name der Datei wo wir die Information schreiben
access_mode db "w",0                                                ; Datei Zugang 
file_descriptor dd -1                                               ; Variabile welche den descriptor halt


; our code starts here
segment code use32 class=code
    start:
        push dword message
        call [printf]
        add esp, 4*1
    
        mov esi, 0
    
        push dword a
        call [gets]
        add esp, 4*1
            
        mov eax, 0
        mov ebx, 0
        mov esi, 0
        mov ecx, 0
        
        citire:
    
            mov ebx, 0
            mov bl, [a + esi]
            
            cmp bl, 0
            je end_citire
            
            cmp bl, '0'
            jl not_number
            
            cmp bl, '9'
            ja not_number
            
            is_number:
                sub bl, '0'
                add eax, ebx
                inc esi
                jmp citire
                
            not_number:
                cmp eax, 0
                inc esi
                jmp citire
                    
                mov ecx, [maxim]
                cmp eax, ecx
                jle not_bigger
                
                bigger:
                    mov [maxim], eax
                
                not_bigger:

                mov eax, 0     
                inc esi
                jmp citire
            
        end_citire:
            cmp eax, 0
            je not_number_end
            
            not_number_end:

        push dword [maxim]
        call printToFile
        add esp, 4
        
        printToFile:
        mov eax, [esp + 4]  ;top of the stack
        mov [maxim], eax
    
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4*2
        
        mov [file_descriptor], eax
        
        cmp eax, 0
        je endFunction
        
        push dword [maxim]
        push dword format_max
        push dword [file_descriptor]
        call [fprintf]
        add esp, 4*3
        
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
        
    endFunction:
        ret
        
        push    dword 0
        call    [exit]