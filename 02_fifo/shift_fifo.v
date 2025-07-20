/* verilator lint_off UNUSEDSIGNAL */

module shift_fifo 
#(
    parameter DATA_W = 8,
    parameter SIZE   = 50
)
(
    input                     clk,
    input                     rst,
    input                     write,
    input      [DATA_W - 1:0] in,
    input                     read,
    output reg [DATA_W - 1:0] out,
    output                    val,
    output                    full
);
    

endmodule
