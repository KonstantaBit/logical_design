/* verilator lint_off PINMISSING */

module exp_adder_tb;

    reg [7:0] exp_a;
    reg [7:0] exp_b;
    reg signed [8:0] exp_mult;
    reg signed [8:0] exp_dbg;

    exp_adder #(.EXP_W(8), .MANT_W(24)) exp_ad (
        .exp_a(exp_a),
        .exp_b(exp_b),
        .res(exp_mult)
    );

    initial begin
        integer i;
        for (i = 0; i < 100; i = i + 1) begin
            exp_a = $random()[7:0];
            exp_b = $random()[7:0];
            #10;
            // $display("a: %d; b: %d, res: %d", exp_a, exp_b, exp_mult);
            exp_dbg = {1'b0, exp_a} + {1'b0, exp_b} - 127;
            // $display("%d + %d - 127 = %d; %d", exp_a, exp_b, exp_mult, exp_dbg);
            $display("%b | %b", 20 < -27, 20 < $unsigned(-27));
            #5;
        end
        $finish(); // ОК
    end

endmodule
