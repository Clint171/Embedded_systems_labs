; FILE: LAB2_BIT_ADDRESSING.ASM
ORG 0000H

START:
    ; 1. Set/Clear a bit directly (LED 0 ON/OFF)
    SETB P1.0       ; P1.0 = 1 (LED 0 OFF)
    CLR P1.7        ; P1.7 = 0 (LED 7 ON)
    
    ACALL DELAY_LONG

    ; 2. Move data to a bit using the Carry Flag (CY)
    MOV C, P1.0     ; Move the state of P1.0 to the Carry Flag (C)
    MOV P1.1, C     ; Copy the value of C (1) to P1.1 (LED 1 OFF)
    
    ACALL DELAY_LONG
    
    ; 3. Use the SETB/CLR operations to invert the state
    CPL C           ; Complement the Carry flag (C = 0)
    MOV P1.2, C     ; Copy C (0) to P1.2 (LED 2 ON)
    
    ACALL DELAY_LONG

    SETB P1.0       ; Reset state before looping
    CLR P1.7
    SJMP START

; Long Delay (approx. 200ms at 12MHz) - reusable from Lab 1
DELAY_LONG:
    PUSH 00H        ; Save R0 (Address 00H)
    PUSH 01H        ; Save R1 (Address 01H)
    MOV R1, #100
OUT_L:
    MOV R0, #200
IN_L:
    DJNZ R0, IN_L
    DJNZ R1, OUT_L
    POP 01H         ; Restore R1 (Address 01H)
    POP 00H         ; Restore R0 (Address 00H)
    RET
END