module booth_encoder #(
    parameter WIDE = 8
)(
    input  [WIDE - 1:0] op2,
    output [WIDE - 1:0] val,
    output [WIDE - 1:0] sign
);
    wire [WIDE - 1:0] addend = {op2, 1'b0};

    genvar i;

    generate
        for (i = 0; i < WIDE; i = i + 1) begin: booth_enc_loop
            assign val[i]  = ^addend[i + 1:i];
            assign sign[i] =  addend[i + 1];
        end
    endgenerate

endmodule
