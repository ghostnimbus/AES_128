module inverse_mix_columns (
    input  wire [127:0] state_in,
    output wire [127:0] state_out
);

    // Multiply by 2 in GF(2^8)
    function [7:0] xtime;
        input [7:0] b;
        xtime = (b[7]) ? ((b << 1) ^ 8'h1B) : (b << 1);
    endfunction

    // Multiply by 0x09
    function [7:0] mul_09;
        input [7:0] b;
        mul_09 = xtime(xtime(xtime(b))) ^ b;
    endfunction

    // Multiply by 0x0b
    function [7:0] mul_0b;
        input [7:0] b;
        mul_0b = xtime(xtime(xtime(b))) ^ xtime(b) ^ b;
    endfunction

    // Multiply by 0x0d
    function [7:0] mul_0d;
        input [7:0] b;
        mul_0d = xtime(xtime(xtime(b))) ^ xtime(xtime(b)) ^ b;
    endfunction

    // Multiply by 0x0e
    function [7:0] mul_0e;
        input [7:0] b;
        mul_0e = xtime(xtime(xtime(b))) ^ xtime(xtime(b)) ^ xtime(b);
    endfunction

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : column_inverse_mix
            wire [7:0] s0 = state_in[127 - 32*i -: 8];
            wire [7:0] s1 = state_in[119 - 32*i -: 8];
            wire [7:0] s2 = state_in[111 - 32*i -: 8];
            wire [7:0] s3 = state_in[103 - 32*i -: 8];

            wire [7:0] m0 = mul_0e(s0) ^ mul_0b(s1) ^ mul_0d(s2) ^ mul_09(s3);
            wire [7:0] m1 = mul_09(s0) ^ mul_0e(s1) ^ mul_0b(s2) ^ mul_0d(s3);
            wire [7:0] m2 = mul_0d(s0) ^ mul_09(s1) ^ mul_0e(s2) ^ mul_0b(s3);
            wire [7:0] m3 = mul_0b(s0) ^ mul_0d(s1) ^ mul_09(s2) ^ mul_0e(s3);

            assign state_out[127 - 32*i -: 8] = m0;
            assign state_out[119 - 32*i -: 8] = m1;
            assign state_out[111 - 32*i -: 8] = m2;
            assign state_out[103 - 32*i -: 8] = m3;
        end
    endgenerate

endmodule