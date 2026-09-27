module register_file(input clk,input we,input [4:0] rs1,rs2,rd,input [31:0] wd,output [31:0] rd1,rd2);
reg [31:0] r[0:31]; integer i;
assign rd1=(rs1==0)?0:r[rs1]; assign rd2=(rs2==0)?0:r[rs2];
always @(posedge clk) begin if(we && rd!=0) r[rd]<=wd; r[0]<=0; end
initial begin for(i=0;i<32;i=i+1) r[i]=0; end
endmodule
