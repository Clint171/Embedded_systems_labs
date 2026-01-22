ORG 0000H
LJMP MAIN

ORG 000BH          ; Timer0 Interrupt Vector
LJMP TIMER0_ISR

ORG 0030H
MAIN:
    MOV TMOD, #01H     ; Timer0 Mode 1 (16-bit)
    MOV TH0, #3CH      ; Load Timer0 for 50 ms
    MOV TL0, #0B0H

    SETB ET0           ; Enable Timer0 interrupt
    SETB EA            ; Enable global interrupts
    SETB TR0           ; Start Timer0

    MOV R7, #00        ; Overflow counter
    CLR P1.0           ; LED OFF initially

MAIN_LOOP:
    SJMP MAIN_LOOP     ; Main loop does nothing

; -------------------------------
TIMER0_ISR:
    MOV TH0, #3CH      ; Reload Timer0
    MOV TL0, #0B0H

    INC R7
    CJNE R7, #10, EXIT_ISR
    CPL P1.0           ; Toggle LED
    MOV R7, #00

EXIT_ISR:
    RETI
END
