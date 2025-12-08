; FILE: LAB1_LED_BLINK_SUB.ASM
ORG 0000H

START:
    CALL BLINK_SEQUENCE
    SJMP START

; Subroutine to sequentially blink two LEDs (P1.0 and P1.1)
BLINK_SEQUENCE:
    ; --- Blink LED 0 (P1.0) ---
    CLR P1.0        ; Turn LED 0 ON (Logic 0)
    SETB P1.1       ; Turn LED 1 OFF (Logic 1)
    ACALL DELAY_SHORT

    ; --- Blink LED 1 (P1.1) ---
    CLR P1.1        ; Turn LED 1 ON (Logic 0)
    SETB P1.0       ; Turn LED 0 OFF (Logic 1)
    ACALL DELAY_SHORT
    
    RET             ; Return from Subroutine

; Short Delay (approx. 100ms at 12MHz)
DELAY_SHORT:
    PUSH 00H         ; Save R0's current value (Address 00H) (best practice)
    PUSH 01H         ; Save R1's current value (Address 01H)

    MOV R1, #100    ; Outer loop: R1 repeats 100 times
LOOP_OUT:
    MOV R0, #200    ; Inner loop: R0 repeats 200 times
LOOP_IN:
    DJNZ R0, LOOP_IN
    DJNZ R1, LOOP_OUT

    POP 01H          ; Restore R1 (Address 01H)
    POP 00H          ; Restore R0 (Address 00H)
    RET
END