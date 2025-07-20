/* verilator lint_off WIDTHTRUNC */

module testbench;
    
    localparam IN_W    = 8;
    localparam OUT_W   = $clog2(IN_W + 1);

    reg  [IN_W - 1:0]  in_low;
    wire [OUT_W - 1:0] out_low;
    reg  [IN_W - 1:0]  in_high;
    wire [OUT_W - 1:0] out_high;
    reg [IN_W - 1:0]   val_low;
    reg [IN_W - 1:0]   val_high;
    reg [OUT_W - 1:0]  i;
    
    zero_counter #(.IN_W(IN_W), .REVERSE(0)) zc_high (
        .in(in_high),
        .out(out_high)
    );

    zero_counter #(.IN_W(IN_W), .REVERSE(1)) zc_low (
        .in(in_low),
        .out(out_low)
    );

    initial begin
        $dumpfile("trace.vcd");
        $dumpvars();

        val_low = $random();
        val_low[0] = 1;
        val_high = $random();
        val_high[IN_W - 1] = 1;

        for (i = 0; i <= IN_W; i = i + 1) begin
            in_high = val_high;
            in_low = val_low;
            #5
            $display("(High) Vector '%b' has%d. Correct is%d", val_high, out_high, i);
            $display("(Low) Vector '%b' has%d. Correct is%d", val_low, out_low, i);
            val_high = (val_high >> 1);
            val_low = (val_low << 1);
            if ((out_high != i) || (out_low != i)) begin
                $stop;
            end
        end
        $finish();
    end

endmodule
