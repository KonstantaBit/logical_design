module ring_fifo 
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

    reg [DATA_W - 1:0]       mem [SIZE - 1:0];
    reg [$clog2(SIZE) - 1:0] ptr_head; // Указатель на место, где будет происходить следующая запись
    reg [$clog2(SIZE) - 1:0] ptr_tail; // Указатель на место, где будет происходить следующее чтение
    reg                      is_last_read; // Регистр последней операции 1 - чтение, 0 - запись
    wire                     write_avaible;
    wire                     read_avaible;
    wire                     empty;

    assign full          = (ptr_head == ptr_tail) & ~is_last_read;
    assign empty         = (ptr_head == ptr_tail) & is_last_read;
    assign write_avaible = ~full & write;
    assign read_avaible  = ~empty & read;

    always @(posedge clk) begin
        if (write_avaible) begin
            mem[ptr_head] <= in;
        end
        if (read_avaible) begin
            out <= mem[ptr_tail];
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            val <= 0;
            ptr_head <= 0;
            ptr_tail <= 0;
            is_last_read <= 1;
        end else if (write_avaible & read_avaible) begin
            val <= 1;
            ptr_head <= (ptr_head + 1 == SIZE) ? 0 : ptr_head + 1;
            ptr_tail <= (ptr_tail + 1 == SIZE) ? 0 : ptr_tail + 1;
        end else if (write_avaible) begin
            is_last_read <= 0;
            val <= 0;
            ptr_head <= (ptr_head + 1 == SIZE) ? 0 : ptr_head + 1;
        end else if (read_avaible) begin
            is_last_read <= 1;
            val <= 1;
            ptr_tail <= (ptr_tail + 1 == SIZE) ? 0 : ptr_tail + 1;
        end else begin
            val <= 0;
        end
    end

endmodule
