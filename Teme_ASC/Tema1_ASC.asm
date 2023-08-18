bits 32

global start
extern ExitProcess, printf
import ExitProcess kernel32.dll
import printf msvcrt.dll
segment data use32 class=DATA
;Ausdruck ist (a*a+b/c-1)/(b+c)+d-x
; man muss imul und idiv fur Operationen verwenden (vorzeichenbehaftet)
a dw 5
b db 6
c dw 2
d dd 9
x dq 10
segment code use32 class=CODE
start:
    
    mov ax, [a]       ;Wir speichern im ax das Wert des Wortes a -> ax: = a = 5
    imul ax           ;Das Wert im Register wird mit sich selbst multiplizieren -> dx:ax: = ax * ax = 5 * 5 = 25
    push dx           ;Wir verwenden den Stapel und speichern temporar das Wert von dx und ax im Register esp
    push ax
    pop ebx           ;Wir kopieren den Stapelwert in ebx -> ebx = 25
    mov al, [b]       ;Wir speichern in al das Wert von b -> al: = b = 6
    cbw               ;Wir wandeln das Byte al in das Wort ax um -> ax = 6
    cwd               ;Wir wandeln das Wort ax in das Doppelwort dx:ax um -> dx:ax = 6
    mov cx, [c]       ;Wir speichern in cx das Wert von c, cx: = c = 2
    idiv cx           ;Wir teilen das Wert von dx:ax mit dem Wert von cx und wir speichern es in ax -> ax = dx:ax / cx =  6 / 2 = 3
    
    cwde
    add eax, ebx      ;Wir addieren in ax das Wert von ebx -> eax: = eax + ebx = 3 + 25 = 28
    sub eax, 1        ;Wir subtrahieren von diesem Wert 1 -> eax: = eax - 1 = 28 - 1 = 27
    
    mov ebx, eax      ;Wir kopieren den Wert von eax in ebx damit wir mit eax weiter arbeiten konnen -> ebx: = eax = 27
    
    mov al, [b]       ;Wir speichern im al das Wert von b -> al: = b = 6
    cbw               ;Wir wandeln das Byte al in das Wort ax um
    add ax, [c]       ;Wir addieren im ax das Wert von c, welches 2 ist -> ax: = ax + c = 6 + 2 = 8

    mov cx, ax        ;Wir kopieren den Wert von ax in cx, damit wir mit cx spater telien konnen -> cx: = ax = 8
    
    push ebx          ;Wir speichern ebx Wert in Stapel und zerlegen den Wert in dx:ax
    pop ax
    pop dx
    
    idiv cx           ;Wir fuhren die Division von ax durch cx durch un es reprasentiert die Division der beiden Klammern -> ax = ax / cx = 27 / 8 = 3
    cwde              ;Wir wandeln das Wort ax in das Doppelwort eax um, denn wir mussen es mit einem Doppelwort addieren -> eax = 3
    
    add eax, [d]      ;Wir addieren im eax das Wert von d -> eax: = eax + d = 3 + 9 = 12
    cdq               ;Wir wandeln das Doppelwort eax in das Quadwort edx:eax um, denn wir mussen es mit einem Quadwort subtrahieren
    
    clc               ;Wir setzen den Carryflag auf 0 und es wird sich verandern nur wenn ein Overflow stattfindet
    mov ebx, [x]      ;Wir kopieren die erste Halfe von x in ebx (4 Bytes) -> ebx: = x = 10
    mov ecx, [x+4]    ;Wir kopieren die anderen 4 Bytes von x in ecx 
    
    sub eax, ebx      ;Wir subtrahieren von eax das Wert von x und wir erhalten das Endresultat -> eax: = eax - x = 12 - 10 = 2
    sbb edx, ecx      ;Im edx wird die zweite Halfte von x subtrahiert und wir berucksichtigen auch das Carryflag und das Quadwort wird endlich in die Konkatenation edx:eax gespeichert -> edx: edx - ecx
    
    push dword 0
    call [ExitProcess]
