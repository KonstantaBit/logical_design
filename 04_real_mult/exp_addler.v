module op_analyzer #(
    parameter IS_DOUBLE  = 0,
    parameter WIDTH      = IS_DOUBLE == 1 ? 64 : 32,
    parameter EXPONENT_W = IS_DOUBLE == 1 ? 11 : 8,
    parameter MANTISSA_W = IS_DOUBLE == 1 ? 52 : 23
) (
    input [WIDTH - 1:0] op1,
    input [WIDTH - 1:0] op2,
    output              res 
);
    wire [MANTISSA_W - 1:0] mantissa;
    wire [EXPONENT_W - 1:0] exponent;

    assign exponent = op[WIDTH - 2:MANTISSA_W];
    assign mantissa = op[MANTISSA_W - 1:0];
    
    localparam exp_full  =      &exponent;
    localparam exp_empty =     ~|exponent;
    localparam mant_not_empty = |mantissa;

    assign is_nan    =  exp_full  &  mant_not_empty;
    assign is_inf    =  exp_full  & ~mant_not_empty;
    assign is_norm   = ~exp_full  & ~exp_empty;
    assign is_zero   =  exp_empty & ~mant_not_empty;
    assign is_denorm =  exp_empty &  mant_not_empty;
endmodule
