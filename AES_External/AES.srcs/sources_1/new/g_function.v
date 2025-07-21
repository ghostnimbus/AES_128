`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/02/2025 12:05:29 PM
// Design Name: 
// Module Name: g_function
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


module g_function(input [31:0]word_in,[7:0] Rcon, output [31:0]word_out);
wire [31:0]intr_word;
wire [31:0]s_word;

assign intr_word = {word_in[23:16],word_in[15:8],word_in[7:0],word_in[31:24]}; //rotword operation.

sbox s1(.in(intr_word[31:24]), .out(s_word[31:24]));
sbox s2(.in(intr_word[23:16]), .out(s_word[23:16]));
sbox s3(.in(intr_word[15:8]), .out(s_word[15:8]));
sbox s4(.in(intr_word[7:0]), .out(s_word[7:0]));


assign word_out = s_word ^ {Rcon, 24'b0}; 

endmodule

