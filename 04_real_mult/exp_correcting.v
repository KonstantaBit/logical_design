module exp_correcting #(
    parameter MANT_W = 24,
    parameter EXP_W = 8
) (         
    input                 overflow,
    input  [MANT_W - 1:0] mant,
    input  [EXP_W:0]      exp_sum,
    output [EXP_W - 1:0]  exp_corr
);

endmodule
