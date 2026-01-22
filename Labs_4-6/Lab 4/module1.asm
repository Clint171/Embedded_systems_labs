; ========================================
; MODULE 1: Code Memory Access Demo
; Purpose: Read data from code memory using MOVC
; Simulator: EDSIM51DI
; ========================================

ORG 0000H
SJMP MAIN

ORG 0030H
MAIN:
    MOV P1, #00H       ; ✅ Initialize Port 1 (fixes simulator error)
    MOV DPTR, #TABLE
    MOV R0, #00H

LOOP:
    MOV A, R0
    MOVC A, @A+DPTR
    MOV P1, A

    INC R0
    CJNE R0, #05H, LOOP

HERE:
    SJMP HERE

ORG 0100H
TABLE:
    DB 11H, 22H, 33H, 44H, 55H

END
