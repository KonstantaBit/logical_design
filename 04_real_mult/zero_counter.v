/* verilator lint_off UNOPTFLAT */

module zero_counter 
#(
    parameter REVERSE = 0,
    parameter IN_W    = 8,
    parameter OUT_W   = $clog2(IN_W + 1)
)
(
    input  [IN_W - 1:0]  in,
    output [OUT_W - 1:0] out
);

    wire [OUT_W - 1:0] buff [IN_W:0]; // Набор проводов для хранения промежуточных результатов. На один больше!
    wire [IN_W - 1:0]  permutation;   // Набор входных проводов для перестановки
    
    assign buff[0] = 0;
    
    genvar i;

    generate
        if (REVERSE == 0) begin: high_zeros
            assign permutation = in;
        end else begin: low_zeros
            for (i = 0; i < IN_W ; i = i + 1) begin: low_zeros_loop
                assign permutation[i] = in[IN_W - 1 - i];
            end
        end
    endgenerate  

    generate
        for (i = 0; i < IN_W; i = i + 1 ) begin: loop
            assign buff[i + 1] = permutation[i] ? 0 : (buff[i] + 1);
        end
    endgenerate

    assign out = buff[IN_W];

endmodule // Самый дешёвый по транзисторам вариант, но самый долгий? Из-за этого verilator кидает UNOPTFLAT
