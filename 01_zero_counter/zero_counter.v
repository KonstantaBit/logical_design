/* verilator lint_off UNOPTFLAT */

module zero_counter 
#(
    parameter IN_W,
    parameter OUT_W = $clog2(IN_W + 1)
)
(
    input  [IN_W - 1:0]  in,
    output [OUT_W - 1:0] out
);

wire [OUT_W - 1:0] buff [IN_W:0]; // Набор проводов для хранения промежуточных результатов. На один больше!

assign buff[0] = 0;

genvar i;

generate
    for (i = 0; i < IN_W; i = i + 1 ) begin
        assign buff[i + 1] = in[i] ? 0 : (buff[i] + 1);
    end
endgenerate

assign out = buff[IN_W];

endmodule // Самый дешёвый по транзисторам вариант, но самый долгий? Из-за этого verilator кидает UNOPTFLAT
