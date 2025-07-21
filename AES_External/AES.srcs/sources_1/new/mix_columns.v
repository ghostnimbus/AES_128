`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/02/2025 12:07:29 PM
// Design Name: 
// Module Name: mix_columns
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

module mix_columns (
    input  wire [127:0] state_in,   // AES state input (4x4 bytes)
    output wire [127:0] state_out   // AES state output
);

    // Function to perform multiplication by 2 in GF(2^8)
    function [7:0] xtime;
        input [7:0] b;
        xtime = (b[7]) ? ((b << 1) ^ 8'h1B) : (b << 1);
    endfunction

    // Process each column
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : column_mix
            wire [7:0] s0 = state_in[127 - 32*i -: 8];
            wire [7:0] s1 = state_in[119 - 32*i -: 8];
            wire [7:0] s2 = state_in[111 - 32*i -: 8];
            wire [7:0] s3 = state_in[103 - 32*i -: 8];

            wire [7:0] m0 = xtime(s0) ^ xtime(s1) ^ s1 ^ s2 ^ s3;
            wire [7:0] m1 = s0 ^ xtime(s1) ^ xtime(s2) ^ s2 ^ s3;
            wire [7:0] m2 = s0 ^ s1 ^ xtime(s2) ^ xtime(s3) ^ s3;
            wire [7:0] m3 = xtime(s0) ^ s0 ^ s1 ^ s2 ^ xtime(s3);

            assign state_out[127 - 32*i -: 8] = m0;
            assign state_out[119 - 32*i -: 8] = m1;
            assign state_out[111 - 32*i -: 8] = m2;
            assign state_out[103 - 32*i -: 8] = m3;
        end
    endgenerate

endmodule


