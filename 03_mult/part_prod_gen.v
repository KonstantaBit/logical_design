module part_prod_gen #(
    parameter IN_WIDTH = 8
) (
    input  [IN_WIDTH  - 1:0] op1,
    input  [IN_WIDTH  - 1:0] val,
    input  [IN_WIDTH  - 1:0] sign,
    output [OUT_WIDTH - 1:0] part_product [WIDE - 1:0] 
);
    localparam OUT_WIDTH = IN_WIDTH * 2;

    genvar i;

    generate
        for (i = 0; i < IN_WIDTH; i = i + 1) begin: loop
            assign part_product[i] = val[i] ? (OUT_WIDTH{sign[i]} ^ op1 + sign) << i : {OUT_WIDTH{1'b0}};
        end
    endgenerate
endmodule