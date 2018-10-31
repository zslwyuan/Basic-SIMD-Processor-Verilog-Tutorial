`timescale 1ns / 1ps

module SIMDshifter(
        input [15:0] shiftinput,
        input H,
        input O,
        input Q,
        input left,
        output [15:0] shiftoutput
    );
    
    wire [14:0] left_shift =  shiftinput[14:0];
    wire [14:0] right_shift =  shiftinput[15:1];
    wire [15:0] shiftoutput_tmp = left?{left_shift,1'b0}:{1'b0,right_shift};
    assign shiftoutput[3:0]   = {(left|H|O)&shiftoutput_tmp[3],   shiftoutput_tmp[2:0]};
    assign shiftoutput[7:4]   = {(left|H)&shiftoutput_tmp[7],     shiftoutput_tmp[6:5],    (!left|H|O)&shiftoutput_tmp[4]};
    assign shiftoutput[11:8]  = {(left|H|O)&shiftoutput_tmp[11],  shiftoutput_tmp[10:9],   (!left|H)&shiftoutput_tmp[8]};
    assign shiftoutput[15:12] = {(left|H)&shiftoutput_tmp[15],    shiftoutput_tmp[14:13],  (!left|H|O)&shiftoutput_tmp[12]};
    
    
    
endmodule
