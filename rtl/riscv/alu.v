module alu(input [31:0] a,input [31:0] b,input [3:0] op,output reg [31:0] y);
always @* begin
 case(op)
 4'h0:y=a+b; 4'h1:y=a-b; 4'h2:y=a&b; 4'h3:y=a|b;
 4'h4:y=a^b; 4'h5:y=($signed(a)<$signed(b))?32'd1:32'd0;
 4'h6:y=(a<b)?32'd1:32'd0; 4'h7:y=a<<b[4:0];
 4'h8:y=a>>b[4:0]; 4'h9:y=$signed(a)>>>b[4:0];
 default:y=0;
 endcase
end
endmodule
