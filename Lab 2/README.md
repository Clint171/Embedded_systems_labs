# Lab 2: Basic I/O and Port Addressing

This lab focuses on I/O operations, specifically bit-addressing and handling input with debouncing. The exercises demonstrate how to manipulate individual bits of a port and how to read input from switches reliably.

## Files

*   `LAB2_BIT_ADDRESSING.asm`: This program demonstrates various ways to manipulate individual bits of I/O ports.
*   `LAB2_ECHO_W_DEBOUNCE.asm`: This program reads the state of switches on Port 2 and echoes it to LEDs on Port 1, with a debounce delay to handle mechanical switch bouncing.

## Concepts Implemented

### 1. Bit-Level I/O Operations

The 8051 provides instructions to manipulate individual bits of certain Special Function Registers (SFRs) and I/O ports. `LAB2_BIT_ADDRESSING.asm` shows how to use these instructions.

**Code Snippet (`LAB2_BIT_ADDRESSING.asm`):**

```assembly
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
```

*   **Explanation:**
    *   `SETB P1.0`: Sets the bit P1.0 (Port 1, bit 0) to 1.
    *   `CLR P1.7`: Clears the bit P1.7 (Port 1, bit 7) to 0.
    *   `MOV C, P1.0`: Copies the value of P1.0 to the Carry Flag (C).
    *   `MOV P1.1, C`: Copies the value of the Carry Flag to P1.1.
    *   `CPL C`: Complements the Carry Flag.
    This demonstrates the fine-grained control over individual I/O pins.

### 2. Input Debouncing

Mechanical switches often "bounce" when pressed or released, causing multiple rapid transitions. The `LAB2_ECHO_W_DEBOUNCE.asm` program implements a delay-based debouncing routine.

**Code Snippet (`LAB2_ECHO_W_DEBOUNCE.asm`):**

```assembly
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
```

*   **Explanation:**
    1.  The program reads the state of Port 2 into the accumulator.
    2.  It calls the `DEBOUNCE` subroutine.
    3.  The `DEBOUNCE` subroutine is a delay loop. It uses nested loops with `DJNZ` to wait for a certain amount of time (~10-20ms). This allows the switch contacts to settle into a stable state.
    4.  After the delay, the program reads the state of Port 2 again, which should now be stable.
    5.  The stable state is then written to Port 1, lighting up the corresponding LEDs.
    *   The `PUSH` and `POP` instructions are used to save and restore the values of registers `R0` and `R1` that are used in the delay routine. This is good practice to avoid side effects in the main program.

## Simulator and LED Patterns

When running `LAB2_ECHO_W_DEBOUNCE.asm` in a simulator, you can connect virtual switches to Port 2 and LEDs to Port 1. When you change the state of the switches, you will see the corresponding LEDs on Port 1 light up after a short delay.
