; FILE: LAB1_LED_BLINK_SUB.ASM
; Runs at 1MHz, 1 instruction/sec
ORG 0000H

START:
    CALL BLINK_SEQUENCE
    SJMP START

; Subroutine to sequentially blink two LEDs (P1.0 and P1.1)
BLINK_SEQUENCE:
    ; --- Blink LED 0 (P1.0) ---
    CLR P1.0        ; Turn LED 0 ON (Logic 0)
    SETB P1.1       ; Turn LED 1 OFF (Logic 1)

    ; --- Blink LED 1 (P1.1) ---
    CLR P1.1        ; Turn LED 1 ON (Logic 0)
    SETB P1.0       ; Turn LED 0 OFF (Logic 1)
    
    RET             ; Return from Subroutine
END