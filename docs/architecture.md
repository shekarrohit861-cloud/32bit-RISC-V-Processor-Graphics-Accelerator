# Architecture

## CPU
32-bit RV32I single-cycle processor:
- 32 x 32-bit registers, x0 hardwired to zero
- PC
- instruction ROM
- ALU
- branch comparator
- load/store datapath
- immediate generator
- control unit

Implemented instruction families:
- LUI, AUIPC
- ADDI, ANDI, ORI, XORI, SLTI, SLTIU
- SLLI, SRLI, SRAI
- ADD, SUB, AND, OR, XOR, SLT, SLTU, SLL, SRL, SRA
- LW, SW
- BEQ, BNE, BLT, BGE, BLTU, BGEU
- JAL, JALR

## GPU programming model

GPU registers are mapped at 0x40000000:

0x40000000 CONTROL: bit 0 = start
0x40000004 X0
0x40000008 Y0
0x4000000C X1
0x40000010 Y1
0x40000014 COLOR: RGB444
0x40000018 STATUS: bit 0 busy, bit 1 done

A start command draws a filled rectangle from (X0,Y0) through (X1,Y1).
The accelerator advances four pixels per clock using four logical processing
lanes.

## Video
640x480 active video with standard VGA-style timing:
horizontal total 800, vertical total 525.
The framebuffer stores RGB444 pixels.
