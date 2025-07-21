`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/02/2025 12:04:26 PM
// Design Name: 
// Module Name: aes_top_encryption
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


module aes_top_encryption (
    input              clk,
    input              reset,
    input              start,
    input      [127:0] plaintext,
    input      [127:0] cipher_key,
    output reg [127:0] ciphertext,
    output reg         done
    // Note: Removed array-style output - not allowed in Verilog ports
);

    reg [3:0] round_counter;
    reg [127:0] current_state;
    reg computing;

    wire [127:0] round_keys[0:10];
    wire done_key;

    // Round output (internal)
    wire [127:0] round_output;

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
    wire [127:0] current_round_key = round_keys[round_counter];
    wire is_final_round = (round_counter == 10);

    wire [127:0] sub_out, shift_out, mix_out;

    sub_bytes u_sub (.state_in(round_input), .state_out(sub_out));
    shift_rows u_shift (.state_in(sub_out), .state_out(shift_out));
    mix_columns u_mix (.state_in(shift_out), .state_out(mix_out));

    wire [127:0] pre_add_state = is_final_round ? shift_out : mix_out;

    add_round_key u_add (
        .state_in(pre_add_state),
        .roundkey_in(current_round_key),
        .state_out(round_output)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            round_counter <= 0;
            current_state <= 0;
            ciphertext <= 0;
            done <= 0;
            computing <= 0;
        end else begin
            if (start && !computing) begin
                computing <= 1;
                round_counter <= 1;
                current_state <= plaintext ^ cipher_key;
                $display("======Encryption======");
                $display("PlainText:  %h", plaintext);
                $display("CipherKey:  %h", cipher_key);
                $display("=======================");
                $display("Round 0 Output: %h", plaintext ^ cipher_key); // Display Round 0
                done <= 0;
            end else if (computing && (done_key || round_counter != 1)) begin
                if (round_counter < 10) begin
                    current_state <= round_output;
                    $display("Round %0d Output: %h", round_counter, round_output);
                    round_counter <= round_counter + 1;
                end else begin
                    $display("Round 10 Output: %h", round_output);
                    ciphertext <= round_output;
                    done <= 1;
                    computing <= 0;
                end
            end
        end
    end

endmodule