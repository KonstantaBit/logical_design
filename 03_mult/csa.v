module csa 
#(
    parameter WIDE = 16
)
(
    input  [WIDE - 1:0] a,
    input  [WIDE - 1:0] b,
    input  [WIDE - 1:0] c,
    output [WIDE - 1:0] ps,
    output [WIDE - 1:0] pc
);

genvar i;

generate
    for (i = 0; i < WIDE ; i = i + 1) begin
        assign ps[i] = a[i] ^ b[i] ^ c[i];
        assign pc[i] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
    end
endgenerate

endmodule
