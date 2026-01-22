# Lab 4: Memory and Stack Operations

This lab explores memory access and stack operations in the 8051 microcontroller. The exercises cover reading from code memory, accessing internal RAM, understanding stack growth, and observing automatic stack usage during interrupts.

## Files

*   `module1.asm`: Demonstrates reading data from code memory.
*   `module2.asm`: Shows how to read and write data to internal RAM.
*   `module3asm.asm`: Illustrates the behavior of the stack and stack pointer.
*   `module4asm.asm`: Shows how the stack is used automatically during an interrupt service routine (ISR).

## Concepts Implemented

### 1. Code Memory Access

The `module1.asm` program demonstrates how to read data from a lookup table stored in code memory using the `MOVC` instruction.

**Code Snippet (`module1.asm`):**

```assembly
; ========================================
; MODULE 1: Code Memory Access Demo
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
```

*   **Explanation:** This program uses the Data Pointer (`DPTR`) to hold the base address of the `TABLE` in code memory. It then loops five times, using the accumulator `A` as an offset, to read each byte from the table with `MOVC A, @A+DPTR`. The read value is then displayed on Port 1.

### 2. Internal RAM Access

The `module2.asm` program shows how to write to and read from the 8051's internal RAM using both direct and indirect addressing.

**Code Snippet (`module2.asm`):**

```assembly
; ========================================
; MODULE 2: Data Memory Access Demo
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
    
    SJMP $              ; Halt (infinite loop)

END
```

*   **Explanation:** The program first writes values to RAM addresses `30H`, `31H`, and `32H`. It then reads the value from `30H` using direct addressing (`MOV A, 30H`) and displays it on Port 1. It then uses indirect addressing with `R0` as a pointer (`MOV A, @R0`) to read from `31H` and display it on Port 2.

### 3. Stack Growth and SP Behavior

The `module3asm.asm` program demonstrates how the stack pointer (`SP`) and the stack itself work.

**Code Snippet (`module3asm.asm`):**

```assembly
; ========================================
; MODULE 3: Stack Growth Demonstration
; ========================================

ORG 0000H           ; Start at reset vector
LJMP MAIN           ; Jump to main program

ORG 0030H           ; Start main program here
MAIN:
    MOV SP, #50H        ; Set stack pointer to 50H (stack starts at 51H)
    
    ; Push operations (stack grows upward)
    MOV A, #0AAH
    PUSH ACC            ; Push A onto stack (SP = 51H, [51H] = AAH)
    
    MOV B, #0BBH
    PUSH B              ; Push B onto stack (SP = 52H, [52H] = BBH)
    
    ; Pop operations (stack shrinks downward)
    POP 06H             ; Pop into R6 (SP = 52H, R6 = CCH)
    
    POP B               ; Pop into B (SP = 51H, B = BBH)
    POP ACC             ; Pop into A (SP = 50H, A = AAH)
   
    SJMP $              ; Halt

END
```

*   **Explanation:** The stack pointer is initialized to `50H`. When data is `PUSH`ed onto the stack, the `SP` is incremented first, and then the data is stored at the memory location pointed to by `SP`. When data is `POP`ed, the data at the `SP`'s location is retrieved, and then the `SP` is decremented. The program displays the value of the `SP` on Port 1 at various stages to show this behavior.

### 4. Automatic Stack Usage by Interrupts

The `module4asm.asm` program shows that the 8051 automatically uses the stack to save the return address when an interrupt occurs.

**Code Snippet (`module4asm.asm`):**

```assembly
; ========================================
; MODULE 4: ISR Stack Usage Demo
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
    SETB ET0            ; Enable Timer 0 interrupt
    SETB EA             ; Enable global interrupts
    SETB TR0            ; Start Timer 0
    
MAIN_LOOP:
    SJMP MAIN_LOOP      ; Repeat forever

; Timer 0 Interrupt Service Routine
TIMER0_ISR:
    ; When ISR is entered, PC is automatically pushed to stack
    ; SP increases by 2 (return address is 2 bytes)
    
    CPL P2.0            ; Toggle P2.0 LED
    
    RETI                ; Return from interrupt (PC auto-popped)

END
```

*   **Explanation:** The program sets up and enables a Timer 0 interrupt. The main loop does nothing. When the timer overflows, an interrupt is triggered, and the processor jumps to the `TIMER0_ISR`. Before jumping, the 2-byte address of the next instruction in `MAIN_LOOP` is automatically pushed onto the stack. The `RETI` instruction at the end of the ISR pops this address back into the Program Counter, so the main program resumes where it left off. By observing the stack memory in the simulator, you can see the return address being pushed and popped.

## Simulator and Debugging

To observe the concepts in this lab, use the EdSim51DI simulator's memory and register views:
*   **Code Memory:** For `module1.asm`, you can see the `TABLE` data starting at address `0100H`.
*   **Internal RAM:** For `module2.asm`, you can view the contents of addresses `30H` and onwards to see the data being written and read. For `module3.asm` and `module4.asm`, you can watch the stack memory area (e.g., starting at `51H` or `61H`) to see how data and return addresses are pushed and popped.
*   **Special Function Registers (SFRs):** You can monitor the `SP` register to see its value change. You can also view the I/O ports (`P1`, `P2`) to see the output.
