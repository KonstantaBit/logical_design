module shift_fifo 
#(
    parameter DATA_W = 8,
    parameter SIZE   = 4
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

    reg [DATA_W - 1:0]           mem [SIZE - 1:0];
    reg [$clog2(SIZE + 1) - 1:0] ptr;
    wire                         write_avaible;
    wire                         read_avaible;
    wire                         empty;
    genvar                       i;

    assign full          = (ptr == SIZE);
    assign empty         = (ptr == 0);
    assign write_avaible = ~full & write;
    assign read_avaible  = ~empty & read;

    generate 
        for (i = 0; i < SIZE; i = i + 1) begin: mem_loop
            always @(posedge clk) begin
                mem[i] <= write_avaible & read_avaible & (i == ptr - 1) ? in         : 
                          write_avaible & (ptr == i)                    ? in         :
                          read_avaible  & (i < ptr - 1)                 ? mem[i + 1] : mem[i];
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (rst) begin
            val <= 0;
            ptr <= 0;    
        end else if (write_avaible & read_avaible) begin
            val <= 1;
            out <= mem[0];
        end else if (write_avaible) begin
            val <= 0;
            ptr <= ptr + 1;
        end else if (read_avaible) begin
            ptr <= ptr - 1;
            out <= mem[0];
            val <= 1;
        end else begin
            val <= 0;
        end
    end

endmodule
