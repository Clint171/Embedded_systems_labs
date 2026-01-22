# Lab 5: Polling vs. Interrupt-Driven I/O

This lab compares two fundamental methods for handling I/O operations in embedded systems: polling and interrupt-driven I/O.

## Files

*   `polling.asm`: This program demonstrates how to use polling to continuously check the status of an I/O device. In this method, the CPU is occupied with checking the device's status, which can be inefficient.
*   `interrupt-driven.asm`: This program shows how to use interrupts to handle I/O. Instead of continuously checking the device, the CPU can perform other tasks and is only interrupted when the device needs service. This is a much more efficient method for handling I/O.
