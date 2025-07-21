`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2025 04:04:27 PM
// Design Name: 
// Module Name: tb
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

module tb;

    reg [7:0] in;
    wire [7:0] out;

    inverse_sbox uut (
        .in(in),
        .out(out)
    );

    initial begin
        $dumpfile("inverse_sbox.vcd");
        $dumpvars(0,tb);

        in = 8'h00;
        #10 in = 8'h63;
        #10 in = 8'hED;
        #10 in = 8'h84;
        #10 in = 8'h6B;
        #10 $finish;
    end

endmodule

