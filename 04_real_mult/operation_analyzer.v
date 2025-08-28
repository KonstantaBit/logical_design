module operation_analyzer #(
    parameter WIDTH = 32,
    parameter EXP_W  = 8,
    parameter MANT_W = 23
) (
    input [WIDTH - 1:0] op1,
    input [WIDTH - 1:0] op2,
    output              is_nan,
    output              is_inf,
    output              is_zero,
    output              is_invalid
);
            
    wire is_zero1;
    wire is_nan1;
    wire is_inf1;
    wire is_norm1;
    wire is_denorm1;
        
    op_analyzer #(.WIDTH(IS_DOUBLE)) op_an1 (
        .op(op1)
        .is_zero(is_zero1),
        .is_nan(is_nan1),
        .is_inf(is_inf1),
        .is_norm(is_norm1),
        .is_denorm(is_denorm1),
    );

    wire is_zero2;
    wire is_nan2;
    wire is_inf2;
    wire is_norm2;
    wire is_denorm2;

    op_analyzer #(.IS_DOUBLE(IS_DOUBLE)) op_an2 (
        .op(op2)
        .is_zero(is_zero2),
        .is_nan(is_nan2),
        .is_inf(is_inf2),
        .is_norm(is_norm2),
        .is_denorm(is_denorm2),
    );

    assign is_nan     = is_nan1  | is_nan2;
    assign is_inf     = is_inf1  | is_inf2;
    assign is_zero    = is_zero1 | is_zero2;
    assign is_invalid = (is_zero1 & is_inf2) | (is_inf1 & is_zero2);
endmodule
