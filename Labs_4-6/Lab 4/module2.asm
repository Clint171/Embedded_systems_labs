; ========================================
; MODULE 2: Data Memory Access Demo
; Purpose: Read/write data in RAM using MOV
; ========================================

ORG 0000H           ; Start at reset vector
LJMP MAIN           ; Jump to main program

ORG 0030H           ; Start main program here
MAIN:
    ; Write data to internal RAM
    MOV 30H, #0AAH      ; Store AAH at address 30H
    MOV 31H, #0BBH      ; Store BBH at address 31H
    MOV 32H, #0CCH      ; Store CCH at address 32H
    
    ; Read data from RAM using direct addressing
    MOV A, 30H          ; Load AAH into accumulator
    MOV P1, A           ; Display on Port 1
    
    ; Read using indirect addressing
    MOV R0, #31H        ; R0 points to address 31H
    MOV A, @R0          ; Read data at address pointed by R0
    MOV P2, A           ; Display on Port 2
    
    ; Modify data in RAM
    MOV A, 32H          ; Read CCH
    ADD A, #11H         ; Add 11H (result = DDH)
    MOV 33H, A          ; Store result at 33H
    
    SJMP $              ; Halt (infinite loop)

END
