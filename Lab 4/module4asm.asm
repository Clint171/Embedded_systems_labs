; ========================================
; MODULE 4: ISR Stack Usage Demo
; Purpose: Show automatic stack usage during interrupts
; ========================================

ORG 0000H           ; Reset vector
LJMP MAIN           ; Jump to main program

ORG 000BH           ; Timer 0 interrupt vector
LJMP TIMER0_ISR     ; Jump to ISR

ORG 0030H           ; Main program
MAIN:
    MOV SP, #60H        ; Set stack pointer to 60H
    
    ; Configure Timer 0
    MOV TMOD, #01H      ; Timer 0, Mode 1 (16-bit timer)
    MOV TH0, #0FCH      ; Load high byte for short delay
    MOV TL0, #018H      ; Load low byte
    
    SETB ET0            ; Enable Timer 0 interrupt
    SETB EA             ; Enable global interrupts
    SETB TR0            ; Start Timer 0
    
MAIN_LOOP:
    MOV P1, #0FFH       ; Main loop activity (all LEDs on)
    ACALL DELAY         ; Small delay
    MOV P1, #00H        ; All LEDs off
    ACALL DELAY
    SJMP MAIN_LOOP      ; Repeat forever

; Timer 0 Interrupt Service Routine
TIMER0_ISR:
    ; When ISR is entered, PC is automatically pushed to stack
 ; SP increases by 2 (return address is 2 bytes)
    
    CPL P2.0            ; Toggle P2.0 LED
    
    ; Reload timer values
    MOV TH0, #0FCH
    MOV TL0, #018H
    
    RETI                ; Return from interrupt (PC auto-popped)

; Simple delay subroutine
DELAY:
    PUSH 00H            ; Save R0 (SP increases)
    PUSH 01H            ; Save R1 (SP increases)
    
    MOV R0, #05H
DEL1:
    MOV R1, #0FFH
DEL2:
    DJNZ R1, DEL2
    DJNZ R0, DEL1
    
    POP 01H             ; Restore R1 (SP decreases)
    POP 00H             ; Restore R0 (SP decreases)
    RET                 ; Return from subroutine (PC popped)

END
