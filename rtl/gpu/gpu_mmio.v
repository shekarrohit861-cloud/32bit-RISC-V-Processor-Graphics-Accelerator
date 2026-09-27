// GPU memory-mapped register block.
// Base address: 0x4000_0000
//   +0x00  START command (write 1)
//   +0x04  X0
//   +0x08  Y0
//   +0x0C  X1
//   +0x10  Y1
//   +0x14  COLOR (RGB444)
//   +0x18  STATUS: bit0=busy, bit1=done
module gpu_mmio(
    input clk,
    input reset,
    input we,
    input [31:0] addr,
    input [31:0] wdata,
    output start,
    output reg [9:0] x0, y0, x1, y1,
    output reg [11:0] color,
    input busy,
    input done,
    output [31:0] status
);

// A combinational command pulse is important: the GPU sees START on the
// same clock edge as the CPU's MMIO write, instead of depending on another
// registered pulse being propagated through the block.
assign start = we && (addr[5:2] == 4'd0) && wdata[0] && !busy;

always @(posedge clk) begin
    if (reset) begin
        x0    <= 10'd0;
        y0    <= 10'd0;
        x1    <= 10'd0;
        y1    <= 10'd0;
        color <= 12'h000;
    end else if (we) begin
        case (addr[5:2])
            4'd1: x0    <= wdata[9:0];
            4'd2: y0    <= wdata[9:0];
            4'd3: x1    <= wdata[9:0];
            4'd4: y1    <= wdata[9:0];
            4'd5: color <= wdata[11:0];
            default: ;
        endcase
    end
end

assign status = {30'd0, done, busy};
endmodule
