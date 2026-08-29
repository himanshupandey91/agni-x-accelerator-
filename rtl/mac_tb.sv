`timescale 1ns/1ps

module agni_x_mac_tb;

    logic clk;
    logic rst;
    logic enable;

    logic [7:0] a;
    logic [7:0] b;
    logic [15:0] acc;

    agni_x_mac dut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .a(a),
        .b(b),
        .acc(acc)
    );

    // 100 MHz simulation clock
    always #5 clk = ~clk;

    initial begin

        clk    = 0;
        rst    = 1;
        enable = 0;
        a      = 0;
        b      = 0;

        // Reset
        #20;
        rst = 0;

        // Test 1: 3 × 4 = 12
        enable = 1;
        a = 8'd3;
        b = 8'd4;

        #10;

        if (acc != 16'd12)
            $error("TEST 1 FAILED: acc = %0d", acc);
        else
            $display("TEST 1 PASSED: acc = %0d", acc);

        // Test 2: 5 × 6 = 30
        // Expected accumulator = 12 + 30 = 42
        a = 8'd5;
        b = 8'd6;

        #10;

        if (acc != 16'd42)
            $error("TEST 2 FAILED: acc = %0d", acc);
        else
            $display("TEST 2 PASSED: acc = %0d", acc);

        // Test 3: 10 × 10 = 100
        // Expected accumulator = 42 + 100 = 142
        a = 8'd10;
        b = 8'd10;

        #10;

        if (acc != 16'd142)
            $error("TEST 3 FAILED: acc = %0d", acc);
        else
            $display("TEST 3 PASSED: acc = %0d", acc);

        $display("AGNI-X MAC TEST COMPLETE.");

        $finish;
    end

endmodule
