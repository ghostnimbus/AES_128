`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/02/2025 12:09:17 PM
// Design Name: 
// Module Name: shift_rows
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

module shift_rows (
    input  wire [127:0] state_in,
    output wire [127:0] state_out
);

    // Row 0: No shift
    // Row 1: Shift left by 1
    // Row 2: Shift left by 2
    // Row 3: Shift left by 3

    assign state_out = {
        state_in[127:120], state_in[87:80], state_in[47:40], state_in[7:0],   // Row 0
        state_in[95:88], state_in[55:48], state_in[15:8], state_in[103:96],   // Row 1 (shifted by 1)
        state_in[63:56], state_in[23:16], state_in[111:104], state_in[71:64],   // Row 2 (shifted by 2)
        state_in[31:24], state_in[119:112], state_in[79:72], state_in[39:32]      // Row 3 (shifted by 3)
    };

endmodule

