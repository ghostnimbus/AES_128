`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2025 14:34:12
// Design Name: 
// Module Name: uart_to_aes_input
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

module uart_to_aes_input (
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  uart_data,    // 8-bit UART data
    input  wire        uart_valid,   // High when uart_data is valid
    output reg  [127:0] key_out,
    output reg  [127:0] plaintext_out,
    output reg         data_ready
);

    reg [5:0] byte_count;  // Need to count up to 32
    reg [127:0] key_buffer;
    reg [127:0] plaintext_buffer;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            byte_count       <= 0;
            key_buffer       <= 0;
            plaintext_buffer <= 0;
            key_out          <= 0;
            plaintext_out    <= 0;
            data_ready       <= 0;
        end else begin
            data_ready <= 0;

            if (uart_valid && byte_count < 32) begin
                if (byte_count < 16) begin
                    key_buffer <= {key_buffer[119:0], uart_data};
                end else begin
                    plaintext_buffer <= {plaintext_buffer[119:0], uart_data};
                end
                byte_count <= byte_count + 1;
            end

            if (byte_count == 31) begin
                key_out       <= key_buffer;
                plaintext_out <= plaintext_buffer;
                data_ready    <= 1;
                byte_count    <= 0; // Optionally reset for next input batch
            end
        end
    end

endmodule

