`timescale 1ns/1ps

module accelerator_stress_tb;

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

    integer i;
    integer expected;

    initial begin
        clk = 0;
        rst = 1;
        en  = 0;
        a   = 0;
        b   = 0;
        expected = 0;

        // Reset
        #10;
        rst = 0;

        // 1000 automatic tests
        for (i = 0; i < 1000; i = i + 1) begin

            a = $signed($urandom_range(0,255));
            b = $signed($urandom_range(0,255));

            expected = expected + (a * b);

            en = 1;

            #10;

            // Keep expected value at 16-bit width
            if (acc !== expected[15:0]) begin
                $fatal(
                    1,
                    "TEST FAILED: i=%0d a=%0d b=%0d expected=%0d actual=%0d",
                    i, a, b, expected[15:0], acc
                );
            end

            if ((i + 1) % 100 == 0)
                $display(
                    "STRESS TEST: %0d / 1000 PASSED",
                    i + 1
                );
        end

        en = 0;

        $display("");
        $display("======================================");
        $display(" AGNI-X ACCELERATOR STRESS TEST PASS");
        $display(" Tests : 1000");
        $display(" Failed: 0");
        $display(" Status: PASS");
        $display("======================================");

        $finish;
    end

endmodule
