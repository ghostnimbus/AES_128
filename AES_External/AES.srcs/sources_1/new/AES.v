`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/02/2025
// Design Name: AES Top Module
// Module Name: AES
// Description: AES encryption and decryption with output ports
//////////////////////////////////////////////////////////////////////////////////

module AES (
    input              clk,
    input              reset,
    input              start,
    input      [127:0] data_in,
    input      [127:0] cipher_key,
    output wire [127:0] data_out,
    output wire        done
);

    wire [127:0] ciphertext_enc;
    wire         done_enc;

    reg          dec_triggered;

    // Encryption
    aes_top_encryption encryptor (
        .clk(clk),
        .reset(reset),
        .start(start),
        .plaintext(data_in),
        .cipher_key(cipher_key),
        .ciphertext(ciphertext_enc),
        .done(done_enc)
    );

    // Decryption
    aes_top_decryption decryptor (
        .clk(clk),
        .reset(reset),
        .start(done_enc),         // Start decryption after encryption is done
        .start_key(start),        // Optional: only if your decryption core requires it
        .ciphertext(ciphertext_enc),
        .cipher_key(cipher_key),
        .plaintext(data_out),
        .done(done)
    );

    // Display block
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dec_triggered <= 0;
        end else begin
//            if (start) begin
//                $display("======Encryption======");
//                $display("PlainText:  %h", data_in);
//                $display("CipherKey:  %h", cipher_key);
//                $display("=======================");
//            end 

            if (done_enc && !dec_triggered) begin
                $display("Encryption Done.");
                $display("=======================");
                $display("CipherText: %h", ciphertext_enc);
                $display("=======================");
                $display("======Decryption======");
                $display("=======================");
                dec_triggered <= 1;
            end

            //if (done) begin
              //  $display("Decryption Done.");
                //$display("=======================");
              //  $display("Decrypted PlainText: %h", data_out);
              //  $display("=======================");
            //end
        end
    end

endmodule