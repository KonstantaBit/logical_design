/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */

module testbench;

    localparam WIDE = 8;

    reg [WIDE - 1:0]     x;
    reg [WIDE - 1:0]     y;
    reg [WIDE * 2 - 1:0] a;

    top #(.WIDE(WIDE)) tp (
        .x(x),
        .y(y),
        .a(a)
    );

    integer i;

    initial begin // Shitty code :З
        $dumpfile("trace.vcd");
        $dumpvars();

        for (i = 0; i < 1000; i = i + 1) begin
            x = $signed($random());
            y = $signed($random());
            #5
            $display("%d %d %d", $signed(x), $signed(y), $signed(a));

        end

        $finish();
    end

endmodule