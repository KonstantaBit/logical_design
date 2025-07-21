/* verilator lint_off WIDTHTRUNC */

module testbench;
    
    parameter DATA_W = 8;

    reg                 clk=0;
    reg                 reset=1;

    reg                 write, read;
    reg  [DATA_W-1:0]   datain;

    wire                val_sh, val_cr;
    wire                full_sh, full_cr;
    wire [DATA_W-1:0]   dataout_sh, dataout_cr;

    always
        #1 clk <= ~clk;

    initial begin
        $dumpfile("trace.vcd");
        $dumpvars();
        repeat (3) @(posedge clk);
        reset = 0;
        #1000000
        $finish();
    end

    ring_fifo
    #(
        .SIZE       (10)
    )   ring_fifo
    (
        .clk        (clk),
        .rst        (reset),
        .write      (write),
        .in         (datain),
        .read       (read),
        .out        (dataout_cr),
        .val        (val_cr),
        .full       (full_cr)
    );

    shift_fifo
    #(
        .SIZE       (10)
    )   shift_fifo
    (
        .clk        (clk),
        .rst        (reset),
        .write      (write),
        .in         (datain),
        .read       (read),
        .out        (dataout_sh),
        .val        (val_sh),
        .full       (full_sh)
    );

    always @(posedge clk)
    begin
        datain <= $random() % (1 << DATA_W);
        write  <= $random() % 2;
        read   <= $random() % 2;
    end

    always @(negedge clk)
    begin
        if(!reset) begin
            if( val_sh !== val_cr) begin
                $display("VAL ERROR");
                $stop();
            end
            else if (val_sh & (dataout_sh !== dataout_cr)) begin
                $display("DATA ERROR");
                $stop();
            end
            if( full_sh !== full_cr) begin
                $display("FULL ERROR");
                $stop();
            end
        end
    end

endmodule
