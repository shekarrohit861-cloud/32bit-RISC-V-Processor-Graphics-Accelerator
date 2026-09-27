# Phase-1 demonstration

Show these items in Vivado:

1. `nexys_a7_top` RTL hierarchy.
2. `riscv_gpu_soc` hierarchy.
3. RISC-V simulation waveform:
   - pc
   - instruction
   - debug ALU
   - register/debug data
4. GPU waveform:
   - gpu_start
   - gpu_busy
   - gpu_done
   - pixel_valid
   - pixel_x / pixel_y
5. VGA waveform:
   - hsync
   - vsync
   - RGB.

The included instruction ROM contains a graphics-register programming sequence.
For a final report, explain the CPU, MMIO interface, four-lane accelerator,
framebuffer and VGA controller as separate blocks.
