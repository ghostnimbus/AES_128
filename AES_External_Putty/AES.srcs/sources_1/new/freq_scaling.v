`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2025 12:11:42
// Design Name: 
// Module Name: freq_scaling
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


module freq_scaling (
    input clk_100M,
    output reg clk_3125KHz
);

reg [4:0] counter = 0; // 5 bits to count up to 31

initial begin
    clk_3125KHz = 0;
end

always @(posedge clk_100M) begin
    if (counter == 5'd15) begin
        counter <= 0;
        clk_3125KHz <= ~clk_3125KHz; // toggle every 16 cycles
    end else begin
        counter <= counter + 1;
    end
end

endmodule

