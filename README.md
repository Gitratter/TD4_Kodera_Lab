# TD4 CPU on FPGA

FPGA-based implementation of a TD4 4-bit CPU designed to understand processor architecture, instruction execution flow, and digital circuit design.

---

## Overview

This project implements a 4-bit TD4 CPU on FPGA.  
The purpose of this research is to understand how a processor works internally by designing and debugging the CPU architecture from scratch.

The CPU executes instructions through hardware components such as registers, an ALU, a program counter, and control logic.  
By implementing the design on FPGA, the project also focuses on practical hardware verification and debugging.

---

## Features

- 4-bit TD4 CPU architecture
- FPGA implementation
- Instruction fetch and execution
- Register and ALU design
- Program counter control
- Clock-synchronized operation
- LED output verification
- Hardware-level debugging

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
- Instruction Decoder
- ROM
- Control Circuit

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
     |         |
     v         v
+---------+ +---------+
|RegisterA| |RegisterB|
+---------+ +---------+
      \       /
       \     /
        v   v
      +-------+
      |  ALU  |
      +-------+
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
| ADD A, Im | Add immediate value to Register A |
| ADD B, Im | Add immediate value to Register B |
| OUT Im | Output immediate value |
| JMP Im | Jump to specified address |

---

## Instruction Execution Flow

1. The Program Counter accesses instruction ROM.
2. The instruction is fetched.
3. The instruction decoder analyzes the opcode.
4. Registers and ALU execute the operation.
5. The Program Counter updates to the next address.
6. Output is reflected on LEDs.

---

## Research Purpose

Modern processors are often treated as black boxes.  
This project aims to understand processor operation at the hardware level by implementing a simple CPU architecture on FPGA.

Through this research, the following topics are studied:

- Digital circuit design
- Sequential logic
- Instruction execution flow
- CPU architecture
- Timing control
- Hardware debugging

---

## Challenges

During development, several problems were encountered:

- Timing mismatch between modules
- Incorrect state transitions
- Program counter control errors
- FPGA pin assignment issues
- Hardware debugging difficulties

These issues were solved through waveform analysis and repeated hardware verification.

---

## Results

The TD4 CPU successfully executed instructions on FPGA and verified correct operation through LED outputs.

The project improved understanding of:

- Processor architecture
- HDL-based hardware design
- FPGA implementation flow
- Hardware debugging techniques

---

## Future Work

Possible future improvements include:

- Pipeline architecture
- Additional instructions
- UART communication
- Memory expansion
- Interrupt processing
- Higher clock frequency optimization

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

This project is for educational and research purposes.



