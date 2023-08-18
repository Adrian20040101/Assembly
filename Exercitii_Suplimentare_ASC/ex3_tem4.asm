bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll

;Zwei natürliche Zahlen a und b (a,b:Doppelwörter, definiert im Datensegment) werden gegeben. Berechne ihre Summe und zeige das Ergebnis im folgenden Format auf dem Bildschirm an: "<a> + <b> = <Ergebnis>".Beispiel: „1 + 2 = 3“.Die Werte werden im Dezimalformat (Basis10) mit Vorzeichen angezeigt.
segment data use32 class=data
    format db "%d + %d = %d", 0 
    a dd 15
    b dd 33
    ergebnis dq 0
; our code starts here
segment code use32 class=code
    start:
        mov eax, [a]
        add eax, [b]
        mov [ergebnis], eax
        push dword [ergebnis]   ; wir setzen Parameters auf dem Stack von rechts nach links
        push dword [b]
        push dword [a]
        push dword format       
        call [printf]           ; wir rufen dei Funktion printf an
        add esp, 4 * 4          ; wir setzen die Parameters auf dem Stack frei, wobei erstes vier die Grosse eines Doppelwortes ist, zweites vier reprasentiert die Anzahl der Parameter
       
        push    dword 0         ; push the parameter for exit onto the stack
        call    [exit]          ; call exit to terminate the program
