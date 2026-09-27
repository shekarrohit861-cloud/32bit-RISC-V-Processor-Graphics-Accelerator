`timescale 1ns/1ps
module tb_nexys_a7_top;
    reg CLK100MHZ = 1'b0;
    reg CPU_RESETN = 1'b0;
    wire VGA_HS, VGA_VS;
    wire [3:0] VGA_R, VGA_G, VGA_B;

    nexys_a7_top dut(
        .CLK100MHZ(CLK100MHZ),
        .CPU_RESETN(CPU_RESETN),
        .VGA_HS(VGA_HS), .VGA_VS(VGA_VS),
        .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B)
    );

    always #5 CLK100MHZ = ~CLK100MHZ;

    initial begin
        $dumpfile("nexys_a7.vcd");
        $dumpvars(0, tb_nexys_a7_top);
        #100;
        CPU_RESETN = 1'b1;
        // Rectangle is 81 x 61 = 4941 pixels at one pixel / 100 MHz.
        // Allow plenty of time for completion and observe VGA timing.
        #1500000;
        $finish;
    end
endmodule
