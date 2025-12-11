# Lab 3: Analog-Digital Interaction (Software Simulation)

This lab explores the interface between an 8051 microcontroller and an external Analog-to-Digital Converter (ADC) and a character LCD. The program reads an analog value from the ADC and displays it as a bar graph on the LCD.

## Files

*   `LAB3_ADC_TO_LED.asm`: An assembly program that reads a value from a simulated ADC, converts it to a bar graph representation, and displays it on a character LCD.

## Concepts Implemented

### 1. Interfacing with a Character LCD

The program initializes and communicates with a Hitachi HD44780-compatible character LCD in 4-bit mode. This involves sending a series of commands to configure the display and then sending character data to be displayed.

**Key LCD Operations:**
*   **Initialization:** The `main` routine contains a sequence of instructions to initialize the LCD, setting it to 4-bit mode, clearing the display, and setting the entry mode.
*   **Sending Commands and Data:** The `sendCharacter` subroutine sends a byte of data or a command to the LCD. It splits the byte into two nibbles and sends them sequentially. The `RS` pin (P1.3) is used to differentiate between commands (`RS=0`) and data (`RS=1`).
*   **Custom Characters (CGRAM):** The program creates custom characters for the bar graph by writing pixel patterns to the Character Generator RAM (CGRAM) of the LCD. The `sendPattern` subroutine is used for this purpose.

### 2. Analog-to-Digital Conversion (ADC)

The program simulates the operation of an external ADC.
*   **Starting a Conversion:** The `timer0ISR` is configured to trigger every 200µs. It generates a pulse on the ADC's `WR` (Write) pin (P3.6) to start a new conversion.
*   **Reading the Conversion Result:** The `ext0ISR` is an external interrupt service routine that is triggered when the ADC conversion is complete (signaled by the ADC's `INTR` pin connected to the 8051's `INT0`). This ISR reads the digital value from the ADC (connected to Port 2) into the `B` register.

### 3. Interrupts

This program makes extensive use of interrupts for timing and handling external events.
*   **Timer 0 Interrupt:** Used to periodically start the ADC conversion. This ensures that the analog input is sampled at a regular interval.
*   **External 0 Interrupt:** Used to detect the end of an ADC conversion. This is an efficient way to handle the ADC, as the microcontroller can perform other tasks while the conversion is in progress.

### 4. Bar Graph Display Logic

The `updateBarGraph` subroutine converts the 8-bit digital value from the ADC into a 16-level bar graph on the 2-line LCD.
*   The top 4 bits of the ADC result are used to determine the height of the bar graph.
*   The most significant bit of the ADC result determines whether the bar is displayed on the top or bottom line of the LCD.
*   The lower 3 bits determine which of the 8 custom bar graph characters to display.

**Code Snippet (`LAB3_ADC_TO_LED.asm` - Interrupt Service Routines):**

```assembly
; timer 0 ISR - simply starts an ADC conversion
timer0ISR:
    CLR P3.6 ; clear ADC WR line
    SETB P3.6 ; then set it - this results in the required positive edge to start a conversion
    RETI ; return from interrupt

; external 0 ISR - responds to the ADC conversion complete interrupt
ext0ISR:
    CLR P3.7 ; clear the ADC RD line - this enables the data lines
    MOV B, P2 ; move ADC outputs to B
    SETB P3.7 ; disable the ADC data lines by setting RD
    CALL updateBarGraph ; update the bar graph using the new reading from the ADC
    RETI ; return from interrupt
```

*   **Explanation:** This shows the core of the ADC interaction. The timer interrupt starts the conversion, and the external interrupt reads the result and updates the display. This decouples the ADC process from the main program flow.

## Simulator and Output
The output on the LCD would be a bar graph that changes in height according to the analog input value provided to the ADC.
