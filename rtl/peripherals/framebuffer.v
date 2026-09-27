// 320x240 RGB444 framebuffer.
// One write port is used by the GPU and one read port is used by VGA.
// Both ports use the same 100 MHz clock. VGA advances its address every
// fourth clock, giving the required 25 MHz pixel rate.
module framebuffer(
    input        clk,
    input        we,
    input [8:0]  wx,
    input [7:0]  wy,
    input [11:0] wdata,
    input [8:0]  rx,
    input [7:0]  ry,
    output reg [11:0] rdata
);
    localparam DEPTH = 320*240;
    reg [11:0] mem [0:DEPTH-1];
    integer i;

    // Power-up black framebuffer for deterministic simulation and FPGA init.
    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = 12'h000;
        rdata = 12'h000;
    end

    always @(posedge clk) begin
        if (we && wx < 320 && wy < 240)
            mem[wy*320 + wx] <= wdata;

        if (rx < 320 && ry < 240)
            rdata <= mem[ry*320 + rx];
        else
            rdata <= 12'h000;
    end
endmodule
