module exp_addler #(
    parameter IS_DOUBLE  = 0,
    parameter WIDTH      = IS_DOUBLE ? 64 : 32,
    parameter EXPONENT_W = IS_DOUBLE ? 11 : 8,
    parameter MANTISSA_W = IS_DOUBLE ? 52 : 23
) (
    input  [WIDTH - 1:0] op1,
    input  [WIDTH - 1:0] op2,
    output [WIDTH - 1:0] res, // Точно ли такая размерность?
    output               maybe_denorm,
    output               imprecise
);
    wire [EXPONENT_W - 1:0] exponent1 = op1[WIDTH - 2:MANTISSA_W];
    wire [EXPONENT_W - 1:0] exponent2 = op2[WIDTH - 2:MANTISSA_W];
    
    localparam BIAS = IS_DOUBLE ? 1023 : 127;

    assign res          = exponent1 + exponent2 - BIAS;
    assign maybe_denorm = (-25 < res) & (res < 1);
    assign imprecise    = res < -24; 
endmodule
