module riscv32_single_cycle(
 input clk,input reset,input [31:0] instruction,input [31:0] mem_rdata,
 output reg [31:0] pc,output [31:0] mem_addr,output [31:0] mem_wdata,
 output mem_we,output mem_re,output [31:0] debug_alu,output [31:0] debug_rs1,
 output [31:0] debug_rs2,output [31:0] debug_wb);
wire [6:0] op=instruction[6:0]; wire [4:0] rs1=instruction[19:15],rs2=instruction[24:20],rd=instruction[11:7];
wire [2:0] f3=instruction[14:12]; wire [6:0] f7=instruction[31:25];
wire regwrite,memread,memwrite,alusrc,branch,jump,jalr; wire [3:0] aluop; wire [2:0] wbsel,branchop;
control_unit cu(op,f3,f7,regwrite,memread,memwrite,alusrc,branch,jump,jalr,aluop,wbsel,branchop);
wire [31:0] a,b; wire [31:0] wb;
wire [31:0] iimm={{20{instruction[31]}},instruction[31:20]};
wire [31:0] simm={{20{instruction[31]}},instruction[31:25],instruction[11:7]};
wire [31:0] bimm={{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0};
wire [31:0] uimm={instruction[31:12],12'b0};
wire [31:0] jimm={{11{instruction[31]}},instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0};
wire [31:0] opb=alusrc ? ((op==7'b0100011)?simm:iimm) : b;
wire [31:0] aluy; alu alu0(a,opb,aluop,aluy);
wire take_branch=(branch && ((branchop==3'b000 && a==b)||(branchop==3'b001 && a!=b)||
 (branchop==3'b100 && $signed(a)<$signed(b))||(branchop==3'b101 && $signed(a)>=$signed(b))||
 (branchop==3'b110 && a<b)||(branchop==3'b111 && a>=b)));
wire [31:0] nextpc=jump?(pc+jimm):jalr?((a+iimm)&32'hfffffffe):take_branch?(pc+bimm):(pc+4);
wire [31:0] wbnext=(wbsel==1)?mem_rdata:(wbsel==2)?uimm:(wbsel==3)?(pc+uimm):(wbsel==4)?(pc+4):aluy;
assign wb=wbnext;
register_file rf(clk,regwrite,rs1,rs2,rd,wb,a,b);
assign mem_addr=aluy;assign mem_wdata=b;assign mem_we=memwrite;assign mem_re=memread;
assign debug_alu=aluy;assign debug_rs1=a;assign debug_rs2=b;assign debug_wb=wbnext;
always @(posedge clk) if(reset) pc<=0; else pc<=nextpc;
endmodule
