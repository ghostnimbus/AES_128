`timescale 1ns / 1ps

module tb_aes_decrypt;

    // Inputs
    reg clk;
    reg reset;
    reg start;
    reg [127:0] ciphertext;
    reg [127:0] cipher_key;

    // Outputs
    wire [127:0] plaintext;
    wire done;

    // Instantiate the AES decryption module
    AES uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .ciphertext(ciphertext),
        .cipher_key(cipher_key),
        .plaintext(plaintext),
        .done(done)
    );

    // Clock generation: 10ns period (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        reset = 1;
        start = 0;
        ciphertext = 128'h0cc5712c4cc5f341ed5d3e157eca8d0f; // Example AES-128 ciphertext
        cipher_key = 128'hfedcba9876543210fedcba9876543210; // Example AES-128 key

        // Wait for global reset
        #20;
        reset = 0;

        // Wait a few cycles
        #50;

        // Start decryption
        start = 1;
        #10;
        start = 0;

        // Wait for decryption to complete
        wait (done);

        $display("Decryption Done!");
        $display("Recovered Plaintext = %h", plaintext);

        // Finish simulation
        #20;
        $stop;
    end

endmodule
