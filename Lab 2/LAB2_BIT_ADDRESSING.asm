; FILE: LAB2_BIT_ADDRESSING.ASM
; Runs at 1MHz, 1 instruction/sec

ORG 0000H

START:
    ; 1. Set/Clear a bit directly (LED 0 ON/OFF)
    SETB P1.0       ; P1.0 = 1 (LED 0 OFF)
    CLR P1.7        ; P1.7 = 0 (LED 7 ON)

    ; 2. Move data to a bit using the Carry Flag (CY)
    MOV C, P1.0     ; Move the state of P1.0 to the Carry Flag (C)
    MOV P1.1, C     ; Copy the value of C (1) to P1.1 (LED 1 OFF)

    ; 3. Use the SETB/CLR operations to invert the state
    CPL C           ; Complement the Carry flag (C = 0)
    MOV P1.2, C     ; Copy C (0) to P1.2 (LED 2 ON)

    CPL P1.0       ; Reset state before looping
    CPL P1.7
    SJMP START
END