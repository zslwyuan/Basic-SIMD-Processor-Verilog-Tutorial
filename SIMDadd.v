`timescale 1ns / 1ps

module SIMDadd(
        input [15:0] A,
        input [15:0] B,
        input H,
        input O,
        input Q,
        input sub,
        output [15:0] Cout
    );
    wire [15:0] B_real = sub?(~B):B;
    wire [4:0] C0 = A[3:0]   +  B_real[3:0]    + sub;
    wire [4:0] C1 = A[7:4]   +  B_real[7:4]    + (C0[4]&(O|H)) + (Q&sub);
    wire [4:0] C2 = A[11:8]  +  B_real[11:8]   + (C1[4]&H)     + ((Q|O)&sub);
    wire [4:0] C3 = A[15:12] +  B_real[15:12]  + (C2[4]&(O|H)) + (Q&sub);
    
    assign Cout = {C3[3:0],C2[3:0],C1[3:0],C0[3:0]};
    
    
endmodule
