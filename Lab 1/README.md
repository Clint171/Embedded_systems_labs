# Lab 1: 8051 Assembly Fundamentals in a Simulator

This lab explores the fundamentals of 8051 assembly language programming using a simulator. The exercises cover data movement, looping, I/O operations, and subroutines.

## Files

*   `LAB1_1000_ITERATION.asm`: An assembly program that increments a register (R0) in a loop for 1000 iterations.
*   `LAB1_LED_BLINK_SUB.asm`: An assembly program that demonstrates the use of subroutines to blink two LEDs connected to P1.0 and P1.1.
*   `LAB1_TOGGLE_P1_0.asm`: An assembly program that toggles the state of a single LED connected to P1.0.

## Concepts Implemented

### 1. Looping and Iteration

The `LAB1_1000_ITERATION.asm` program demonstrates a 16-bit counter to achieve 1000 iterations.

**Code Snippet (`LAB1_1000_ITERATION.asm`):**

```assembly
; FILE: LAB1_1000_ITERATION.ASM
; Runs at 1MHz, 1 instruction/sec

ORG 0000H

    MOV R1, #03H    ; High byte of 1000 (03E8H)
    MOV R2, #0E8H   ; Low byte of 1000 (E8H)
    MOV R0, #00H    ; Register to be incremented

START:
    INC R0          ; Increment R0 (The primary action)

    ; 16-bit Decrement Routine (R1:R2)
    DJNZ R2, NEXT_ITERATION
    DJNZ R1, NEXT_ITERATION

    ; If both R1 and R2 reach zero, the loop halts.
    SJMP $          ; Halt/Endless loop (Equivalent to MOV PC, PC on some systems)

NEXT_ITERATION:
    SJMP START
END
```

*   **Explanation:** This program initializes `R1` and `R2` with the high and low bytes of 1000 (0x03E8). The `DJNZ` (Decrement and Jump if Not Zero) instruction is used to create a loop. The inner loop decrements `R2` and the outer loop decrements `R1`. `R0` is incremented in each iteration. The program halts in an endless loop (`SJMP $`) after 1000 iterations.

### 2. Subroutines and I/O Operations

The `LAB1_LED_BLINK_SUB.asm` program demonstrates how to use subroutines (`CALL` and `RET`) to structure code and control I/O pins to blink LEDs.

**Code Snippet (`LAB1_LED_BLINK_SUB.asm`):**

```assembly
; FILE: LAB1_LED_BLINK_SUB.ASM
; Runs at 1MHz, 1 instruction/sec
ORG 0000H

START:
    CALL BLINK_SEQUENCE
    SJMP START

; Subroutine to sequentially blink two LEDs (P1.0 and P1.1)
BLINK_SEQUENCE:
    ; --- Blink LED 0 (P1.0) ---
    CLR P1.0        ; Turn LED 0 ON (Logic 0)
    SETB P1.1       ; Turn LED 1 OFF (Logic 1)

    ; --- Blink LED 1 (P1.1) ---
    CLR P1.1        ; Turn LED 1 ON (Logic 0)
    SETB P1.0       ; Turn LED 0 OFF (Logic 1)
    
    RET             ; Return from Subroutine
END
```

*   **Explanation:** The `BLINK_SEQUENCE` subroutine is called from the `START` label. This subroutine first turns on the LED at P1.0 and turns off the LED at P1.1. Then it does the reverse. The `RET` instruction returns the program control to the instruction after `CALL`. The main program then jumps back to `START`, creating an infinite loop.

### 3. Basic I/O Toggling

The `LAB1_TOGGLE_P1_0.asm` program shows the simplest way to toggle an I/O pin.

**Code Snippet (`LAB1_TOGGLE_P1_0.asm`):**

```assembly
; FILE: LAB1_TOGGLE_P1_0.ASM
; Runs at 1MHz, 1 instruction/sec
ORG 0000H

START:
    CPL P1.0        ; Toggle LED 0 (P1.0)
    SJMP START
END
```

*   **Explanation:** The `CPL P1.0` instruction complements the value of the pin P1.0. If it's 1, it becomes 0, and vice-versa. The `SJMP START` creates an infinite loop to continuously toggle the LED. Assuming a 1MHz clock and 1 instruction per cycle, this would toggle the pin at a very high frequency. The comment in the file suggests a 1 instruction/sec execution which would result in a 0.5Hz toggle rate.

## Simulator and Waveforms

To run these programs, you can use the provided `edsim51di.jar` simulator or any other 8051 simulator. The lab specifications suggest observing the waveforms. For example, in `LAB1_TOGGLE_P1_0.asm`, the waveform for P1.0 would be a square wave.

## Reflection on Instruction Timings and Cycles

The timing of these programs is highly dependent on the clock frequency of the simulated 8051 microcontroller. For instance, in `LAB1_TOGGLE_P1_0.asm`, the toggle frequency of P1.0 is determined by the execution time of the `CPL` and `SJMP` instructions. If the simulator runs at 1MHz and each instruction takes one machine cycle, the loop takes two cycles. This results in a high-frequency square wave on P1.0.
