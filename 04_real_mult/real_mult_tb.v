module real_mult_tb;
    localparam HIDDEN_BIT = 1;  // Наличие скрытого бита в мантиссе
    localparam EXP_W      = 11;  // Размерность экспоненты
    localparam MANT_RAW_W = 53; // Размерность мантиссы
    localparam WIDTH      = 64; // ??? :P
    
    reg [WIDTH - 1:0] op_a, op_b, res, real_bits_res;
    reg [1:0] opcode;
    reg clk, rst = 0, val;
    
    real real_a, real_b, real_res;

    real_mult  #(.HIDDEN_BIT(1), .EXP_W(EXP_W), .MANT_RAW_W(MANT_RAW_W), .WIDTH(WIDTH)) inst (
        .op_a(op_a),
        .op_b(op_b),
        .opcode(opcode),
        .clk(clk),
        .reset(rst),
        .res(res),
        .val(val)
    );

    always begin
        #1;
        clk <= ~clk;
    end

    initial begin
        $dumpfile("trace.vcd");
        $dumpvars();
        #100;
        $finish();
    end

    always @(posedge clk)
    begin
        op_a   = {1'b0, 11'b100_0000_0000, {$random(),$random()}[51:0]};
        op_b   = {1'b0, 11'b011_1111_1111, {$random(),$random()}[51:0]};
        real_a = $bitstoreal(op_a);
        real_b = $bitstoreal(op_b);
        real_res = real_a * real_b;
        real_bits_res = $realtobits(real_res);
    end

endmodule
