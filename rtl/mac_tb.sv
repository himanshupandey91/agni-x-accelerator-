`timescale 1ns/1ps

module mac_tb;

    logic clk;
    logic rst;
    logic en;

    logic signed [7:0] a;
    logic signed [7:0] b;

    logic signed [15:0] acc;

    mac dut (
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

        // Reset
        #10;

        rst = 0;
        en  = 1;

        // Operation 1
        a = 2;
        b = 3;
        #10;

        if (acc !== 16'sd6)
            $fatal(1, "TEST 1 FAILED: acc = %0d", acc);

        $display("TEST 1 PASSED: acc = %0d", acc);

        // Operation 2
        a = 4;
        b = 5;
        #10;

        if (acc !== 16'sd26)
            $fatal(1, "TEST 2 FAILED: acc = %0d", acc);

        $display("TEST 2 PASSED: acc = %0d", acc);

        // Operation 3
        a = 3;
        b = 4;
        #10;

        if (acc !== 16'sd38)
            $fatal(1, "TEST 3 FAILED: acc = %0d", acc);

        $display("TEST 3 PASSED: acc = %0d", acc);

        // Reset
        rst = 1;
        en  = 0;
        #10;

        if (acc !== 16'sd0)
            $fatal(1, "RESET FAILED: acc = %0d", acc);

        $display("RESET PASSED: acc = %0d", acc);

        // New sequence
        rst = 0;
        en  = 1;

        // 8 × 8 = 64
        a = 8;
        b = 8;
        #10;

        // 4 × 8 = 32
        // 64 + 32 = 96
        a = 4;
        b = 8;
        #10;

        if (acc !== 16'sd96)
            $fatal(1, "TEST 4 FAILED: acc = %0d", acc);

        $display("TEST 4 PASSED: acc = %0d", acc);

        // ==================================================
        // DAY 11 — SIGNED ARITHMETIC TESTS
        // ==================================================

        // Reset
        rst = 1;
        en  = 0;
        #10;

        rst = 0;
        en  = 1;

        // -3 × 4 = -12
        a = -3;
        b = 4;
        #10;

        if (acc !== -16'sd12)
            $fatal(1, "SIGNED TEST 1 FAILED: acc = %0d", acc);

        $display("SIGNED TEST 1 PASSED: acc = %0d", acc);

        // -2 × -5 = +10
        // -12 + 10 = -2
        a = -2;
        b = -5;
        #10;

        if (acc !== -16'sd2)
            $fatal(1, "SIGNED TEST 2 FAILED: acc = %0d", acc);

        $display("SIGNED TEST 2 PASSED: acc = %0d", acc);

        // 7 × -3 = -21
        // -2 - 21 = -23
        a = 7;
        b = -3;
        #10;

        if (acc !== -16'sd23)
            $fatal(1, "SIGNED TEST 3 FAILED: acc = %0d", acc);

        $display("SIGNED TEST 3 PASSED: acc = %0d", acc);

        $display("AGNI-X MAC DAY 11 SIGNED TEST COMPLETE.");

        $finish;

    end

endmodule
