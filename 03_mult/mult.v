/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */

module mult
#(
    parameter WIDE = 8
)
(
    input  [WIDE - 1:0]     x,
    input  [WIDE - 1:0]     y,
    output [WIDE * 2 - 1:0] a
);

    wire [WIDE * 2 - 1:0] out_encoder [WIDE - 1:0];

    booth_encoder encoder (
        .x(x),
        .y(y),
        .out(out_encoder)
    );

    wire [WIDE * 2 - 1:0] pc1, ps1;

    csa csa1 (
        .a(out_encoder[0]),
        .b(out_encoder[1]),
        .c(out_encoder[2]),
        .pc(pc1),
        .ps(ps1)
    );

    wire [WIDE * 2 - 1:0] pc2, ps2;

    csa csa2 (
        .a(out_encoder[3]),
        .b(out_encoder[4]),
        .c(out_encoder[5]),
        .pc(pc2),
        .ps(ps2)
    );

    wire [WIDE * 2 - 1:0] pc3, ps3;

    csa csa3 (
        .a(pc1),
        .b(ps1),
        .c(pc2),
        .pc(pc3),
        .ps(ps3)
    );

    wire [WIDE * 2 - 1:0] pc4, ps4;

    csa csa4 (
        .a(ps2),
        .b(out_encoder[6]),
        .c(out_encoder[7]),
        .pc(pc4),
        .ps(ps4)
    );

    wire [WIDE * 2 - 1:0] pc5, ps5;

    csa csa5 (
        .a(pc3),
        .b(ps3),
        .c(pc4),
        .pc(pc5),
        .ps(ps5)
    );

    wire [WIDE * 2 - 1:0] pc6, ps6;

    csa csa6 (
        .a(pc5),
        .b(ps5),
        .c(ps4),
        .pc(pc6),
        .ps(ps6)
    );

    
    assign a = pc6 + ps6;
endmodule
