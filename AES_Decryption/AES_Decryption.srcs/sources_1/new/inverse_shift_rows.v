module inverse_shift_rows (
    input  wire [127:0] state_in,
    output wire [127:0] state_out
);
    wire [7:0] state [0:15];

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            assign state[i] = state_in[127 - i*8 -: 8];
        end
    endgenerate

    wire [7:0] shifted [0:15];

    // Row 0 (no shift)
    assign shifted[0]  = state[0];
    assign shifted[4]  = state[4];
    assign shifted[8]  = state[8];
    assign shifted[12] = state[12];

    // Row 1 (right shift by 1)
    assign shifted[1]  = state[13];
    assign shifted[5]  = state[1];
    assign shifted[9]  = state[5];
    assign shifted[13] = state[9];

    // Row 2 (right shift by 2)
    assign shifted[2]  = state[10];
    assign shifted[6]  = state[14];
    assign shifted[10] = state[2];
    assign shifted[14] = state[6];

    // Row 3 (right shift by 3)
    assign shifted[3]  = state[7];
    assign shifted[7]  = state[11];
    assign shifted[11] = state[15];
    assign shifted[15] = state[3];

    // Pack output
    generate
        for (i = 0; i < 16; i = i + 1) begin
            assign state_out[127 - i*8 -: 8] = shifted[i];
        end
    endgenerate
endmodule