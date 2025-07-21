`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2025
// Design Name: AES Decryption Top
// Module Name: aes_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Top-level AES decryption module
// 
// Dependencies: key_expansion, add_round_key, inverse_sub_bytes,
//               inverse_shift_rows, inverse_mix_columns
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module AES (
    input              clk,
    input              reset,
    input              start,
    input      [127:0] ciphertext,
    input      [127:0] cipher_key,
    output reg [127:0] plaintext,
    output reg         done
);

    reg [3:0] round_counter;
    reg [127:0] current_state;
    reg computing;
    wire [127:0] current_round_key;

    wire [127:0] round_keys[0:10];
    wire done_key;

    // Round output (internal)
    wire [127:0] round_output;

    // Key expansion (same as encryption)
    key_expansion key_exp (
        .clk(clk),
        .rst(reset),
        .start(start),
        .cipher_key(cipher_key),
        .initial_key(round_keys[0]),
        .round1_key(round_keys[1]),
        .round2_key(round_keys[2]),
        .round3_key(round_keys[3]),
        .round4_key(round_keys[4]),
        .round5_key(round_keys[5]),
        .round6_key(round_keys[6]),
        .round7_key(round_keys[7]),
        .round8_key(round_keys[8]),
        .round9_key(round_keys[9]),
        .round10_key(round_keys[10]),
        .done(done_key)
    );

    wire [127:0] round_input = current_state;
    assign current_round_key = round_keys[round_counter];
    wire is_first_round = (round_counter == 10); // First decryption round is 10

    wire [127:0] add_out, shift_out, mix_out, sub_out;
    wire [127:0] pre_shift_state;

    // Step 1: AddRoundKey
    add_round_key u_add (
        .state_in(round_input),
        .roundkey_in(current_round_key),
        .state_out(add_out)
    );

    // Step 2: Conditional InverseMixColumns (bypassed on first round)
    inverse_mix_columns u_mix (
        .state_in(add_out),
        .state_out(mix_out)
    );

    assign pre_shift_state = is_first_round ? add_out : mix_out;

    // Step 3: InverseShiftRows
    inverse_shift_rows u_shift (
        .state_in(pre_shift_state),
        .state_out(shift_out)
    );

    // Step 4: InverseSubBytes
    inverse_sub_bytes u_sub (
        .state_in(shift_out),
        .state_out(sub_out)
    );

    assign round_output = (round_counter > 0) ? sub_out : round_output;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            round_counter <= 4'd10;
            current_state <= 128'd0;
            plaintext <= 128'd0;
            done <= 1'b0;
            computing <= 1'b0;
        end else begin
            if (start && !computing) begin
                computing <= 1'b1;
                round_counter <= 4'd10;
                current_state <= ciphertext;
                
                //$display("Round 10 Input (Ciphertext): %h", ciphertext);
                
                done <= 1'b0;
            end else if (computing && (done_key || round_counter != 10)) begin
                if (round_counter > 0) begin
                    current_state <= round_output;
                    $display("Round %0d Output: %h", round_counter, round_output);
                    round_counter <= round_counter - 1;
                end else begin
                    // Final round: apply AddRoundKey with round_keys[0]
                    plaintext <= round_output ^ round_keys[0];
                    
                    //$display("Final Plaintext: %h", round_output ^ round_keys[0]);
                    
                    done <= 1'b1;
                    computing <= 1'b0;
                end
            end
        end
    end

endmodule