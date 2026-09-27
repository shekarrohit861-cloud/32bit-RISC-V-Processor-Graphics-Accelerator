// Nexys A7-100T top level.
// CPU_RESETN is active-low on the board, so it is inverted for the SoC reset.
module nexys_a7_top(
    input        CLK100MHZ,
    input        CPU_RESETN,
    output       VGA_HS,
    output       VGA_VS,
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B
);
    wire reset = ~CPU_RESETN;

    wire [31:0] debug_pc;
    wire [31:0] debug_instruction;
    wire [31:0] debug_gpu_status;
    wire debug_gpu_start, debug_gpu_busy, debug_gpu_done, debug_pixel_valid;

    riscv_gpu_soc soc(
        .clk(CLK100MHZ),
        .reset(reset),
        .hsync(VGA_HS),
        .vsync(VGA_VS),
        .vga_r(VGA_R),
        .vga_g(VGA_G),
        .vga_b(VGA_B),
        .debug_pc(debug_pc),
        .debug_instruction(debug_instruction),
        .debug_gpu_status(debug_gpu_status),
        .debug_gpu_start(debug_gpu_start),
        .debug_gpu_busy(debug_gpu_busy),
        .debug_gpu_done(debug_gpu_done),
        .debug_pixel_valid(debug_pixel_valid)
    );
endmodule
