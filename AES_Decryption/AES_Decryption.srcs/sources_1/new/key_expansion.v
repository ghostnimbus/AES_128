`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2025 21:50:17
// Design Name: 
// Module Name: key_expansion
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


module key_expansion (
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire [127:0] cipher_key,
    output reg  [127:0] initial_key,
    output reg  [127:0] round1_key,
    output reg  [127:0] round2_key,
    output reg  [127:0] round3_key,
    output reg  [127:0] round4_key,
    output reg  [127:0] round5_key,
    output reg  [127:0] round6_key,
    output reg  [127:0] round7_key,
    output reg  [127:0] round8_key,
    output reg  [127:0] round9_key,
    output reg  [127:0] round10_key,
    output reg  done
);

    // State machine
    reg [3:0] round_counter;
    reg computing;
    
    // Current round words storage - these get updated each cycle
    reg [31:0] w0, w1, w2, w3;
    
    // G-function interface
    wire [31:0] g_output;
    
    // RCON values
    wire [7:0] rcon;
    assign rcon = (round_counter == 4'd1)  ? 8'h01 :
                  (round_counter == 4'd2)  ? 8'h02 :
                  (round_counter == 4'd3)  ? 8'h04 :
                  (round_counter == 4'd4)  ? 8'h08 :
                  (round_counter == 4'd5)  ? 8'h10 :
                  (round_counter == 4'd6)  ? 8'h20 :
                  (round_counter == 4'd7)  ? 8'h40 :
                  (round_counter == 4'd8)  ? 8'h80 :
                  (round_counter == 4'd9)  ? 8'h1B :
                  (round_counter == 4'd10) ? 8'h36 : 8'h00;
    
    // Single G-function instance - reused for all rounds
    g_function g_inst (
        .word_in(w3),       // Always feed the last word of current round
        .Rcon(rcon),        // Current round's RCON
        .word_out(g_output) // G-function result
    );
    
    // Intermediate word calculations
    wire [31:0] new_w0, new_w1, new_w2, new_w3;
    assign new_w0 = w0 ^ g_output;
    assign new_w1 = w1 ^ new_w0;
    assign new_w2 = w2 ^ new_w1;
    assign new_w3 = w3 ^ new_w2;
    
    // Main control logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            computing <= 1'b0;
            round_counter <= 4'd0;
            done <= 1'b0;
            initial_key <= 128'h0;
            round1_key <= 128'h0;
            round2_key <= 128'h0;
            round3_key <= 128'h0;
            round4_key <= 128'h0;
            round5_key <= 128'h0;
            round6_key <= 128'h0;
            round7_key <= 128'h0;
            round8_key <= 128'h0;
            round9_key <= 128'h0;
            round10_key <= 128'h0;
            w0 <= 32'h0;
            w1 <= 32'h0;
            w2 <= 32'h0;
            w3 <= 32'h0;
        end
        else begin
            if (!computing && start) begin
                // Start key expansion
                computing <= 1'b1;
                done <= 1'b0;
                round_counter <= 4'd1;
                initial_key <= cipher_key;
                // Initialize working words with input key
                w0 <= cipher_key[127:96];
                w1 <= cipher_key[95:64];
                w2 <= cipher_key[63:32];
                w3 <= cipher_key[31:0];
            end
            else if (computing) begin
                // Update working words for next round
                w0 <= new_w0;
                w1 <= new_w1;
                w2 <= new_w2;
                w3 <= new_w3;
                
                // Store completed round key
                case (round_counter)
                    4'd1: begin
                          round1_key  <= {new_w0, new_w1, new_w2, new_w3};
                    end
                    4'd2: round2_key  <= {new_w0, new_w1, new_w2, new_w3};
                    4'd3: round3_key  <= {new_w0, new_w1, new_w2, new_w3};
                    4'd4: round4_key  <= {new_w0, new_w1, new_w2, new_w3};
                    4'd5: round5_key  <= {new_w0, new_w1, new_w2, new_w3};
                    4'd6: round6_key  <= {new_w0, new_w1, new_w2, new_w3};
                    4'd7: round7_key  <= {new_w0, new_w1, new_w2, new_w3};
                    4'd8: round8_key  <= {new_w0, new_w1, new_w2, new_w3};
                    4'd9: round9_key  <= {new_w0, new_w1, new_w2, new_w3};
                    4'd10: begin
                        round10_key <= {new_w0, new_w1, new_w2, new_w3};
                        computing <= 1'b0;
                        done <= 1'b1;
                    end
                endcase
                
                // Move to next round
                if (round_counter < 4'd10) begin
                    round_counter <= round_counter + 1;
                end
            end
            else if (done && !start) begin
                done <= 1'b0;
            end
        end
    end

endmodule
