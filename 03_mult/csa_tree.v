module csa_tree #(
    parameter WIDTH = 16,
    parameter N = 8
) (
    input  [WIDTH - 1:0]  terms [N - 1:0], 
    output [WIDTH - 1: 0] ps,
    output [WIDTH - 1: 0] pc
);
    localparam N_NEXT = N - (N / 3);
    genvar i;

    wire [WIDTH - 1:0]  terms [N_NEXT - 1:0];

    generate
        if (N_NEXT == 2)
            begin
                csa csa_out (
                    .a(terms[0]),
                    .b(terms[1]),
                    .c(terms[2])
                    .ps(pc)
                    .pc(pc)
                );
            end
        else
            begin
                for (i = 0; i < W)
            end 
    endgenerate
endmodule