bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fread, fclose, printf              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll
                          

;Eine Textdatei wird gegeben. Lese den Inhalt der Datei, zähle die Anzahl der Vokale und zeige das Ergebnis auf dem Bildschirm an. Der Name der Textdatei wird im Datensegment definiert.
segment data use32 class=data
    datei_name db "input.txt", 0            ; Dateiname
    acces_methode db "r", 0                 ; Zugangmethode, in diesem Fall 'r' fur 'read'
    datei_zugang dd -1                      ; diese Variable ist wichtig, denn mithilfe dieser Variable konnen wir uns zu der Datei beziehen
    anzahl_charakt dd 0                     ; Anzahl der gelesenen Charakteren
    anzahl_vokalen dd 0                     ; Anzahl der gefundenen Vokalen
    len equ 100                             ; maximale Anzahl von Charakteren die in eine Etappe gelesen werden
    buffer resb len                         ; hier wird den Text aus der Datei gelesen
    format db "Anzahl von Vokalen: %d", 0   ; format wird als Modell der printing benutzt

; our code starts here
segment code use32 class=code
    start:
        ; wir rufen die Funktion fopen an
        push dword acces_methode
        push dword datei_name
        call [fopen]
        add esp, 4*2
        
        cmp eax, 0                          ; wir untersuchen ob die Datei geoffnet wurde, andererfalles wird das Programm enden 
        je ende
        mov [datei_zugang], eax             ; wir speichern den von fopen zurückgegebenen Wert in die Variable datei_zugang
        loop:
            push dword [datei_zugang]       ; in diese Sektion werden alle Charakteren von der Datei gelesen, bis man zum Ende ankommt
            push dword len
            push dword 1
            push dword buffer
            call [fread]                    ; wir rufen dei Funktion printf an 
            add esp, 4*4                    ; wir setzen die Parameters auf dem Stack frei, wobei erstes vier die Grosse eines Doppelwortes ist, zweites vier reprasentiert die Anzahl der Parameter
            cmp eax, 0                      ; wir uberprufen ob es keine Charakteren mehr zu lesen sind
            je cleanup                      ; wenn alle Charakteren gelesen wurden, wird man zum cleanup springen
            mov [anzahl_charakt], eax       ; eax speichert wie viele Charakteren gefunden wurden
            jmp loop
            
            cleanup:
            ; wir rufen die Funktion fclose an
            push dword [datei_zugang]
            call [fclose]
            add esp, 4
        ende:
        mov esi, 0                          ; wir bereiten den source index -> esi = 0
        mov ebx, [anzahl_charakt]           ; in ebx speichern wir die Anzahl der gelesenen Charakteren
        
        start_loop:
            cmp ebx, 0                      ; solange Charaktern noch zu lesen sind
            je ende_start_loop              ; wenn keine, springt es aus dem loop
            ;wir vergleichen in diesem Segment das Charakter mit den ASCII - Code der Vokalen (Gross - und Kleinbuchstaben)
            cmp byte[buffer+esi], 97
            je increment_counter
            cmp byte[buffer+esi], 101
            je increment_counter
            cmp byte[buffer+esi], 105
            je increment_counter
            cmp byte[buffer+esi], 111
            je increment_counter
            cmp byte[buffer+esi], 117  
            je increment_counter
            cmp byte[buffer+esi], 65
            je increment_counter
            cmp byte[buffer+esi], 69
            je increment_counter
            cmp byte[buffer+esi], 73
            je increment_counter
            cmp byte[buffer+esi], 79
            je increment_counter
            cmp byte[buffer+esi], 85  
            je increment_counter
            jmp next_item
            increment_counter:
            ; hier wird es ankommen nur wenn das gelesene Charakter eine Vokale ist, wobei der nachste Charakter zum Lesen vorbereitet wird
            inc dword [anzahl_vokalen]       ; anzahl_vokalen = anzahl_vokalen + 1
            inc esi                          ; esi = esi + 1
            dec ebx                          ; ebx = ebx - 1
            jmp start_loop
            next_item:
            ; hier wird es ankommen nur wenn das gelesene Charakter nicht eine Vokale ist, wobei der nachste Charakter zum Lesen vorbereitet wird
            inc esi                          ; esi = esi + 1
            dec ebx                          ; ebx = ebx - 1
            jmp start_loop
        ende_start_loop:
        
        ; wir rufen dei Funktion printf an
        push dword [anzahl_vokalen]
        push dword format
        call [printf]
        add esp, 4*2                         ; wir setzen die Parameters auf dem Stack frei, wobei vier die Grosse eines Doppelwortes ist, zwei reprasentiert die Anzahl der Parameter
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
