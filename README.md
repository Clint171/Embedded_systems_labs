# Embedded Systems Labs

This repository contains a series of lab exercises for an embedded systems course, implemented in 8051 assembly language.

## Lab 1: Basic I/O and Control

### `LAB1_1000_ITERATION.asm`

This program demonstrates a simple loop that increments a register `R0` 1000 times. It uses `R1` and `R2` to hold the high and low bytes of the 16-bit counter. The program halts in an endless loop after the counting is complete.

```assembly
; FILE: LAB1_1000_ITERATION.ASM
ORG 0000H

    MOV R1, #03H    ; High byte of 1000 (03E8H)
    MOV R2, #0E8H   ; Low byte of 1000 (E8H)
    MOV R0, #00H    ; Register to be incremented

START:
    INC R0          ; Increment R0 (The primary action)

    ; 16-bit Decrement Routine (R1:R2)
    DJNZ R2, NEXT_ITERATION ; Decrement R2, if not zero, jump to NEXT_ITERATION
    DJNZ R1, NEXT_ITERATION ; Decrement R1, if not zero, jump to NEXT_ITERATION

    ; If both R1 and R2 reach zero, the loop halts.
    SJMP $          ; Halt/Endless loop (Equivalent to MOV PC, PC on some systems)

NEXT_ITERATION:
    SJMP START      ; Jump back to the start of the loop
END
```

**Explanation:**

*   `MOV R1, #03H` and `MOV R2, #0E8H`: These lines initialize a 16-bit counter. `03E8H` is the hexadecimal representation of 1000.
*   `INC R0`: This line increments the register `R0`. This is the main action of the loop.
*   `DJNZ R2, NEXT_ITERATION` and `DJNZ R1, NEXT_ITERATION`: These lines form a 16-bit decrementing counter. The inner loop (`DJNZ R2,...`) runs 256 times, and then the outer loop (`DJNZ R1,...`) decrements. This continues until both `R1` and `R2` are zero.
*   `SJMP $`: This is a short jump to the current address, creating an infinite loop that effectively halts the program.
*   `SJMP START`: This line jumps back to the `START` label to continue the loop until the counter reaches zero.

### `LAB1_LED_BLINK_SUB.asm`

This program demonstrates the use of subroutines to control I/O. It blinks two LEDs connected to `P1.0` and `P1.1` sequentially. The blinking is achieved by calling a delay subroutine between turning the LEDs on and off. The program uses the `PUSH` and `POP` instructions to save and restore register values, which is good practice in subroutines.

```assembly
; FILE: LAB1_LED_BLINK_SUB.ASM
ORG 0000H

START:
    CALL BLINK_SEQUENCE
    SJMP START

; Subroutine to sequentially blink two LEDs (P1.0 and P1.1)
BLINK_SEQUENCE:
    ; --- Blink LED 0 (P1.0) ---
    CLR P1.0        ; Turn LED 0 ON (Logic 0)
    SETB P1.1       ; Turn LED 1 OFF (Logic 1)
    ACALL DELAY_SHORT

    ; --- Blink LED 1 (P1.1) ---
    CLR P1.1        ; Turn LED 1 ON (Logic 0)
    SETB P1.0       ; Turn LED 0 OFF (Logic 1)
    ACALL DELAY_SHORT
    
    RET             ; Return from Subroutine

; Short Delay (approx. 100ms at 12MHz)
DELAY_SHORT:
    PUSH 00H         ; Save R0's current value (Address 00H) (best practice)
    PUSH 01H         ; Save R1's current value (Address 01H)

    MOV R1, #100    ; Outer loop: R1 repeats 100 times
LOOP_OUT:
    MOV R0, #200    ; Inner loop: R0 repeats 200 times
LOOP_IN:
    DJNZ R0, LOOP_IN
    DJNZ R1, LOOP_OUT

    POP 01H          ; Restore R1 (Address 01H)
    POP 00H          ; Restore R0 (Address 00H)
    RET
END
```

**Explanation:**

*   `CALL BLINK_SEQUENCE`: This line calls the `BLINK_SEQUENCE` subroutine.
*   `CLR P1.0`: This line clears the `P1.0` bit, which turns the LED on (assuming active-low).
*   `SETB P1.1`: This line sets the `P1.1` bit, turning the other LED off.
*   `ACALL DELAY_SHORT`: This line calls the delay subroutine to create a pause.
*   `PUSH 00H` and `POP 00H`: These lines save and restore the value of `R0` on the stack. This is important because the `DELAY_SHORT` subroutine also uses `R0`.

### `LAB1_TOGGLE_P1_0.asm`

This program toggles an LED connected to `P1.0` indefinitely. It uses a delay subroutine to control the toggling speed.

```assembly
; FILE: LAB1_TOGGLE_P1_0.ASM
ORG 0000H

START:
    CPL P1.0        ; Toggle LED 0 (P1.0)
    ACALL DELAY_500MS
    SJMP START

; Subroutine for 500ms Delay (approx. at 12MHz)
DELAY_500MS:
    MOV R1, #250    ; Outer loop: R1 repeats 250 times
LOOP_OUTER:
    MOV R0, #200    ; Inner loop: R0 repeats 200 times
LOOP_INNER:
    ; NOP             ; No Operation (1 cycle)
    DJNZ R0, LOOP_INNER ; Decrement R0 and Jump if Not Zero (2 cycles)
    DJNZ R1, LOOP_OUTER ; Decrement R1 and Jump if Not Zero (2 cycles)
    RET
END
```

**Explanation:**

*   `CPL P1.0`: This instruction complements the bit `P1.0`, effectively toggling the LED.
*   `ACALL DELAY_500MS`: This calls a subroutine that creates a delay of approximately 500ms.
*   The `DELAY_500MS` subroutine is a nested loop that wastes CPU cycles to create the delay.

## Lab 2: Bit-level Operations and Debouncing

### `LAB2_BIT_ADDRESSING.asm`

This program demonstrates various ways to manipulate individual bits in the 8051 architecture. It shows how to set and clear bits directly, how to move data to a bit using the carry flag, and how to invert the state of a bit.

```assembly
; FILE: LAB2_BIT_ADDRESSING.ASM
ORG 0000H

START:
    ; 1. Set/Clear a bit directly (LED 0 ON/OFF)
    SETB P1.0       ; P1.0 = 1 (LED 0 OFF)
    CLR P1.7        ; P1.7 = 0 (LED 7 ON)
    
    ACALL DELAY_LONG

    ; 2. Move data to a bit using the Carry Flag (CY)
    MOV C, P1.0     ; Move the state of P1.0 to the Carry Flag (C)
    MOV P1.1, C     ; Copy the value of C (1) to P1.1 (LED 1 OFF)
    
    ACALL DELAY_LONG
    
    ; 3. Use the SETB/CLR operations to invert the state
    CPL C           ; Complement the Carry flag (C = 0)
    MOV P1.2, C     ; Copy C (0) to P1.2 (LED 2 ON)
    
    ACALL DELAY_LONG

    SETB P1.0       ; Reset state before looping
    CLR P1.7
    SJMP START
...
```

**Explanation:**

*   `SETB P1.0` and `CLR P1.7`: These are direct bit manipulation instructions. `SETB` sets a bit to 1, and `CLR` clears it to 0.
*   `MOV C, P1.0` and `MOV P1.1, C`: These instructions show how to use the carry flag (`C`) as an intermediary for moving a bit from one location to another.
*   `CPL C`: This instruction complements the carry flag, inverting its value.

### `LAB2_ECHO_W_DEBOUNCE.asm`

This program reads the state of switches on Port 2 and echoes it to LEDs on Port 1. It includes a debounce delay subroutine to handle the mechanical bouncing of the switches, ensuring a stable reading.

```assembly
; FILE: LAB2_ECHO_W_DEBOUNCE.ASM
ORG 0000H

START:
    MOV A, P2       ; Read initial state of switches from Port 2
    ACALL DEBOUNCE  ; Wait for contacts to settle
    MOV A, P2       ; Read stable state of switches
    MOV P1, A       ; Copy state to LEDs on Port 1
    SJMP START

; Debounce Delay (approx. 10ms at 12MHz)
...
DEBOUNCE:
    ...
```

**Explanation:**

*   `MOV A, P2`: This reads the values from the pins of Port 2 into the accumulator.
*   `ACALL DEBOUNCE`: This calls a subroutine that waits for a short period to allow the switch contacts to stabilize.
*   `MOV P1, A`: This copies the stable switch states from the accumulator to the LEDs on Port 1.

## Lab 3: ADC and DAC

### `LAB3_ADC_TO_DAC.asm`

This program demonstrates how to read an analog value from an Analog-to-Digital Converter (ADC) and output it to a Digital-to-Analog Converter (DAC). It initiates an ADC conversion, waits for the conversion to complete, reads the digital value, and then sends it to the DAC. This creates a simple "pass-through" for an analog signal.

```assembly
; FILE: LAB3_ADC_TO_DAC.ASM
ORG 0000H

START:
    ; Initialisation
    CLR P0.7        ; Enable DAC WR line (P0.7 active-low)
    SETB P3.7       ; Disable ADC RD line (P3.7 active-low)
    
LOOP_START:
    ; 1. Initiate ADC Conversion (Positive edge on P3.6 - WR)
    CLR P3.6        ; WR low
    SETB P3.6       ; WR high (Initiates conversion)
    
    ; 2. Wait for INTR to go low (Conversion Complete - P3.2)
    JNB P3.2, $     ; Wait while P3.2 (INTR) is high
    
    ; 3. Read ADC Data
    CLR P3.7        ; Enable ADC RD line (P3.7 low)
    MOV A, P2       ; Read ADC data from P2 into Accumulator A
    SETB P3.7       ; Disable ADC RD line (P3.7 high)
    
    ; 4. Output to DAC
    MOV P1, A       ; Move digital value from A to P1 (DAC input pins)
    
    ; 5. Loop
    SJMP LOOP_START
...
```

**Explanation:**

*   `CLR P3.6` and `SETB P3.6`: These lines create a rising edge on the `WR` (write) pin of the ADC, which starts the conversion process.
*   `JNB P3.2, $`: This line checks the `INTR` (interrupt) pin of the ADC. The program waits here until the pin goes low, indicating that the conversion is complete.
*   `CLR P3.7`: This enables the `RD` (read) line of the ADC, which puts the converted digital value onto Port 2.
*   `MOV A, P2`: This reads the digital value from Port 2 into the accumulator.
*   `MOV P1, A`: This sends the digital value from the accumulator to Port 1, which is connected to the DAC.