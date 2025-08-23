module rounding #(
    parameter IS_DOUBLE = 0,
    parameter HIGH_PART_WIDTH = (IS_DOUBLE) ? 52 : 23,
    parameter LOW_PART_WIDTH = (IS_DOUBLE) ? 53 : 24,
    parameter TOTAL_WIDTH = (IS_DOUBLE) ? 106 : 48
) (         
    input wire [TOTAL_WIDTH-1:0] data_in,  
    input wire [1:0] round_mode,  // 00 - Округление к нулю
                                  // 01 - Округление к + inf
                                  // 10 - Округление к - inf
                                  // 11 - Округление к ближайшему четному
    input wire res_sign,
    output wire [HIGH_PART_WIDTH:0] data_out, 
    output wire inexact,           // Флаг точности (1 - округление не потребовалось)
    output wire overflow           // Флаг переполнения
);

endmodule
