bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 1001101110111110b
    b dd 0
;nach der Verarbeitung soll b fur diesen Beispiel das Wert FF10FF
; our code starts here
segment code use32 class=code
    start:
        
    mov ebx, 0    ;WIr berechnen das Ergebnis in ebx
    mov ax, [a]    ;Wir kopieren das Wort a in ax Register -> ax = 1001101110111110b
    
    ;da die erste Halfte des Doppelwortes b gleich sein muss mit der zweiten Halfte, konnen wir irgendwelche Haltfe zuerst verarbeiten, und wir beginnen mit der zweiten Halfte, da wir laut Problem die hoheren Bits zuerst verarbeiten mussen
    or bx, 1111000000000000b  ;Wir zwingen die Bits 28-31 des Ergebnisses suf dem Wert 1 -> bx = 1111000000000000b
    
    and ax, 0000001100000000b ;Wir isolieren die Bits 8-9 von a
    or bx, ax ;Wir fugen die Bits in das Ergebnis ein -> bx = 1111001100000000b
    ;die Bits 8-9 von der ersten Halfte des Doppelwortes reprasentieren die Bits 24-25 von der Zweiten Halfte 
    and ax, 0000001100000000b  ;Wir isolieren die Bits 8-9 von a
    mov cl, 2  ;Wir kopieren das Wert 2 in cl -> cl = 2
    rol ax, cl ;Wir rotieren 2 Positionen nach links, also bis die isolierten Bits in den gewunschten Platze ankommen
    or bx, ax  ;Wir fugen die Bits in das Ergebnis ein -> bx = 1111111100000000b
    
    mov ax, [a] ;Wir kopieren das Wort a in ax Register -> ax = 1001101110111110b
    ;die Bits 0-3 von der ersten Halfte des Doppelwortes reprasentieren die Bits 16-19 von der Zweiten Halfte 
    not ax  ;Wir invertieren die Bits von a -> ax = 0110010001000001b
    and ax, 0000000000001111b  ;Wir isolieren die Bits 0-3 von a
    mov cl, 4  ;Wir kopieren das Wert 4 in cl -> cl = 4
    rol ax, cl  ;Wir rotieren 4 Positionen nach links, also bis die isolierten Bits in den gewunschten Platze ankommen
    or bx, ax  ;Wir fugen die Bits in das Ergebnis ein -> bx = 1111111100010000b
    
    and bx, 1111111111110000b ; Wir zwingen die Bits 16-19 des Ergebnisses auf dem Wert 0 -> bx = 1111111100010000b
    
    push bx  ;Wir kopieren die zweite Halfte des Doppelwortes in Stack
    
    mov cx, bx  ;Wir kopieren die Bits der zweiten Haltfe des Doppelwortes in cx und so haben wir in cx die erste Halfte gespeichert
    push cx  ;Wir kopieren die erste Halfte des Doppelwortes in Stack
    pop ebx  ;Wir erhalten die zwei Haltfen die im Stack gespeichert wurden und bilden den Doppelwort b, das im ebx gespeichert wird -> ebx = 11111111000100001111111100010000b
    mov [b], ebx  ;Wir kopieren das Doppelwort b, das im ebx gespeichert wurde, in die Variable b
    
        
    push    dword 0      ; push the parameter for exit onto the stack
    call    [exit]       ; call exit to terminate the program
