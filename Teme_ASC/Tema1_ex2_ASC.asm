; asamblare 			nasm -fobj exemplu.asm
; linkeditare 			alink -oPE -subsys console -entry start exemplu.obj
; depanare  			ollydbg exemplu.exe
; programe necesare 	http://www.nasm.us + alink: alink.sourceforge.net/download.html + http://www.ollydbg.de

bits 32

global start
extern ExitProcess, printf
import ExitProcess kernel32.dll
import printf msvcrt.dll
segment data use32 class=DATA
;Ausdruck ist (a*b+2)/(a+7-c)+d+x
a db 3
b dw 10
c db 5
d dd 7
x dq 12
segment code use32 class=CODE
start:
    
    mov al, [a] 			;In al wird das Wert von a gespeichert -> al: = a = 3
    mov ah, 0               ;Wir wandeln das Byte a in Wort um -> ax = 3
    mul word [b] 			;In dx:ax wird die Multiplikation von a und b (3*10) gespeichert -> dx:ax: = ax * b = 3 * 10 = 30
    push dx                 ;Wir verwenden den Stapel und speichern temporar das Wert von dx und ax im Register esp
    push ax
    pop eax                 ;Wir kopieren den Stapelwert in eax -> eax = 30
    add eax, 2  			;Wir addieren zum eax die Zahl 2 -> eax: = eax + 2 = 30 + 2 = 32

    mov bl, [a]			    ;Wir bringen den Wert von a in bl -> bl: = a = 3
    add bl, 7			    ;Wir addieren zum bl die Zahl 7 -> bl: = bl + 7 = 3 + 7 = 10
    mov cl, [c]			    ;Wir speichern im cl Register das Wert von c -> cl: = c = 5
    sub bl, cl			    ;Wir subtrahieren von bl das Wert von cl -> bl: = bl - cl = 10 - 5 = 5
    mov bh, 0               ;Wir wandeln das Byte, das im bl gespeichert wurde, in einem Wort um -> bx = 5
    
    push eax
    pop ax
    pop dx
    div word bx 			;Wir fuhren die Division von dx:ax und bx durch und es reprasentiert das Wert der Division der beiden Klammern -> ax = ax / bx = 32 / 5 = 6
    mov dx, 0               ;Wir wandeln das Wort ax in das Doppelwort dx:ax
    push dx                 ;Wir verwenden den Stapel und speichern temporar das Wert von dx und ax im Register esp
    push ax
    pop eax                 ;Wir kopieren den Stapelwert in eax -> eax = 6
    add eax, [d]			;Wir addieren im eax das Wert von d -> eax: = eax + d = 6 + 7 = 13
    mov edx, 0              ;Wir wandeln eax in edx:eax, damit wir einen Quadwort addieren
    
    mov ebx, [x]            ;Wir kopieren die erste Halfe von x in ebx (4 Bytes) -> ebx: = x = 12
    mov ecx, [x+4]          ;Wir kopieren die anderen 4 Bytes von x in ecx 
    clc                     ;Wir setzen den Carryflag auf 0 und es wird sich verandern nur wenn im Addition ein Overflow stattfindet
    
    add eax, ebx            ;Wir addieren im eax das Wert von x und erhalten das Endresultat -> eax: = eax + ebx = 13 + 12 = 25
    adc edx, ecx            ;Im edx wird die zweite Halfte von x addiert und wir berucksichtigen auch das Carryflag und das Quadwort wird endlich in die Konkatenation edx:eax gespeichert -> edx: edx + ecx
     
    
    push dword 0
    call [ExitProcess]
