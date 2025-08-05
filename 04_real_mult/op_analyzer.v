module op_analyzer #(
    parameter IS_DOUBLE  = 0,
    parameter WIDTH      = IS_DOUBLE == 1 ? 64 : 32,
    parameter EXPONENT_W = IS_DOUBLE == 1 ? 11 : 8,
    parameter MANTISSA_W = IS_DOUBLE == 1 ? 52 : 23
) (
    input [WIDTH - 1:0] op
    output              is_zero,
    output              is_nan,
    output              is_inf,
    output              is_norm,
    output              is_denorm 
);
    wire [MANTISSA_W - 1:0] mantissa;
    wire [EXPONENT_W - 1:0] exponent;
    
    generate // Сделать предпосчитанными 255 и 2047
        if (IS_DOUBLE == 0) begin
            assign exponent = op[30:23];
            assign mantissa = op[22:0];

            assign is_nan    = (exponent == 255) & (mantissa != 0);
            assign is_inf    = (exponent == 255) & (mantissa == 0);
            assign is_norm   = (0 < exponent < 255);
            assign is_zero   = (exponent == 0) & (mantissa == 0);
            assign is_denorm = (exponent == 0) & (mantissa != 0);
        end else begin
            assign exponent = op[62:52];
            assign mantissa = op[51:0];

            assign is_nan    = (exponent == 2047) & (mantissa != 0);
            assign is_inf    = (exponent == 2047) & (mantissa == 0);
            assign is_norm   = (0 < exponent < 2047);
            assign is_zero   = (exponent == 0) & (mantissa == 0);
            assign is_denorm = (exponent == 0) & (mantissa != 0);
        end
    endgenerate
endmodule
