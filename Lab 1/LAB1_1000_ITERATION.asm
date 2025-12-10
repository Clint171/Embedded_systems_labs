; FILE: LAB1_1000_ITERATION.ASM
; Runs at 1MHz, 1 instruction/sec

ORG 0000H

    MOV R1, #03H    ; High byte of 1000 (03E8H)
    MOV R2, #0E8H   ; Low byte of 1000 (E8H)
    MOV R0, #00H    ; Register to be incremented

START:
    INC R0          ; Increment R0 (The primary action)

    ; 16-bit Decrement Routine (R1:R2)
    DJNZ R2, NEXT_ITERATION
    DJNZ R1, NEXT_ITERATION

    ; If both R1 and R2 reach zero, the loop halts.
    SJMP $          ; Halt/Endless loop (Equivalent to MOV PC, PC on some systems)

NEXT_ITERATION:
    SJMP START
END