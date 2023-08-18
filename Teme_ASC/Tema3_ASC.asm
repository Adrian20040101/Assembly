bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
;Zwei Folgen (von Bytes) S1 und S2 mit gleicher Länge werden angegeben. Erstelle die Folge D, so dass jedes Element von D das Maximum der entsprechenden Elemente von S1 und S2 darstellt.    
s1 db 1, 3, 6, 2, 3, 7   
l equ $-s1   ; im Konstante l wird die Lange einer der beiden Listen gespeichert (beide Listen sind von gleicher Lange)
s2 db 6, 3, 8, 1, 2, 5
d times l db 0  ; man reserviert l Bytes für den Zielfolge und initialisiere ihn

; our code starts here
segment code use32 class=code
    start:
        mov ecx, l   ; wir setzen die Länge l in ecx
        mov esi, 0   ; wir setzen den source index auf 0
        jecxz sfarsit   ; wir uberprufen ob die Lange der Liste 0 ist. Falls 0 ist wird keine Anweisung durchgefuhrt und springt direkt zu sfarsit
        repeta:   ; hier beginnt den loop
            mov al, [s1+esi]   ; wir speichern im al Register den Element von Position esi aus der Liste s1 
            mov bl, [s2+esi]   ; wir speichern im bl Register den Element von Position esi aus der Liste s2
            cmp al, bl   ; wir vergleichen die Werte im al und bl
            jle element_in_second_array   ; wenn al kleiner oder gleich bl ist, dann wird ein Sprung zum element_in_second_array durchgefuhrt
            element_in_first_array:
                mov [d+esi], al  ; falls al grosser ist, wird auf Position esi in Liste d das Wert von al gespeichert
                inc esi   ; esi = esi + 1
                jmp sfarsit_element_in_first_array   ; nach dieser Operation wird ein Sprung zum sfarsit_element_in_first_array durchgefuhrt, damit bl nicht im Liste d erscheint
            element_in_second_array:  ; wenn al kleiner als bl ist, werden die unteren Anweisungen durchgefuhrt
                mov [d+esi], bl   ; falls bl grosser ist, wird auf Position esi in Liste d das Wert von bl gespeichert
                inc esi   ; esi = esi + 1
            sfarsit_element_in_first_array:
        loop repeta  ; Programm wird wiederholt bis ecx den Wert 0 annimmt
        sfarsit:   ; Programm endet hier
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
