# 32-bit RISC-V Processor with Parallel Graphics Accelerator

## Overview

This project presents the design and FPGA implementation of a **32-bit RISC-V processor integrated with a parallel graphics accelerator** for hardware-based graphics processing and VGA display output.

The system combines a custom single-cycle RISC-V processor with a memory-mapped graphics accelerator, framebuffer, and VGA controller. The processor executes instructions stored in instruction memory and communicates with the graphics subsystem through memory-mapped control registers.

The complete design is targeted for the **Xilinx Artix-7 based Nexys A7 FPGA board**.

---

Key Features

- 32-bit RISC-V processor
- Single-cycle processor architecture
- RISC-V ALU and control unit
- Register file implementation
- Instruction ROM
- Data memory
- Memory-mapped GPU interface
- Parallel graphics accelerator
- Framebuffer-based graphics storage
- VGA display controller
- FPGA implementation using Xilinx Vivado
- Nexys A7 / Artix-7 target platform

---

## System Architecture

The overall system consists of the following major blocks:

```text
+----------------------+
|  RISC-V Processor    |
|       32-bit CPU     |
+----------+-----------+
           |
           v
+----------------------+
| System Bus /         |
| Memory-Mapped I/O    |
+----------+-----------+
           |
     +-----+-----+
     |           |
     v           v
+---------+   +-----------+
|Instr.   |   |Data       |
|Memory   |   |Memory     |
+---------+   +-----------+
     |
     v
+----------------------+
| GPU MMIO Interface   |
+----------+-----------+
           |
           v
+----------------------+
| Parallel Graphics    |
| Accelerator           |
+----------+-----------+
           |
           v
+----------------------+
| Frame Buffer         |
+----------+-----------+
           |
           v
+----------------------+
| VGA Controller       |
+----------+-----------+
           |
           v
+----------------------+
| VGA Display          |
+----------------------+
```

## Processor Architecture

The processor is implemented as a **32-bit RISC-V single-cycle processor**.

### Main CPU Components

- **Program Counter (PC)** — Stores the address of the current instruction and controls instruction sequencing.
- **Instruction ROM** — Stores the RISC-V instructions executed by the processor.
- **Control Unit** — Decodes instructions and generates the required control signals.
- **ALU** — Performs arithmetic and logical operations required by the processor.
- **Register File** — Provides the RISC-V general-purpose registers used during instruction execution.
- **Data Memory** — Provides memory for reading and writing processor data.

### Graphics Accelerator

The graphics subsystem performs graphics-related operations using dedicated hardware.

It includes:

- **GPU MMIO Interface** — Provides memory-mapped communication between the processor and graphics subsystem.
- **Parallel Graphics Accelerator** — Performs graphics operations using dedicated hardware.
- **Frame Buffer** — Stores pixel data for display generation.
- **VGA Controller** — Generates VGA timing and RGB signals for display output.

### FPGA Implementation

The design is targeted for the **Xilinx Artix-7 based Nexys A7 FPGA board** and is developed and simulated using **Xilinx Vivado**.
## Project Structure

```text
32bit-RISC-V-Processor-Graphics-Accelerator/
│
├── constraints/
│   └── nexys_a7_100t.xdc
│
├── docs/
│   ├── architecture.md
│   └── phase1_demo.md
│
├── rtl/
│   ├── gpu/
│   │   ├── gpu_mmio.v
│   │   └── parallel_graphics_accelerator.v
│   │
│   ├── memory/
│   │   ├── data_memory.v
│   │   └── instruction_rom.v
│   │
│   ├── peripherals/
│   │   ├── framebuffer.v
│   │   └── vga_controller.v
│   │
│   └── riscv/
│       └── alu.v
│
├── sim/
│   ├── tb_riscv_gpu_soc.v
│   └── tb_riscv_gpu_soc.v
│
├── vivado/
│   ├── create_project.tcl
│   └── run_sim.tcl
│
└── README.md
```

## Design Methodology

The system follows a hardware-software co-design approach in which the RISC-V processor controls the graphics subsystem through a memory-mapped interface.

The major processing flow is:

1. The Program Counter generates the address of the current instruction.
2. The Instruction ROM provides the corresponding RISC-V instruction.
3. The Control Unit decodes the instruction and generates control signals.
4. The ALU performs the required arithmetic or logical operation.
5. The Register File provides and stores processor operands and results.
6. Data Memory handles processor data access.
7. Graphics commands are communicated through the GPU memory-mapped interface.
8. The Parallel Graphics Accelerator processes graphics operations.
9. Generated pixel information is stored in the Frame Buffer.
10. The VGA Controller reads the pixel information and generates the VGA output signals.

## Graphics Processing Pipeline

```text
RISC-V Instruction
        |
        v
   GPU MMIO Access
        |
        v
Graphics Accelerator
        |
        v
    Frame Buffer
        |
        v
   VGA Controller
        |
        v
    VGA Output
```

## Simulation

The design includes simulation testbenches for verifying the interaction between the RISC-V processor and graphics subsystem.

Simulation can be performed using **Xilinx Vivado**.

The simulation flow is:

```text
RTL Source Files
       |
       v
Simulation Testbench
       |
       v
Vivado Simulator
       |
       v
Waveform Analysis
       |
       v
Functional Verification
```

The important signals that can be observed during simulation include:

- Program Counter (PC)
- Instruction
- ALU inputs and output
- Control signals
- Register operations
- Data memory access
- GPU MMIO transactions
- Graphics accelerator control signals
- Frame buffer activity
- VGA timing signals

## FPGA Implementation

The design is intended for implementation on the **Nexys A7 FPGA board based on the Xilinx Artix-7 FPGA**.

The XDC constraint file defines the required FPGA pin assignments and clock/reset connections for the top-level design.

### Implementation Flow

```text
RTL Design
    |
    v
Synthesis
    |
    v
Implementation
    |
    v
Timing Analysis
    |
    v
Bitstream Generation
    |
    v
FPGA Programming
    |
    v
VGA Display Output
```

## Software and Hardware Tools

### Hardware

- Xilinx Artix-7 FPGA
- Digilent Nexys A7 FPGA board
- VGA-compatible display
- VGA connection

### Software

- Xilinx Vivado
- Verilog HDL
- Git
- GitHub
- GitHub Desktop

## Verification

The design is verified at the RTL level using simulation and waveform analysis.

The verification process focuses on:

- Correct instruction execution
- ALU operation
- Control signal generation
- Register and memory operations
- GPU memory-mapped communication
- Graphics accelerator operation
- Frame buffer operation
- VGA timing generation

## Key Design Concepts

### 32-bit RISC-V Processor

A 32-bit RISC-V processor is used as the main processing unit. Its modular architecture makes it suitable for educational FPGA implementation and integration with custom hardware accelerators.

### Memory-Mapped GPU Interface

The graphics accelerator is accessed through memory-mapped registers. This allows the RISC-V processor to communicate with the graphics hardware using standard memory access operations.

### Parallel Graphics Acceleration

Graphics-related processing is delegated to dedicated hardware instead of relying entirely on sequential CPU execution. This provides a hardware-based approach for accelerating graphics operations.

### Frame Buffer

The frame buffer stores pixel information generated by the graphics subsystem. The VGA controller uses this pixel information to generate the display output.

## Expected Output

The completed FPGA system is designed to demonstrate hardware-based graphics generation through the following path:

```text
RISC-V Processor
       ↓
GPU Control
       ↓
Parallel Graphics Accelerator
       ↓
Frame Buffer
       ↓
VGA Controller
       ↓
VGA Display
```

## Future Scope

Possible extensions to the project include:

- Support for additional graphics primitives
- Improved graphics processing throughput
- More advanced GPU command interfaces
- Increased frame-buffer capacity
- Additional display resolutions
- Hardware performance optimization
- Power and resource utilization optimization
- Support for more RISC-V instructions and peripherals

## Conclusion

This project demonstrates the integration of a custom 32-bit RISC-V processor with a dedicated parallel graphics accelerator on an FPGA platform.

The architecture combines processor design, memory systems, hardware acceleration, frame-buffer management, and VGA display generation into a single FPGA-based system.

The project provides practical experience in **RISC-V architecture, Verilog HDL, FPGA design, memory-mapped hardware interfaces, graphics acceleration, RTL simulation, and hardware implementation using Xilinx Vivado**.

## Author

**Rohit Shekar**

Engineering Student — Electronics / VLSI

### Project

**32-bit RISC-V Processor with Parallel Graphics Accelerator**

**Target Platform:** Xilinx Artix-7 / Nexys A7 FPGA
