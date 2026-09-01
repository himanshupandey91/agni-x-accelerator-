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

    integer i;
    integer expected;
    integer passed;

    initial begin

        clk = 0;
        rst = 1;
        en  = 0;
        a   = 0;
        b   = 0;

        passed = 0;

        // -----------------------------
        // INITIAL RESET
        // -----------------------------

        #10;

        if (acc !== 16'sd0)
            $fatal(1, "INITIAL RESET FAILED: acc=%0d", acc);

        passed = passed + 1;
        $display("INITIAL RESET PASSED: acc=%0d", acc);

        rst = 0;
        en  = 1;

        // -----------------------------
        // BASIC ACCUMULATION TEST
        // -----------------------------

        a = 2;
        b = 3;
        #10;

        if (acc !== 16'sd6)
            $fatal(1, "BASIC TEST FAILED: acc=%0d", acc);

        passed = passed + 1;
        $display("BASIC TEST PASSED: 2 x 3 = %0d", acc);

        // -----------------------------
        // SECOND ACCUMULATION
        // -----------------------------

        a = 4;
        b = 5;
        #10;

        if (acc !== 16'sd26)
            $fatal(1, "SECOND TEST FAILED: acc=%0d", acc);

        passed = passed + 1;
        $display("SECOND TEST PASSED: acc=%0d", acc);

        // -----------------------------
        // ENABLE HOLD TEST
        // -----------------------------

        en = 0;

        a = 100;
        b = 100;

        #10;

        if (acc !== 16'sd26)
            $fatal(1, "ENABLE HOLD FAILED: acc=%0d", acc);

        passed = passed + 1;
        $display("ENABLE HOLD TEST PASSED: acc=%0d", acc);

        // -----------------------------
        // RESET TEST
        // -----------------------------

        rst = 1;
        en  = 0;

        #10;

        if (acc !== 16'sd0)
            $fatal(1, "RESET TEST FAILED: acc=%0d", acc);

        passed = passed + 1;
        $display("RESET TEST PASSED: acc=%0d", acc);

        // -----------------------------
        // SIGNED MULTIPLICATION TEST
        // -----------------------------

        rst = 0;
        en  = 1;

        a = -3;
        b = 4;

        #10;

        if (acc !== -16'sd12)
            $fatal(1, "SIGNED TEST FAILED: acc=%0d", acc);

        passed = passed + 1;
        $display("SIGNED TEST PASSED: acc=%0d", acc);

        // -----------------------------
        // RANDOM ACCUMULATION TEST
        // -----------------------------

        rst = 1;
        en  = 0;

        #10;

        rst = 0;
        en  = 1;

        expected = -12;

        for (i = 0; i < 10000; i = i + 1) begin

            a = $signed($urandom_range(255,0));
            b = $signed($urandom_range(255,0));

            expected = expected + (a * b);

            #10;

            if (acc !== expected[15:0]) begin
                $fatal(
                    1,
                    "RANDOM TEST FAILED at case %0d: a=%0d b=%0d acc=%0d expected=%0d",
                    i,
                    a,
                    b,
                    acc,
                    expected
                );
            end

        end

        $display("");
        $display("==============================================");
        $display("10,000 RANDOM ACCUMULATION TESTS PASSED");
        $display("==============================================");
        $display("");

        // -----------------------------
        // FINAL RESULT
        // -----------------------------

        $display("==============================================");
        $display("AGNI-X ACCELERATOR VERIFICATION PASSED");
        $display("Basic tests : PASSED");
        $display("Reset test  : PASSED");
        $display("Signed test : PASSED");
        $display("Random tests: 10,000 PASSED");
        $display("==============================================");

        $finish;

    end

endmodule
