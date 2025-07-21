`timescale 1ns / 1ps

module tb;

    reg clk;
    reg reset;
    reg start;
    reg [127:0] data_in;
    reg [127:0] cipher_key;

    wire [127:0] data_out;
    wire done;

    // DUT instantiation
    AES uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_in(data_in),
        .cipher_key(cipher_key),
        .data_out(data_out),
        .done(done)
    );

    // Clock generation: 100 MHz
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // VCD dump for waveform viewing
    initial begin
        $dumpfile("aes_waveform.vcd");          // Output VCD file
        $dumpvars(0, tb);                       // Dump everything in tb and below
        $dumpvars(1, uut.ciphertext_enc);       // Explicitly dump ciphertext from AES module
    end

    // Monitor and stimulus
    initial begin
        // Initialize inputs
        reset = 1;
        start = 0;
        data_in = 128'h1234567890abcdef1234567890abcdef;    // Example plaintext
        cipher_key = 128'hfedcba9876543210fedcba9876543210; // AES 128-bit key

        #20;
        reset = 0;

        #10;
        start = 1;
        #10;
        start = 0;

        // Wait for AES module to complete
        wait (done);

        // Display results
        $display("\n================ [OUTPUT] ================");
        $display("Encrypted CipherText     = %h", uut.ciphertext_enc); // Access internal signal hierarchically
        $display("Decrypted PlainText      = %h", data_out);
        $display("==========================================\n");

        #9 $finish;
    end

endmodule
