; FILE: LAB2_ECHO_W_DEBOUNCE.ASM
; Runs at 12MHz, 1000 instruction/sec or higher

ORG 0000H

START:
    MOV A, P2       ; Read initial state of switches from Port 2
    ACALL DEBOUNCE  ; Wait for contacts to settle
    MOV A, P2       ; Read stable state of switches
    MOV P1, A       ; Copy state to LEDs on Port 1
    SJMP START

; Debounce Delay (approx. 10ms at 12MHz)
; Assumes a 12MHz clock, where 1 machine cycle is 1us.
DEBOUNCE:
    PUSH 00H        ; Save R0 (Address 00H)
    PUSH 01H        ; Save R1 (Address 01H)

    MOV R1, #10     ; Outer loop (10 repeats)
OUT_LOOP:
    MOV R0, #200    ; Inner loop (200 repeats)
IN_LOOP:
    DJNZ R0, IN_LOOP
    DJNZ R1, OUT_LOOP
    
    ; Total Delay: 10 * (200 * 2us/cycle) = 4ms (approx.)
    ; Let's adjust for ~10ms for better visibility in simulator or for a real-world scenario
    MOV R1, #50     ; Let's use 50 repetitions for ~10ms delay (50 * 200 * 2us = 20ms)
OUT_LOOP_2:
    MOV R0, #200
IN_LOOP_2:
    DJNZ R0, IN_LOOP_2
    DJNZ R1, OUT_LOOP_2

    POP 01H         ; Restore R1 (Address 01H)
    POP 00H         ; Restore R0 (Address 00H)
    RET
END