// Demo program: RISC-V CPU programs the GPU rectangle registers, then issues START.
// GPU base = 0x4000_0000
// X0=80, Y0=60, X1=160, Y1=120, COLOR=F00 (RGB444 red).
module instruction_rom(input [31:0] addr, output reg [31:0] data);
always @* begin
    case (addr[11:2])
        10'd0:  data = 32'h400002B7; // LUI  x5,0x40000
        10'd1:  data = 32'h05000313; // ADDI x6,x0,80
        10'd2:  data = 32'h03C00393; // ADDI x7,x0,60
        10'd3:  data = 32'h0A000413; // ADDI x8,x0,160
        10'd4:  data = 32'h07800493; // ADDI x9,x0,120
        10'd5:  data = 32'hF0000513; // ADDI x10,x0,-256 -> low 12 bits F00
        10'd6:  data = 32'h0062A223; // SW x6,  4(x5) -> X0
        10'd7:  data = 32'h0072A423; // SW x7,  8(x5) -> Y0
        10'd8:  data = 32'h0082A623; // SW x8, 12(x5) -> X1
        10'd9:  data = 32'h0092A823; // SW x9, 16(x5) -> Y1
        10'd10: data = 32'h00A2AA23; // SW x10,20(x5) -> COLOR
        10'd11: data = 32'h00100593; // ADDI x11,x0,1
        10'd12: data = 32'h00B2A023; // SW x11,0(x5) -> START (last)
        10'd13: data = 32'h0000006F; // JAL x0,0 -> stop loop at PC=0x34
        default: data = 32'h00000013;
    endcase
end
endmodule
