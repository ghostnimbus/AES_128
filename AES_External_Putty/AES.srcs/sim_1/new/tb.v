`timescale 1ns / 1ps

module tb;

    reg clk_100M;
    reg reset;
    reg rx;
    wire tx;
    wire uart_ready;
    
    // Instantiate DUT
    AES_Final uut (
        .clk_100M(clk_100M),
        .reset(reset),
        .rx(rx),
        .tx(tx),
        .uart_valid(uart_ready)
    );

    // Clock Generation: 100 MHz
    always #5 clk_100M = ~clk_100M;

    // Constants
    parameter BAUD_PERIOD = 8680; // ns for 115200 baud
    integer i;

    // UART Send Task (LSB First)
    task uart_send_byte(input [7:0] data);
        begin
            rx = 0; // Start bit
            #(BAUD_PERIOD);

            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #(BAUD_PERIOD);
            end

            rx = 1; // Stop bit
            #(BAUD_PERIOD);
        end
    endtask

    // Output buffer
    reg [7:0] rx_buffer [0:31]; // To store 16 bytes from TX
    integer bit_cnt = 0;
    integer byte_cnt = 0;
    reg [9:0] shift_reg = 10'b1111111111;
    reg [7:0] current_byte;
    reg prev_tx;

    // UART RX monitor (TX line)
    always @(posedge clk_100M) begin
        if (prev_tx == 1 && tx == 0) begin // Detect start bit
            #(BAUD_PERIOD); // move to middle of start bit

            for (i = 0; i < 8; i = i + 1) begin
                #(BAUD_PERIOD);
                shift_reg[i] = tx;
            end

            #(BAUD_PERIOD); // stop bit

            current_byte = shift_reg[7:0];
            rx_buffer[byte_cnt] = current_byte;
            byte_cnt = byte_cnt + 1;
        end

        prev_tx <= tx;
    end

    // Expected plaintext
    reg [127:0] expected_plaintext = 128'h3243f6a8885a308d313198a2e0370734;

    // Test procedure
    initial begin
        clk_100M = 0;
        reset = 1;
        rx = 1; // Idle
        prev_tx = 1;

        #10;
        reset = 0;
        #20;

        // Send 16-byte key: 2b7e151628aed2a6abf7158809cf4f3c
        uart_send_byte(8'h2b); uart_send_byte(8'h7e); uart_send_byte(8'h15); uart_send_byte(8'h16);
        uart_send_byte(8'hae); uart_send_byte(8'hd2); uart_send_byte(8'ha6); uart_send_byte(8'hab);
        uart_send_byte(8'hf7); uart_send_byte(8'h15); uart_send_byte(8'h88); uart_send_byte(8'h09);
        uart_send_byte(8'hcf); uart_send_byte(8'h4f); uart_send_byte(8'h3c); uart_send_byte(8'h00);

        // Send 16-byte plaintext: 3243f6a8885a308d313198a2e0370734
        uart_send_byte(8'h32); uart_send_byte(8'h43); uart_send_byte(8'hf6); uart_send_byte(8'ha8);
        uart_send_byte(8'h88); uart_send_byte(8'h5a); uart_send_byte(8'h30); uart_send_byte(8'h8d);
        uart_send_byte(8'h31); uart_send_byte(8'h31); uart_send_byte(8'h98); uart_send_byte(8'ha2);
        uart_send_byte(8'he0); uart_send_byte(8'h37); uart_send_byte(8'h07); uart_send_byte(8'h34);

        // Wait for TX output
        wait(uart_ready==1);

        // Compare received UART output with expected plaintext
        $display("\n--- Decrypted Output on UART ---");
        for (i = 0; i < 16; i = i + 1) begin
            $display("Byte %0d: %02x", i, rx_buffer[i]);
            if (rx_buffer[i] !== expected_plaintext[127 - i*8 -: 8]) begin
                $display("MISMATCH at byte %0d: Expected %02x, Got %02x",
                          i, expected_plaintext[127 - i*8 -: 8], rx_buffer[i]);
            end
        end

        $display("Test Complete");
        $finish;
    end

endmodule
