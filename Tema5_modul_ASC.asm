bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start
global maxim
global a
global format

; declare external functions needed by our program
extern Det_Max_Func
extern exit, printf, scanf, fprintf, fopen, fclose          ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
import fprintf msvcrt.dll
import scanf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll 

; our data is declared here (the variables needed by our program)
segment data use32 class=data
;Lesen Sie eine Zeichenkette mit vorzeichenlosen Zahlen zur Basis 10 von der Tastatur. Ermitteln Sie den maximalen Wert der Zeichenkette und schreiben Sie ihn in die Datei max.txt (sie wird erstellt) zur Basis 16.    
a dd 0                                                              ; in diese Variable speichern wir den gelesenen Wert
message db "a = ", 0                                                ; Nachricht welches wir benutzen um die Werte auf dem Bildschirm zu anzeigen
format db "%d", 0                                                   ; format welches wir bei dem Lesen in Basis 10 benutzen
maxim dd 0                                                          ; Variabile die den maximalen Wert speichert
format_max db "Maximum von dieser Reihe ist: %X (in Basis 16)", 0   ; format welches wir bei der Schreibung in Basis 16 benutzen
file_name db "max.txt",0                                            ; Name der Datei wo wir die Information schreiben
access_mode db "w",0                                                ; Datei Zugang 
file_descriptor dd -1                                               ; Variabile welche den descriptor halt


; our code starts here
segment code use32 class=code
    start:
        ; hier zeigen wir die gelesenen Werten auf dem Bildschirm
        push dword message
        call [printf]
        add esp, 4
        
        mov eax, 0                                                  ; wir bereiten den eax Register vor
        
        call Det_Max_Func                                           ; wir rufen die Funktion aus der function.asm Datei an

        ; hier offnen wir die Datei um Informationen schreiben zu konnen
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4*2
        
        ; hier uberpruft man ob keine Errors in der Dateierzeugung getaucht sind
        mov [file_descriptor], eax
        cmp eax, 0
        je final
        
        ; hier wird der maximale Wert in der Datei geschrieben
        push dword [maxim]
        push dword format_max
        push dword [file_descriptor]
        call [fprintf]
        add esp, 4*3
        
        ; hier wird die Datei geschlossen
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
        jmp final
        
        final:
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
