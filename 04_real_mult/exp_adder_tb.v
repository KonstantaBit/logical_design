/* verilator lint_off PINMISSING */

module exp_adder_tb;

    reg [7:0] exp_a;
    reg [7:0] exp_b;
    reg signed [8:0] exp_mult;

    exp_adder #(.EXP_W(8), .MANT_W(24)) exp_ad (
        .exp_a(exp_a),
        .exp_b(exp_b),
        .res(exp_mult)
    );

    initial begin
        $display("erm: %b", $signed(100));
        exp_a = 7;
        exp_b = 33;
        #10;
        $display("erm: %d", exp_mult);
        $display("derm: %d", $unsigned(exp_mult)[7:0]);
        $display("erm: %d", (1 << (8 - 1)) - 1);
        $finish(); // ОК
    end

endmodule
