`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/02/2025 12:17:02 PM
// Design Name: 
// Module Name: inverse_sbox
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

module inverse_sbox (
    input  wire [7:0] in,
    output wire [7:0] out
);
    // AES polynomial for GF(2^8)
    localparam AES_POLY = 8'h1B;

    // GF(2^8) multiplication function
    function [7:0] gf_mul;
        input [7:0] a;
        input [7:0] b;
        integer i;
        reg [7:0] p;
        reg [7:0] aa;
        reg [7:0] bb;
    begin
        p = 8'd0;
        aa = a;
        bb = b;
        for (i = 0; i < 8; i = i + 1) begin
            if (bb[0])
                p = p ^ aa;
            if (aa[7])
                aa = (aa << 1) ^ AES_POLY;
            else
                aa = aa << 1;
            bb = bb >> 1;
        end
        gf_mul = p;
    end
    endfunction

    // GF(2^8) exponentiation function (for a^power)
    function [7:0] gf_pow;
        input [7:0] base;
        input [7:0] power;
        reg [7:0] result;
        reg [7:0] b;
        reg [7:0] p;
    begin
        result = 8'd1;
        b = base;
        p = power;
        while (p != 0) begin
            if (p[0])
                result = gf_mul(result, b);
            b = gf_mul(b, b);
            p = p >> 1;
        end
        gf_pow = result;
    end
    endfunction

    // GF(2^8) multiplicative inverse: a^(254)
    function [7:0] gf_inv;
        input [7:0] a;
    begin
        if (a == 0)
            gf_inv = 8'd0; // inverse of 0 is 0 by definition here
        else
            gf_inv = gf_pow(a, 8'd254);
    end
    endfunction

    // Inverse affine transform function
    function [7:0] inverse_affine_transform;
        input [7:0] b;
        integer i;
        reg [7:0] d;
        reg bit;
        reg [7:0] result;
    begin
        d = 8'h05; // constant
        result = 8'd0;
        for (i = 0; i < 8; i = i + 1) begin
            bit = ((b[(i+2) % 8]) ^ (b[(i+5) % 8]) ^ (b[(i+7) % 8]) ^ (d[i]));
            result[i] = bit;
        end
        inverse_affine_transform = result;
    end
    endfunction

    wire [7:0] scrambled;
    wire [7:0] inv;

    assign scrambled = inverse_affine_transform(in);
    assign inv = gf_inv(scrambled);

    assign out = inv;

endmodule
