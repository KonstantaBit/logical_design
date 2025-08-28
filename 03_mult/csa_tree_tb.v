// csa_tree_tb.v
module csa_tree_tb;

    localparam WIDTH = 8;
    localparam N     = 4;

    reg  [WIDTH * N - 1:0] x;
    wire [WIDTH - 1:0]     ps;
    wire [WIDTH - 1:0]     pc;

    csa_tree #(.WIDTH(WIDTH), .N(N)) tree (
        .signals(x),
        .ps(ps),
        .pc(pc)
    );

    initial begin
        integer i;

        // Обнуляем x
        x = 0;

        // Заполняем каждый из N векторов значением 4
        for (i = 0; i < N; i = i + 1) begin
            x[i * WIDTH +: WIDTH] = 1;
        end

        #10;

        $display("ps  = %d", ps);
        $display("pc  = %d", pc);
        $display("sum = %d", ps + (pc << 1));

        $finish;
    end

endmodule
