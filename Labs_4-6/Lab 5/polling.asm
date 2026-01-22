ORG 0000H
LJMP MAIN

ORG 0030H
MAIN:
    MOV TMOD, #01H     ; Timer0 Mode 1
    CLR P1.0           ; LED OFF

POLL_LOOP:
    MOV TH0, #3CH
    MOV TL0, #0B0H
    SETB TR0           ; Start Timer

WAIT_OVERFLOW:
    JNB TF0, WAIT_OVERFLOW

    CLR TR0
    CLR TF0

    CPL P1.0           ; Toggle LED
    SJMP POLL_LOOP
END
