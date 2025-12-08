; FILE: LAB3_ADC_TO_DAC.ASM
ORG 0000H

START:
    ; Initialisation
    CLR P0.7        ; Enable DAC WR line (P0.7 active-low) / Disable Decoder CS (P0.7 active-high) [cite: 2118, 2119]
    SETB P3.7       ; Disable ADC RD line (P3.7 active-low) [cite: 2412]
    
LOOP_START:
    ; 1. Initiate ADC Conversion (Positive edge on P3.6 - WR)
    CLR P3.6        ; WR low
    SETB P3.6       ; WR high (Initiates conversion) [cite: 2414]
    
    ; 2. Wait for INTR to go low (Conversion Complete - P3.2)
    JNB P3.2, $     ; Wait while P3.2 (INTR) is high (waiting for INTR line to go low) [cite: 2415]
    
    ; 3. Read ADC Data
    CLR P3.7        ; Enable ADC RD line (P3.7 low) - ADC output is placed on P2 [cite: 2412]
    MOV A, P2       ; Read ADC data from P2 into Accumulator A
    SETB P3.7       ; Disable ADC RD line (P3.7 high)
    
    ; 4. Output to DAC
    MOV P1, A       ; Move digital value from A to P1 (DAC input pins)
    
    ; 5. Loop
    SJMP LOOP_START
    
; Note: The output will be visible on the DAC Scope panel.
; Make sure the ADC is enabled (not the comparator) in the simulator[cite: 2394].
END