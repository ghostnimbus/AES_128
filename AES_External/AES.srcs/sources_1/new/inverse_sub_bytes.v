`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/02/2025 12:19:34 PM
// Design Name: 
// Module Name: inverse_sub_bytes
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

module inverse_sub_bytes (
    input  wire [127:0] state_in,
    output wire [127:0] state_out
);
    
    inverse_sbox s0(.in(state_in[127:120]), .out(state_out[127:120]));
    inverse_sbox s4(.in(state_in[119:112]), .out(state_out[119:112]));
    inverse_sbox s8(.in(state_in[111:104]), .out(state_out[111:104]));
    inverse_sbox s12(.in(state_in[103:96]), .out(state_out[103:96]));
    inverse_sbox s1(.in(state_in[95:88]), .out(state_out[95:88]));
    inverse_sbox s5(.in(state_in[87:80]), .out(state_out[87:80]));
    inverse_sbox s9(.in(state_in[79:72]), .out(state_out[79:72]));
    inverse_sbox s13(.in(state_in[71:64]), .out(state_out[71:64]));
    inverse_sbox s2(.in(state_in[63:56]), .out(state_out[63:56]));
    inverse_sbox s6(.in(state_in[55:48]), .out(state_out[55:48]));
    inverse_sbox s10(.in(state_in[47:40]), .out(state_out[47:40]));
    inverse_sbox s14(.in(state_in[39:32]), .out(state_out[39:32]));
    inverse_sbox s3(.in(state_in[31:24]), .out(state_out[31:24]));
    inverse_sbox s7(.in(state_in[23:16]), .out(state_out[23:16]));
    inverse_sbox s11(.in(state_in[15:8]), .out(state_out[15:8]));
    inverse_sbox s15(.in(state_in[7:0]), .out(state_out[7:0]));
    
endmodule