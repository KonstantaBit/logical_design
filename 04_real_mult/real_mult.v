/*
Модуль для перемножения чисел c плавающей запятой по стандарту IEEE754
*/

/* verilator lint_off PINCONNECTEMPTY */
/* verilator lint_off PINMISSING */
module real_mult #(
    parameter HIDDEN_BIT = 1,  // Наличие скрытого бита в мантиссе
    parameter EXP_W      = 11,  // Размерность экспоненты
    parameter MANT_RAW_W = 53, // Размерность мантиссы
    parameter WIDTH      = 64 // ??? :P
) (
    input  [WIDTH - 1:0] op_a,
    input  [WIDTH - 1:0] op_b,
    input  [1:0]         opcode,
    input                clk,
    input                reset,
    output reg [WIDTH - 1:0] res,
    output [WIDTH - 1:0] val
);

    localparam MANT_W = MANT_RAW_W - HIDDEN_BIT; // Размерность мантиссы

    // Первый этап в конвеере (предобработка)

    wire [MANT_W - 1:0] mant_a = op_a[MANT_W - 1:0];
    wire [MANT_W - 1:0] mant_b = op_b[MANT_W - 1:0];

    wire [EXP_W - 1:0] exp_a = op_a[WIDTH - 2:MANT_W];
    wire [EXP_W - 1:0] exp_b = op_b[WIDTH - 2:MANT_W];

    wire sign = op_a[WIDTH - 1] ^ op_b[WIDTH - 1]; // Знак результата

    wire [EXP_W:0] exp_sum; // Промежуточная сумма экспонент

    exp_adder #(.EXP_W(EXP_W), .MANT_W(MANT_RAW_W)) exp_ad (
        .exp_a(exp_a),
        .exp_b(exp_b),
        .res(exp_sum)
    );

    // TODO: Анализ операции :P

    wire is_denorm_a, is_nan_a;

    op_analyzer #(.EXP_W(EXP_W), .MANT_W(MANT_W)) op_a_an (
        .is_denorm(is_denorm_a),
        .is_nan(is_nan_a)
    ); // Несколько бросовых выходов

    wire is_denorm_b, is_nan_b;

    op_analyzer #(.EXP_W(EXP_W), .MANT_W(MANT_W)) op_b_an (
        .is_denorm(is_denorm_b),
        .is_nan(is_nan_b)
    ); // Несколько бросовых выходов

    // Второй этап в конвеере

    wire [MANT_RAW_W * 2 - 1:0] mant_mult; // TODO: Починка с конвеером

    generate if (HIDDEN_BIT) 
            assign mant_mult = {~is_denorm_a, mant_a} * {~is_denorm_b, mant_b}; // TODO: Поставить умножитель
        else
            assign mant_mult = mant_a * mant_b;
    endgenerate

    wire [$clog2(MANT_RAW_W * 2 + 1) - 1:0] shift;

    zero_counter #(.IN_W(MANT_RAW_W * 2), .REVERSE(0)) lz_cnt (
        .in(mant_mult),
        .out(shift)
    );

    // Третий этап в конвеере

    wire [EXP_W - 1:0] exp_corr;
    wire [MANT_W - 1:0] mant_corr;
    wire inexact_inf, inexact_zero;

    exp_correcting #(.MANT_W(MANT_W), .EXP_W(EXP_W)) correcting (
        .mant(mant_mult),
        .sign(sign),
        .shift(shift),
        .exp_sum(exp_sum),
        .exp_corr(exp_corr),
        .mant_corr(mant_corr),
        .inexact_inf(inexact_inf),
        .inexact_zero(inexact_zero)
    );

    always @(posedge clk) begin
        if (reset) begin
            res = {WIDTH{1'b0}};
        end else begin
            // if (inexact_zero) begin
            //     exp_corr = 0;
            //     mant_corr = 0;
            //     res = {sign, exp_corr, mant_corr};
            // end else if (inexact_inf) begin
            //     exp_corr = '1;
            //     mant_corr = 0;
            //     res = {sign, exp_corr, mant_corr};
            // end else if (is_nan_a | is_nan_b) begin
            //     exp_corr = '1;
            //     mant_corr = 1;
            //     res = {sign, exp_corr, mant_corr};
            // end else begin
                res = {sign, exp_corr, mant_corr};
            // end
        end
    end

endmodule
