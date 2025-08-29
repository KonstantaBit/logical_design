/* verilator lint_off PINMISSING */

module exp_correcting #(
    parameter MANT_W = 24,
    parameter EXP_W = 8
) (         
    input         [MANT_W * 2 - 1:0]             mant,
    input         [$clog2(MANT_W * 2 + 1) - 1:0] shift,
    input  signed [EXP_W:0]                      exp_sum,
    input                                        sign,
    output        [EXP_W - 1:0]                  exp_corr,
    output        [MANT_W - 2:0]                 mant_corr, // Проблемы с скрытым битом на будущее
    output                                       inexact_inf,
    output                                       inexact_zero
);

    /*
    1. Сдвигаем мантиссу на shift, чтобы нормализовать её: 00.001x => 1x.
       После переносим запятую с помощью +1 в экпоненте: 1x. => 1.x
       Экспонента также получает минус shift за первое дествие
    
    2. Если изменённая экпонента меньше мантиссы, то это неточный нуль,
       иначе: устанавливаем экпоненту в 0

       (лень)
    */

    localparam BIAS = (1 << (EXP_W - 1)) - 1; // 2^(EXP_W-1) - 1

    wire [MANT_W * 2 - 1:0] mant_r_shifted = mant << shift;
    
    wire signed [EXP_W:0] exp_r_shifted = exp_sum - shift + 1;

    assign inexact_zero = exp_r_shifted < -MANT_W;

    wire signed [EXP_W:0] exp_l_shifted = (exp_r_shifted > 0) ? exp_r_shifted : 0;

    wire [MANT_W * 2 - 1:0] mant_l_shifted = mant_r_shifted >> ((exp_r_shifted > 0) ? 0 : -exp_r_shifted);

    wire [MANT_W - 1:0] mant_rounded;
    
    wire overflow;

    mant_rounding #(.MANT_W(MANT_W)) rounding (
        .in(mant_l_shifted),
        .mode(2'b11),  // Режим по умолчанию
        .sign(sign),
        .out(mant_rounded),
        .overflow(overflow)
    );

    assign inexact_inf = (exp_l_shifted + overflow) >= BIAS;
    
    assign exp_corr = exp_l_shifted + overflow;
    assign mant_corr = mant_rounded[MANT_W - 2:0] >> 1;
endmodule
