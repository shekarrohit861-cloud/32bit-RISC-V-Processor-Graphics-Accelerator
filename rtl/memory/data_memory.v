module data_memory(input clk,input we,input re,input [31:0] addr,input [31:0] wdata,output reg [31:0] rdata);
reg [31:0] mem[0:255]; integer i;
initial begin for(i=0;i<256;i=i+1) mem[i]=0; end
always @(posedge clk) begin
 if(we && addr[31:10]==0) mem[addr[9:2]]<=wdata;
 if(re && addr[31:10]==0) rdata<=mem[addr[9:2]]; else rdata<=0;
end
endmodule
