/*
Модуль для перемножения чисел c плавающей запятой по стандарту IEEE754
*/
module real_mult #(
    parameter HIDDEN_BIT = 1,  // Наличие скрытого бита в мантиссе
    parameter EXP_W      = 8,  // Размерность экспоненты
    parameter MANT_RAW_W = 24, // Размерность мантиссы
    parameter WIDTH      = 32; // ??? :P
) (
    input  [WIDTH - 1:0] op_a,
    input  [WIDTH - 1:0] op_b,
    input  [1:0]         opcode,
    input                clk,
    input                reset,
    output [WIDTH - 1:0] res,
    output [WIDTH - 1:0] val
);

    localparam MANT_W = MANT_RAW_W - HIDDEN_BIT; // Размерность мантиссы

    // Первый этап в конвеере (предобработка)

    wire [MANT_W - 1:0] mant_a = op_a[MANT_W - 1:0];
    wire [MANT_W - 1:0] mant_b = op_b[MANT_W - 1:0];

    wire [EXP_W - 1:0] exp_a = op_a[WIDTH - 2:MANT_W];
    wire [EXP_W - 1:0] exp_b = op_b[WIDTH - 2:MANT_W];

    wire sign = op_a[WIDTH - 1] ^ op_b[WIDTH - 1]; // Знак результата

    wire [EXP_W:0] exp_mult; // Промежуточная сумма экспонент

    exp_adder #(.EXP_W(EXP_W), .MANT_W(MANT_RAW_W)) exp_ad (
        .exp_a(exp_a),
        .exp_b(exp_b),
        .res(exp_mult)
    ); // TODO: Несколько бросовых выходов, убрать?

    // TODO: Анализ операции

    wire is_denorm_a;

    op_analyzer #(.EXP_W(EXP_W), .MANT_W(MANT_W)) op_a_an (
        .is_denorm(is_denorm_a)
    ); // Несколько бросовых выходов

    wire is_denorm_b;

    op_analyzer #(.EXP_W(EXP_W), .MANT_W(MANT_W)) op_b_an (
        .is_denorm(is_denorm_b)
    ); // Несколько бросовых выходов

    // Второй этап в конвеере

    wire [MANT_RAW_W * 2 - 1:0] mant_mult; // TODO: Починка с конвеером

    generate if (HIDDEN_BIT) 
            assign mant_mult = {~is_denorm_a, mant_a} * {~is_denorm_b, mant_b}; // TODO: Поставить умножитель
        else
            assign mant_mult = mant_a * mant_b;
    endgenerate

    wire [$clog2(IN_W + 1) - 1:0] shift;

    zero_counter #(.IN_W(MANT_W * 2), .REVERSE(0)) lz_cnt (
        .in(mant_mult),
        .out(shift)
    );

endmodule
