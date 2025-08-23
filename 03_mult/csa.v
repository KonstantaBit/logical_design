module csa 
#(
    parameter WIDTH = 16
)
(
    input  [WIDTH - 1:0] a,
    input  [WIDTH - 1:0] b,
    input  [WIDTH - 1:0] c,
    output [WIDTH - 1:0] ps,
    output [WIDTH - 1:0] pc
);

genvar i;

generate
    for (i = 0; i < WIDTH; i = i + 1) begin
        assign ps[i] = a[i] ^ b[i] ^ c[i];
        assign pc[i] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
    end
endgenerate

endmodule
