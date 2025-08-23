module csa_tree #(
    parameter WIDTH = 16,
    parameter N = 8
) (
    input  [WIDTH * N - 1:0] signals, 
    output [WIDTH - 1:0]     ps,
    output [WIDTH - 1:0]     pc
);
    localparam N_NEXT = N - (N / 3);
    genvar i;

    wire [WIDTH - 1:0] terms [N - 1:0];

    generate
        for (i = 0; i < N; i = i + 1) begin: gen_terms
            assign terms[i] = signals[(i + 1) * WIDTH - 1 : i * WIDTH];
        end
    endgenerate

    generate
        if (N_NEXT == 2)
            begin
                csa #(.WIDTH(WIDTH)) csa_out (
                    .a(terms[0]),
                    .b(terms[1]),
                    .c(terms[2]),
                    .ps(ps),
                    .pc(pc)
                );
            end
        else
            begin
                wire [WIDTH - 1:0] terms_next [N_NEXT - 1:0];

                wire [WIDTH * N_NEXT - 1:0] result;

                for (i = 0; i < N / 3; i = i + 1) begin
                    csa #(.WIDTH(WIDTH)) csa_out (
                        .a( terms[3 * i + 0]),
                        .b( terms[3 * i + 1]),
                        .c( terms[3 * i + 2]),
                        .ps(terms_next[N_NEXT - (2 * i + 0) - 1]),
                        .pc(terms_next[N_NEXT - (2 * i + 1) - 2])
                    );
                end
                if (N % 3 == 1) begin
                    assign terms_next[0] = terms[N - 1];
                end
                else if (N % 3 == 2) begin
                    assign terms_next[0] = terms[N - 1];
                    assign terms_next[1] = terms[N - 2];
                end
                
                for (i = 0; i < N_NEXT; i = i + 1) begin
                    assign result[(i + 1) * WIDTH - 1:i * WIDTH] = terms_next[i];
                end

                csa_tree #(.WIDTH(WIDTH), .N(N_NEXT)) tree (
                    .signals(result),
                    .ps(ps),
                    .pc(pc)
                );
            end
    endgenerate
endmodule
