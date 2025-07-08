/* verilator lint_off UNUSEDSIGNAL */

module shift_fifo 
#(
    parameter DATA_W,
    parameter SIZE
)
(
    input clk,
    input reset,
    input write,
    input [DATA_W - 1:0] datain,
    input read,
    output reg [DATA_W - 1:0] dataout,
    output val,
    output full
);

localparam [$clog2(SIZE + 1) - 1:0] EMPTY = '1;

reg [DATA_W - 1:0] mem [SIZE - 1:0];
reg [$clog2(SIZE + 1) - 1:0] ptr;
integer i;

assign full = (ptr == SIZE - 1);

always @(posedge clk) begin
    if (reset) begin
        ptr <= EMPTY;
        val <= 0;
    end else if (write && read && (ptr != EMPTY)) begin
        dataout <= mem[ptr[$clog2(SIZE) - 1:0]];
        val <= 1;
        for (i = SIZE - 1; i > 0; i = i - 1)
            mem[i] <= mem[i - 1];
        mem[0] <= datain;
    end else if (write && !full) begin
        for (i = SIZE - 1; i > 0; i = i - 1)
            mem[i] <= mem[i - 1];
        mem[0] <= datain;
        ptr <= ptr + 1;
        val <= 0;
    end else if (read && (ptr != EMPTY)) begin
        dataout <= mem[ptr[$clog2(SIZE) - 1:0]];
        ptr <= ptr - 1;
        val <= 1;
    end else begin
        val <= 0;
    end
end

endmodule
