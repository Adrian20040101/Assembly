bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll

;Zwei natürliche Zahlen a und b (a , b : Doppelwörter, im Datensegment definiert) werden gegeben. Berechne ihr Produkt und zeige das Ergebnis im folgenden Format auf dem Bildschirm an: "<a> * <b> = <Ergebnis>". Beispiel: "2 * 4 = 8". Die Werte werden im Dezimalformat (Basis10) mit Vorzeichen angezeigt.
segment data use32 class=data
    format db "%d * %d = %d", 0 ; format wird als Modell der printing benutzt
    a dd 15
    b dd 3
    ergebnis dq 0
; our code starts here
segment code use32 class=code
    start:
        mov eax, [a]            ; wir speichern in eax das Doppelwort a -> eax = 15
        mov ecx, eax            ; wir kopieren dieses Wert in ecx, weil wir mit eax weiter arbeiten mussen -> ecx = 15
        mov ebx, [b]            ; wir speichern in ebx das Doppelwort b -> ebx = 3
        imul ebx                ; wir fuhren eine vorzeichenbehaftete Multiplikation
        mov [ergebnis+0], eax   ; wir berechnen das Resultat dieser Multiplikation mithilfe von zwei Registern, also edx:eax, da es ein Quadwort ist
        mov [ergebnis+4], edx
        mov [b], ebx            ; wir versichern uns, dass die variable b den richtigen Wert hat
        mov [a], ecx            ; wir versichern uns, dass die variable b den richtigen Wert hat
        push dword [ergebnis]   ; wir setzen Parameters auf dem Stack von rechts nach links
        push dword [b]
        push dword [a]
        push dword format       
        call [printf]           ; wir rufen dei Funktion printf an
        add esp, 4 * 4          ; wir setzen die Parameters auf dem Stack frei, wobei erstes vier die Grosse eines Doppelwortes ist, zweites vier reprasentiert die Anzahl der Parameter
       
        push    dword 0         ; push the parameter for exit onto the stack
        call    [exit]          ; call exit to terminate the program
