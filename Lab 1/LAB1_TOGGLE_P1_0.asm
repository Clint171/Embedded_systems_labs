; FILE: LAB1_TOGGLE_P1_0.ASM
; Runs at 1MHz, 1 instruction/sec
ORG 0000H

START:
    CPL P1.0        ; Toggle LED 0 (P1.0)
    SJMP START
END