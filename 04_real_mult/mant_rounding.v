/*
Модуль округления мантиссы, имеет 4 режима откругления, которые управляются входом mode:
 - 00 => к нулю, т.е. младшая часть отбрасывается
 - 01 => к +inf
 - 10 => к -inf
 - 11 => к ближайшему чётному
*/
module mant_rounding #(
    parameter MANT_W = 24
) (         
    input  [MANT_W * 2 - 1:0] in,
    input  [1:0]              mode,
    input                     sign,
    output [MANT_W - 1:0]     out,
    output                    inexact,
    output                    overflow
);
    wire [MANT_W - 1:0] mant_hi, mant_lo;
    
    assign {mant_hi, mant_lo} = in;

    wire round  =  mant_hi[0];
    wire guard  =  mant_lo[MANT_W - 1];
    wire sticky = |mant_lo[MANT_W - 2:0];

    reg increment;

    always @(*) begin
        case (mode)
            2'b00: increment = 1'b0;
            2'b01: increment = ~sign & |mant_lo;
            2'b10: increment =  sign & |mant_lo;
            2'b11: increment = ((guard & sticky) | (guard & ~sticky & round));
        endcase
    end

    assign overflow = &mant_hi & increment;

    assign out = overflow ? {1'b1, {(MANT_W - 1){1'b0}}} : (mant_hi + increment);
    assign inexact = |mant_lo;
endmodule
