/* verilator lint_off UNUSEDSIGNAL */

module testbench;
    
parameter IN_W  = 8;
parameter OUT_W = $clog2(IN_W + 1);

reg  [IN_W - 1:0]  in;
wire [OUT_W - 1:0] out;

zero_counter #(.IN_W(IN_W)) unit (
    .in(in),
    .out(out)
);

initial begin
    $dumpfile("trace.vcd");
    $dumpvars();

    in = 8'b11110000;
    #10;
    in = 8'b00000111;
    #10;
    in = 8'b00100111;
    #10;
    in = 8'b00000000;
    #10;
    in = 8'b11111111;
    #10;
    $finish(); 
end

endmodule
