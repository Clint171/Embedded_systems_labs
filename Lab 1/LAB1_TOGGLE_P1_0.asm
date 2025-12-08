; FILE: LAB1_TOGGLE_P1_0.ASM
ORG 0000H

START:
    CPL P1.0        ; Toggle LED 0 (P1.0)
    ACALL DELAY_500MS
    SJMP START

; Subroutine for 500ms Delay (approx. at 12MHz)
DELAY_500MS:
    MOV R1, #250    ; Outer loop: R1 repeats 250 times
LOOP_OUTER:
    MOV R0, #200    ; Inner loop: R0 repeats 200 times
LOOP_INNER:
    ; NOP             ; No Operation (1 cycle)
    DJNZ R0, LOOP_INNER ; Decrement R0 and Jump if Not Zero (2 cycles)
    DJNZ R1, LOOP_OUTER ; Decrement R1 and Jump if Not Zero (2 cycles)
    RET
END