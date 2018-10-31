`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.05.2018 16:15:26
// Design Name: 
// Module Name: Multiply
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SIMDmultiply(
        input [15:0] mulinputa,
        input [15:0] mulinputb,
        input H,
        input O,
        input Q,
        output [15:0] muloutput
    );
    
    
    wire [15:0] sel0 = H?16'hFFFF:(O?16'h00FF:16'h000F);
    wire [15:0] sel1 = H?16'hFFFF:(O?16'h00FF:16'h00F0);
    wire [15:0] sel2 = H?16'hFFFF:(O?16'hFF00:16'h0F00);
    wire [15:0] sel3 = H?16'hFFFF:(O?16'hFF00:16'hF000);
    
    wire [15:0] a0 = (mulinputb[0]?mulinputa:16'h0000)&sel0;
    wire [15:0] a1 = (mulinputb[1]?mulinputa:16'h0000)&sel0;
    wire [15:0] a2 = (mulinputb[2]?mulinputa:16'h0000)&sel0;
    wire [15:0] a3 = (mulinputb[3]?mulinputa:16'h0000)&sel0;
    wire [15:0] a4 = (mulinputb[4]?mulinputa:16'h0000)&sel1;
    wire [15:0] a5 = (mulinputb[5]?mulinputa:16'h0000)&sel1;
    wire [15:0] a6 = (mulinputb[6]?mulinputa:16'h0000)&sel1;
    wire [15:0] a7 = (mulinputb[7]?mulinputa:16'h0000)&sel1;
    wire [15:0] a8 = (mulinputb[8]?mulinputa:16'h0000)&sel2;
    wire [15:0] a9 = (mulinputb[9]?mulinputa:16'h0000)&sel2;
    wire [15:0] a10 = (mulinputb[10]?mulinputa:16'h0000)&sel2;
    wire [15:0] a11 = (mulinputb[11]?mulinputa:16'h0000)&sel2;
    wire [15:0] a12 = (mulinputb[12]?mulinputa:16'h0000)&sel3;
    wire [15:0] a13 = (mulinputb[13]?mulinputa:16'h0000)&sel3;
    wire [15:0] a14 = (mulinputb[14]?mulinputa:16'h0000)&sel3;
    wire [15:0] a15 = (mulinputb[15]?mulinputa:16'h0000)&sel3;
    
    wire [15:0] tmp0,tmp1,tmp2,tmp3;
    wire [15:0] tmp00,tmp11;
    wire [15:0] tmp000;
    
    assign tmp0  = a0   + (a1<<1)   +  (a2<<2)    +  (a3<<3);
    assign tmp1  = a4   + (a5<<1)   +  (a6<<2)    +  (a7<<3);
    assign tmp2  = a8   + (a9<<1)   +  (a10<<2)   +  (a11<<3);
    assign tmp3  = a12  + (a13<<1)  +  (a14<<2)   +  (a15<<3);
    
    assign tmp00 = tmp0 + (tmp1<<4);
    assign tmp11 = tmp2 + (tmp3<<4);
   
    assign tmp000 = tmp00 + (tmp11<<8); 
    
    wire [3:0] tmp1h,tmp1o,tmp1q;
    wire [3:0] tmp2h,tmp2o,tmp2q;
    wire [3:0] tmp3h,tmp3o,tmp3q;
    
    assign muloutput[3:0] = tmp0[3:0];
    
    assign tmp1h = tmp000[7:4];    
    assign tmp2h = tmp000[11:8];     
    assign tmp3h = tmp000[15:12];    
    
    assign tmp1o = tmp00[7:4];    
    assign tmp2o = tmp11[11:8];    
    assign tmp3o = tmp11[15:12];
    
    assign tmp1q = tmp1[7:4];    
    assign tmp2q = tmp2[11:8];
    assign tmp3q = tmp3[15:12];
    
    assign muloutput[7:4]   = H?tmp1h:(O?tmp1o:tmp1q);
    assign muloutput[11:8]  = H?tmp2h:(O?tmp2o:tmp2q);
    assign muloutput[15:12] = H?tmp3h:(O?tmp3o:tmp3q);
    
    
endmodule

