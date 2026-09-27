module control_unit(
 input [6:0] opcode,input [2:0] funct3,input [6:0] funct7,
 output reg regwrite,memread,memwrite,alusrc,branch,jump,jalr,
 output reg [3:0] aluop,output reg [2:0] wbsel,output reg [2:0] branchop);
always @* begin
 regwrite=0;memread=0;memwrite=0;alusrc=0;branch=0;jump=0;jalr=0;
 aluop=0;wbsel=0;branchop=0;
 case(opcode)
 7'b0110011: begin regwrite=1; case({funct7,funct3})
 10'b0000000_000:aluop=0;10'b0100000_000:aluop=1;
 10'b0000000_111:aluop=2;10'b0000000_110:aluop=3;10'b0000000_100:aluop=4;
 10'b0000000_010:aluop=5;10'b0000000_011:aluop=6;10'b0000000_001:aluop=7;
 10'b0000000_101:aluop=8;10'b0100000_101:aluop=9; default:aluop=0; endcase end
 7'b0010011: begin regwrite=1;alusrc=1;case(funct3)
 3'b000:aluop=0;3'b111:aluop=2;3'b110:aluop=3;3'b100:aluop=4;
 3'b010:aluop=5;3'b011:aluop=6;3'b001:aluop=7;
 3'b101:aluop=funct7[5]?9:8;default:aluop=0;endcase end
 7'b0000011:begin regwrite=1;memread=1;alusrc=1;wbsel=1;end
 7'b0100011:begin memwrite=1;alusrc=1;end
 7'b1100011:begin branch=1;branchop=funct3;aluop=1;end
 7'b0110111:begin regwrite=1;wbsel=2;end
 7'b0010111:begin regwrite=1;wbsel=3;end
 7'b1101111:begin regwrite=1;jump=1;wbsel=4;end
 7'b1100111:begin regwrite=1;jalr=1;alusrc=1;wbsel=4;end
 endcase
end
endmodule
