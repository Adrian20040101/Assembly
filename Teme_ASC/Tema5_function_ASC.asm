bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global Det_Max_Func
extern maxim
extern a
extern format
extern scanf 
import scanf msvcrt.dll

; our code starts here
segment code use32 class=code
    Det_Max_Func:
        citire:
            ; hier werden die Werte gelesen und in Variable a gespeichert, und wenn a den Wert 0 erhalt, stoppt das Lesen von Werte
            push dword a 
            push dword format
            call [scanf]
            add esp, 4*2
            cmp dword [a], 0
            je final_citire
            mov eax, [a]                   ; wir speichern in eax das Wert von a
            det_max:
                cmp dword [maxim], eax     ; wir vergleichen maxim mit den gelesenen Wert
                jge citire                 ; wenn das Wert nicht grosser ist, dann wird es ignoriert
                mov [maxim],eax            ; wenn es grosser ist, erhalt maxim diesen Wert
                jmp citire                 ; dieses Prozess wird wiederholt, bis 0 gelesen wird
        final_citire:
            ret

;es vergleicht den Wert gleich nachdem es gelesen wurde