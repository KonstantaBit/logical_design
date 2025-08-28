module op_analyzer #( // TODO: Написать версию для мантисы без hidden bit
    parameter EXP_W  = 8,
    parameter MANT_W = 23
) (
    input  [EXP_W - 1:0]  exp,
    input  [MANT_W - 1:0] mant,
    output                is_zero,
    output                is_nan,
    output                is_inf,
    output                is_norm,
    output                is_denorm 
);  
    wire exp_full       =  &exp;
    wire exp_empty      = ~|exp;
    wire mant_not_empty =  |mant;

    assign is_nan    =  exp_full  &  mant_not_empty;
    assign is_inf    =  exp_full  & ~mant_not_empty;
    assign is_norm   = ~exp_full  & ~exp_empty;
    assign is_zero   =  exp_empty & ~mant_not_empty;
    assign is_denorm =  exp_empty &  mant_not_empty;
endmodule
