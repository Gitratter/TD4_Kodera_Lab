# TD4 CPU on FPGA

FPGA-based implementation of a TD4 4-bit CPU designed to understand processor architecture, instruction execution flow, and digital circuit design.

---

## Overview

This project implements a 4-bit TD4 CPU on FPGA using Verilog HDL.  
The purpose of this research is to understand processor architecture and instruction execution by designing a CPU from scratch at the hardware level.

The CPU executes instructions using hardware modules such as registers, an ALU, a program counter, ROM, and a decoder.  
The design was implemented and verified on FPGA hardware using the BASYS3 development board.

In addition to CPU operation, this project also focuses on practical FPGA design techniques such as:

- synchronous circuit design
- clock enable control
- reset handling
- timing-aware implementation
- hardware debugging

---

## Features

- 4-bit TD4 CPU architecture
- FPGA implementation on BASYS3
- Instruction fetch / decode / execute cycle
- Register A / Register B architecture
- 4-bit ALU
- Program Counter (PC)
- Carry Flag support
- Conditional jump instruction (JNC)
- Clock-enable based synchronous operation
- LED-based hardware verification
- Hardware-level debugging and validation

---

## Development Environment

| Item | Description |
|---|---|
| FPGA Board | BASYS3 |
| HDL | Verilog HDL |
| Development Tool | Vivado |
| Language | Verilog |
| OS | Windows |

---

## CPU Architecture

The CPU consists of the following components:

- Register A
- Register B
- Program Counter (PC)
- Arithmetic Logic Unit (ALU)
- Carry Flag Register
- Instruction Decoder
- Instruction ROM
- Selector
- Clock Enable Generator
- Control Logic

---

### Block Diagram

```text
                +-------------------+
                | Program Counter   |
                +-------------------+
                          |
                          v
                +-------------------+
                | Instruction ROM   |
                +-------------------+
                          |
                          v
                +-------------------+
                | Instruction Decode|
                +-------------------+
                    |           |
                    v           v
               +---------+ +---------+
               |RegisterA| |RegisterB|
               +---------+ +---------+
                    \         /
                     \       /
                      v     v
                    +---------+
                    | Selector|
                    +---------+
                          |
                          v
                      +-------+
                      |  ALU  |
                      +-------+
                          |
                          v
                    +-----------+
                    | Carry Flag|
                    +-----------+
                          |
                          v
                      +---------+
                      |  Output |
                      +---------+
```

---

## Instruction Set

| Instruction | Description |
|---|---|
| MOV A, Im | Move immediate value to Register A |
| MOV B, Im | Move immediate value to Register B |
| MOV A, B | Transfer Register B to Register A |
| MOV B, A | Transfer Register A to Register B |
| ADD A, Im | Add immediate value to Register A |
| ADD B, Im | Add immediate value to Register B |
| SUB A, Im | Subtract immediate value from Register A |
| SUB B, Im | Subtract immediate value from Register B |
| IN A | Input to Register A |
| IN B | Input to Register B |
| OUT A | Output Register A |
| OUT B | Output Register B |
| OUT Im | Output immediate value |
| JMP Im | Jump to specified address |
| JNC Im | Conditional jump when carry flag is not set |

---

## Instruction Execution Flow

1. The Program Counter accesses instruction ROM.
2. The instruction is fetched from ROM.
3. The decoder analyzes the opcode.
4. Control signals are generated.
5. Registers and ALU execute the instruction.
6. Carry flag is updated if necessary.
7. The Program Counter updates.
8. Output is reflected on FPGA LEDs.

---

## Clocking Method

This project uses a **clock-enable based synchronous design** instead of generating internal divided clocks directly.

The CPU operates using:

- 100 MHz system clock
- 1 Hz / 10 Hz enable pulse generators
- synchronous register updates

This approach improves timing stability and follows common FPGA design practices.

---

## Research Purpose

Modern processors are often treated as black boxes.  
This project aims to understand processor operation at the hardware level by implementing a simple CPU architecture on FPGA.

Through this research, the following topics are studied:

- CPU architecture
- Sequential logic
- Instruction execution flow
- Register transfer
- ALU operation
- Synchronous digital design
- Timing control
- FPGA implementation flow
- Hardware debugging

---

## Challenges

Several issues were encountered during development:

- Timing mismatches between modules
- Incorrect program counter transitions
- Carry flag control issues
- Clock synchronization problems
- FPGA pin assignment errors
- Unstable behavior caused by internally divided clocks

To solve these problems, the design was improved using:

- synchronous design methodology
- clock-enable control
- waveform analysis
- hardware verification on FPGA

---

## Results

The TD4 CPU successfully executed instructions on FPGA and verified correct operation through LED outputs.

The project improved understanding of:

- Processor architecture
- HDL-based hardware design
- FPGA timing-aware design
- Synchronous circuit implementation
- Hardware debugging techniques

---

## Future Work

Possible future improvements include:

- 8-bit architecture expansion
- Pipeline architecture
- RAM implementation
- UART communication
- Interrupt processing
- Additional instructions
- Higher clock frequency optimization
- Memory-mapped I/O
- Simple assembler support

---

## Repository Structure

```text
TD4_Kodera_Lab/
├── src/            # Verilog source files
├── sim/            # Simulation files
├── constraints/    # FPGA constraint files
├── docs/           # Documentation
└── README.md
```

---

## Author

Created by Gitratter

---

## License

This project is licensed under the MIT License.



