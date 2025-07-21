`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 11:29:42 PM
// Design Name: 
// Module Name: add_round_key
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

module add_round_key (
    input  wire [127:0] state_in,     
    input  wire [127:0] roundkey_in,  
    output wire [127:0] state_out     
);

    assign state_out = state_in ^ roundkey_in; //XOR Operation

endmodule

