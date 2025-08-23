module real_mult #(
    parameter IS_DOUBLE = 0,
    parameter WIDTH     = IS_DOUBLE == 1 ? 64 : 32
) (
    input  [WIDTH - 1:0] op1,
    input  [WIDTH - 1:0] op2,
    input  [1:0]         opcode,
    input                clk,
    input                reset,
    output [WIDTH - 1:0] res,
    output [WIDTH - 1:0] val
);

localparam EXPONENT_W = IS_DOUBLE == 1 ? 11 : 8;
localparam MANTISSA_W = IS_DOUBLE == 1 ? 52 : 23;

always @(posedge clk) begin
    
end
endmodule
