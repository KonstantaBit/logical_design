/*
Модуль сложения экспонент
*/
module exp_adder #(
    parameter EXP_W  = 8,
    parameter MANT_W = 24
) (
    input         [EXP_W - 1:0] exp_a,
    input         [EXP_W - 1:0] exp_b,
    output signed [EXP_W:0]     res
);
    localparam BIAS = (1 << (EXP_W - 1)) - 1; // 2^(EXP_W-1) - 1

    assign res = ({1'b0, exp_a} + {1'b0, exp_b}) - BIAS; // Экплицитное указание signed
endmodule
