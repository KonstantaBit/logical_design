/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNDRIVEN */

module testbench;

parameter DATA_W = 8;
parameter SIZE   = 4;

reg clk;
reg reset;
reg write;
reg read;
reg [DATA_W - 1:0] datain;
wire [DATA_W - 1:0] dataout;
wire val;
wire full;

shift_fifo #(.DATA_W(DATA_W), .SIZE(SIZE)) unit (
    .clk(clk),
    .reset(reset),
    .write(write),
    .read(read),
    .datain(datain),
    .dataout(dataout),
    .val(val),
    .full(full)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk; // Тактовый сигнал с периодом 10 единиц времени
end

initial begin
    $dumpfile("trace.vcd");
    $dumpvars();

    reset = 1;
    #10;
    reset = 0;
    #10;
    $display("Writing:");
    write = 1; datain = 8'h01; #10; $display("Read: %h, Valid: %b, Full: %b", dataout, val, full);
    write = 1; datain = 8'h02; #10; $display("Read: %h, Valid: %b, Full: %b", dataout, val, full);
    write = 1; datain = 8'h03; #10; $display("Read: %h, Valid: %b, Full: %b", dataout, val, full);
    write = 1; datain = 8'h04; #10; $display("Read: %h, Valid: %b, Full: %b", dataout, val, full);
    write = 0;

    $display("\nReading:");
    read = 1; #10; $display("Read: %h, Valid: %b, Full: %b", dataout, val, full);
    read = 1; #10; $display("Read: %h, Valid: %b, Full: %b", dataout, val, full);
    read = 1; #10; $display("Read: %h, Valid: %b, Full: %b", dataout, val, full);
    read = 1; #10; $display("Read: %h, Valid: %b, Full: %b", dataout, val, full);
    read = 1; #10; $display("Read: %h, Valid: %b, Full: %b", dataout, val, full);
    read = 0;

    $display("\nWriting & reading simultaneously");
    write = 1; datain = 8'h05; #10;
    datain = 8'h06; read = 1; #10; $display("Read: %h, Valid: %b, Full: %b", dataout, val, full);
    read = 0;
    write = 0;
    read = 1; #10; $display("Read: %h, Valid: %b, Full: %b", dataout, val, full);

    $finish;
end

endmodule
