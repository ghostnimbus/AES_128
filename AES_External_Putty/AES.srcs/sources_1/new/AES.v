module AES_Final(
    clk_100M,
    rx,
    reset,
    tx,
    uart_valid
);

input wire clk_100M;
input wire rx;
input wire reset;
output wire tx;
output wire uart_valid;

// Clock & Reset
wire clk_3125KHz;

// UART Interface
wire uart_rx_done;
wire [7:0] uart_rx_data;
wire uart_tx_start;
wire [7:0] uart_tx_data;
wire uart_tx_done;

// AES Interface
wire aes_enc_start;
wire aes_enc_done;
wire aes_dec_start;
wire aes_dec_done;
wire [127:0] aes_key;
wire [127:0] aes_plaintext_in;
wire [127:0] aes_ciphertext_out;
wire [127:0] aes_plaintext_out;

// Instantiate Frequency Scaling (50 MHz → 3.125 MHz)
freq_scaling freq_divider (
    .clk_100M(clk_100M),
    .clk_3125KHz(clk_3125KHz)
);

// UART Receiver
uart_rx uart_receiver (
    .clk_3125(clk_3125KHz),
    .rx(rx),
    .rx_complete(uart_rx_done),
    .rx_msg(uart_rx_data)
);

// UART to AES Input Converter
uart_to_aes_input uart_input_handler (
    .clk(clk_3125KHz),
    .rst(reset),
    .uart_valid(uart_rx_done),
    .uart_data(uart_rx_data),
    .data_ready(aes_dec_start),     // Also acts as start for encryption
    .key_out(aes_key),
    .plaintext_out(aes_plaintext_in)
);

// AES Encryption
aes_top_encryption aes_encrypt (
    .clk(clk_3125KHz),
    .reset(reset),
    .start(aes_dec_start),
    .cipher_key(aes_key),
    .plaintext(aes_plaintext_in),
    .done(aes_enc_done),
    .ciphertext(aes_ciphertext_out)
);

// AES Decryption
aes_top_decryption aes_decrypt (
    .clk(clk_3125KHz),
    .reset(reset),
    .start(aes_enc_done),
    .start_key(aes_dec_start),
    .cipher_key(aes_key),
    .ciphertext(aes_ciphertext_out),
    .done(aes_dec_done),
    .plaintext(aes_plaintext_out)
);

// AES Output to UART Converter
aes_output_to_uart uart_output_handler (
    .clk(clk_3125KHz),
    .rst(reset),
    .data_valid(aes_dec_done),
    .uart_ready(uart_tx_done),
    .plaintext_in(aes_plaintext_out),
    .uart_valid(uart_tx_start),
    .uart_data(uart_tx_data)
);

// UART Transmitter
uart_tx uart_transmitter (
    .clk_3125(clk_3125KHz),
    .tx_start(uart_tx_start),
    .data(uart_tx_data),
    .tx(tx),
    .tx_done(uart_tx_done)
);
assign uart_valid = uart_tx_start;
endmodule
