; ========================================
; MODULE 3: Stack Growth Demonstration
; Purpose: Show how PUSH/POP affect stack pointer
; ========================================

ORG 0000H           ; Start at reset vector
LJMP MAIN           ; Jump to main program

ORG 0030H           ; Start main program here
MAIN:
    MOV SP, #50H        ; Set stack pointer to 50H (stack starts at 51H)
    
    ; Initial SP = 50H
    MOV A, SP           ; Read SP
    MOV P1, A           ; Display SP on Port 1 (should show 50H)
    
    ; Push operations (stack grows upward)
    MOV A, #0AAH
    PUSH ACC            ; Push A onto stack (SP = 51H, [51H] = AAH)
    
    MOV A, SP
    MOV P1, A           ; Display SP (should show 51H)
    
    MOV B, #0BBH
    PUSH B              ; Push B onto stack (SP = 52H, [52H] = BBH)
    
    MOV A, SP
    MOV P1, A           ; Display SP (should show 52H)
    
    MOV R7, #0CCH
    PUSH 07H            ; Push R7 onto stack (SP = 53H, [53H] = CCH)
    
    MOV A, SP
    MOV P1, A           ; Display SP (should show 53H)
    
    ; Pop operations (stack shrinks downward)
    POP 06H             ; Pop into R6 (SP = 52H, R6 = CCH)
    
    MOV A, SP
    MOV P1, A           ; Display SP (should show 52H)
    
    POP B               ; Pop into B (SP = 51H, B = BBH)
    POP ACC             ; Pop into A (SP = 50H, A = AAH)
   MOV A, SP
    MOV P1, A           ; Display SP (should show 50H - back to original)
    
    SJMP $              ; Halt

END

