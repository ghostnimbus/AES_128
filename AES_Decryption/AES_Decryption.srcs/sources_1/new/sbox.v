
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2025 04:37:05 PM
// Design Name: 
// Module Name: aes_sbox
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

`timescale 1ns / 1ps

module sbox (
    input  wire [7:0] in,
    output reg  [7:0] out
);

    reg [7:0] inverse;
    integer i, j;

    // GF(2^8) Multiplication
    function [7:0] gf_mul;
        input [7:0] a, b;
        reg [7:0] p;
        integer k;
        begin
            p = 0;
            for (k = 0; k < 8; k = k + 1) begin
                if (b[0])
                    p = p ^ a;
                if (a[7])
                    a = (a << 1) ^ 8'h1B;
                else
                    a = a << 1;
                b = b >> 1;
            end
            gf_mul = p;
        end
    endfunction

    // Main combinational logic
    always @(*) begin
        // Step 1: Find multiplicative inverse in GF(2^8)
        if (in == 8'h00) begin
            inverse = 8'h00;
        end else begin
            inverse = 8'h00;
            for (i = 1; i < 256; i = i + 1) begin
                if (gf_mul(in, i[7:0]) == 8'h01) begin
                    inverse = i[7:0];
                end
            end
        end

        // Step 2: Apply affine transformation
        out[0] = inverse[0] ^ inverse[4] ^ inverse[5] ^ inverse[6] ^ inverse[7] ^ 1'b1;
        out[1] = inverse[1] ^ inverse[5] ^ inverse[6] ^ inverse[7] ^ inverse[0] ^ 1'b1;
        out[2] = inverse[2] ^ inverse[6] ^ inverse[7] ^ inverse[0] ^ inverse[1] ^ 1'b0;
        out[3] = inverse[3] ^ inverse[7] ^ inverse[0] ^ inverse[1] ^ inverse[2] ^ 1'b0;
        out[4] = inverse[4] ^ inverse[0] ^ inverse[1] ^ inverse[2] ^ inverse[3] ^ 1'b0;
        out[5] = inverse[5] ^ inverse[1] ^ inverse[2] ^ inverse[3] ^ inverse[4] ^ 1'b1;
        out[6] = inverse[6] ^ inverse[2] ^ inverse[3] ^ inverse[4] ^ inverse[5] ^ 1'b1;
        out[7] = inverse[7] ^ inverse[3] ^ inverse[4] ^ inverse[5] ^ inverse[6] ^ 1'b0;
    end

endmodule

