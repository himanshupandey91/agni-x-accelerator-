`timescale 1ns/1ps

module accelerator_tb;

    logic clk;
    logic rst;
    logic en;

    logic signed [7:0] a;
    logic signed [7:0] b;

    logic signed [15:0] acc;

    accelerator dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .a(a),
        .b(b),
        .acc(acc)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        en  = 0;
        a   = 0;
        b   = 0;

        #10;

        rst = 0;
        en  = 1;

        a = 2;
        b = 3;
        #10;

        if (acc !== 16'sd6)
            $fatal(1, "TEST 1 FAILED: acc = %0d", acc);

        $display("TEST 1 PASSED: acc = %0d", acc);

        a = 4;
        b = 5;
        #10;

        if (acc !== 16'sd26)
            $fatal(1, "TEST 2 FAILED: acc = %0d", acc);

        $display("TEST 2 PASSED: acc = %0d", acc);

        a = 3;
        b = 4;
        #10;

        if (acc !== 16'sd38)
            $fatal(1, "TEST 3 FAILED: acc = %0d", acc);

        $display("TEST 3 PASSED: acc = %0d", acc);

        $display("AGNI-X ACCELERATOR TEST COMPLETE.");

        $finish;
    end

endmodule
