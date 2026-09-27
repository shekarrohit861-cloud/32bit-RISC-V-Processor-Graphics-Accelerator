`timescale 1ns/1ps
module tb_riscv_gpu_soc;
reg clk = 1'b0;
reg reset = 1'b1;
wire hs, vs;
wire [3:0] r, g, b;
wire [31:0] pc, instr, status;
wire gs, gb, gd, pv;

riscv_gpu_soc dut(
    .clk(clk), .reset(reset), .hsync(hs), .vsync(vs),
    .vga_r(r), .vga_g(g), .vga_b(b),
    .debug_pc(pc), .debug_instruction(instr), .debug_gpu_status(status),
    .debug_gpu_start(gs), .debug_gpu_busy(gb), .debug_gpu_done(gd),
    .debug_pixel_valid(pv)
);

always #5 clk = ~clk; // 100 MHz

integer pixel_count;
always @(posedge clk) begin
    if (pv) pixel_count = pixel_count + 1;
    if (gs) $display("%0t GPU START: x0=%0d y0=%0d x1=%0d y1=%0d color=%03h", $time, dut.gx0, dut.gy0, dut.gx1, dut.gy1, dut.gcolor);
    if (gd) $display("%0t GPU DONE: pixels generated=%0d", $time, pixel_count);
end

initial begin
    pixel_count = 0;
    $dumpfile("riscv_gpu_soc.vcd");
    $dumpvars(0, tb_riscv_gpu_soc);

    #100 reset = 1'b0;

    // Rectangle is 81x65 = 5265 pixels, so at one pixel/100-MHz clock
    // GPU completion is about 52.7 us after START.
    #100000;

    $display("FINAL: pc=%h instr=%h status=%h start=%b busy=%b done=%b pixel_valid=%b VGA=%h%h%h",
             pc, instr, status, gs, gb, gd, pv, r, g, b);

    if (pc !== 32'h00000034)
        $display("ERROR: CPU did not reach intentional stop loop PC=0x34");
    if (pixel_count < 5265)
        $display("ERROR: Expected at least 5265 rectangle pixels, got %0d", pixel_count);
    if (gb !== 1'b0)
        $display("ERROR: GPU still busy at end of simulation");
    else
        $display("PASS: CPU reached stop loop and GPU completed rectangle");

    $finish;
end
endmodule
