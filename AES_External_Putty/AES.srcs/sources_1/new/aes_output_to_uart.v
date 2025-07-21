`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2025 14:39:23
// Design Name: 
// Module Name: aes_output_to_uart
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


module aes_output_to_uart (
    input  wire        clk,
    input  wire        rst,
    input  wire [127:0] plaintext_in,
    input  wire        data_valid,    // Start sending when this is high for 1 cycle
    output reg  [7:0]  uart_data,
    output reg         uart_valid,
    input  wire        uart_ready,
    output reg         busy
);

    reg [3:0] byte_index;
    reg [127:0] buffer;
    reg sending;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            byte_index  <= 0;
            uart_data   <= 0;
            uart_valid  <= 0;
            buffer      <= 0;
            sending     <= 0;
            busy        <= 0;
        end else begin
            uart_valid <= 0;

            // Start sending if data_valid is high
            if (data_valid && !sending) begin
                buffer     <= plaintext_in;
                sending    <= 1;
                byte_index <= 0;
                busy       <= 1;
            end

            if (sending && (byte_index==0 || uart_ready)) begin
                // Send MSB first
                uart_data  <= buffer[127:120];
                uart_valid <= 1;

                // Shift left by 8 bits
                buffer     <= {buffer[119:0], 8'b0};
                byte_index <= byte_index + 1;

                if (byte_index == 15) begin
                    sending <= 0;
                    busy    <= 0;
                end
            end
        end
    end

endmodule

