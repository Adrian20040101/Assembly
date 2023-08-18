bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 0111011101010111b
    b dw 1001101110111110b
    c dd 0

; our code starts here
segment code use32 class=code
    start:
        mov ebx, 0  ;WIr berechnen das Ergebnis in ebx
        and bx, 111111111110000000b  ;Wir zwingen die Bits 0-6 des Ergebnisses auf dem Wert 0 -> bx = 0000000000000000b
        mov ax, [a]  ;Wir kopieren das Wort a in ax Register -> ax = 0111011101010111b
        and ax, 000000000000000111b  ;Wir isolieren die Bits 0-2 von a
        mov cl, 7  ;Wir kopieren das Wert 7 in cl -> cl = 7
        rol ax, cl  ;Wir rotieren 2 Positionen nach links, also bis die isolierten Bits in den gewunschten Platze ankommen
        or bx, ax  ;Wir fugen die Bits in das Ergebnis ein -> bx = 0000001110000000b
        
        mov ax, [b]  ;Wir kopieren das Wort b in ax Register -> ax = 1001101110111110b
        and ax, 000001111100000000b  ;Wir isolieren die Bits 8-13 von b
        mov cl, 2  ;Wir kopieren das Wert 2 in cl -> cl = 2
        rol ax, cl  ;Wir rotieren 2 Positionen nach links, also bis die isolierten Bits in den gewunschten Platze ankommen
        or bx, ax  ;Wir fugen die Bits in das Ergebnis ein -> bx = 0110111110000000b
        
        mov dx, 0  ;Wir bereiten den Register dx fur die Verarbeitung zweite Halfte des Doppelwortes
        or dx, 1111111111111111b  ;Wir zwingen alle Bits von dx auf 1
        push dx  ;Wir speichern im Stack zuerst Register dx, welches die zweite Halfte des Doppelworts verarbeitet hat 
        push bx  ;Wir speichern dann im Stack Register bx, welches die zweite Halfte des Doppelwortes verarbeitet hat
        pop ebx  ;Wir erhalten die zwei Haltfen die im Stack gespeichert wurden und bilden den Doppelwort c, das im ebx gespeichert wird -> ebx = 11111111111111110110111110000000b
        
        mov [c], ebx  ;Wir kopieren das Doppelwort c, das im ebx gespeichert wurde, in die Variable c
    
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
