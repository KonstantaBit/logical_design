/*
Модуль сложения экспонент
*/
module exp_adder #(
    parameter EXP_W  = 8,
    parameter MANT_W = 24
) (
    input         [EXP_W - 1:0] exp_a,
    input         [EXP_W - 1:0] exp_b,
    output signed [EXP_W:0]     res,
    output                      denorm,
    output                      inexact
);
    localparam BIAS = (1 << (EXP_W - 1)) - 1; // 2^(EXP_W-1) - 1

    assign res     = $signed({1'b0, exp_a}) + $signed({1'b0, exp_b}) - BIAS; // Экплицитное указание signed
    assign denorm  = ($signed(res) <= 0);      // Денормализованное, когда exp <= 0
    assign inexact = ($signed(res) < -MANT_W); // Неточный нуль
endmodule // BAD!!!
