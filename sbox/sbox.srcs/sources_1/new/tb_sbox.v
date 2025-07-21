`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2025 03:34:40 PM
// Design Name: 
// Module Name: tb_sbox
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


module tb_sbox;

reg [7:0] in;
wire [7:0] out;

    sbox uut (
        .in(in),
        .out(out)
    );

    
    initial 
    begin
        $dumpfile("tb_sbox.vcd");     // VCD file name
        $dumpvars(0, tb_sbox);        // Dump all variables in this module
        
        in = 8'h00;
        #10 in = 8'h53;
        #10 in = 8'h7C;
        #10 in = 8'h09;
        #10 in = 8'h1F;
        #20 $finish;
    end

endmodule

