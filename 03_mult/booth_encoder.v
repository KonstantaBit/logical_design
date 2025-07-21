module booth_encoder #(
    parameter WIDE = 8
)(
    input  [WIDE - 1:0]     x,
    input  [WIDE - 1:0]     y,
    output [WIDE * 2 - 1:0] out [WIDE - 1:0]
);

    wire [WIDE:0] corrected = {y, 1'b0};

    genvar i;

    generate
        for (i = 0; i < WIDE; i = i + 1) begin : enc
            wire [WIDE * 2 - 1:0] x_ext = $signed({{WIDE{x[WIDE - 1]}} , x}); // Эксплицитное знаковое расширение

            assign out[i] = (corrected[i+1:i] == 2'b01) ? (x_ext << i) :
                            (corrected[i+1:i] == 2'b10) ? (-x_ext << i) :
                                                         '0;
        end
    endgenerate

endmodule