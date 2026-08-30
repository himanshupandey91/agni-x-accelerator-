`timescale 1ns/1ps

module mac_tb;

    parameter WIDTH = 8;

    logic clk;
    logic rst;
    logic en;

    logic signed [WIDTH-1:0] a;
    logic signed [WIDTH-1:0] b;

    logic signed [(2*WIDTH)-1:0] acc;

    // DUT
    mac #(
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .a(a),
        .b(b),
        .acc(acc)
    );

    // ------------------------------------------------------------
    // Clock
    // ------------------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // ------------------------------------------------------------
    // Main test
    // ------------------------------------------------------------
    initial begin

        // Initial values
        rst = 0;
        en  = 0;
        a   = 0;
        b   = 0;

        // --------------------------------------------------------
        // Existing unsigned/basic tests
        // --------------------------------------------------------

        // Reset
        rst = 1;
        en  = 0;
        #10;

        if (acc !== 0)
            $fatal(1, "RESET FAILED: acc = %0d", acc);

        $display("RESET PASSED: acc = %0d", acc);

        rst = 0;
        en  = 1;

        // 2 × 3 = 6
        a = 2;
        b = 3;
        #10;

        if (acc !== 16'sd6)
            $fatal(1, "TEST 1 FAILED: acc = %0d", acc);

        $display("TEST 1 PASSED: acc = %0d", acc);

        // 4 × 5 = 20
        // 6 + 20 = 26
        a = 4;
        b = 5;
        #10;

        if (acc !== 16'sd26)
            $fatal(1, "TEST 2 FAILED: acc = %0d", acc);

        $display("TEST 2 PASSED: acc = %0d", acc);

        // 2 × 6 = 12
        // 26 + 12 = 38
        a = 2;
        b = 6;
        #10;

        if (acc !== 16'sd38)
            $fatal(1, "TEST 3 FAILED: acc = %0d", acc);

        $display("TEST 3 PASSED: acc = %0d", acc);

        // Disable enable
        en = 0;
        a  = 10;
        b  = 10;
        #10;

        if (acc !== 16'sd38)
            $fatal(1, "ENABLE TEST FAILED: acc = %0d", acc);

        $display("ENABLE TEST PASSED: acc = %0d", acc);

        // Reset again
        rst = 1;
        en  = 0;
        #10;

        if (acc !== 0)
            $fatal(1, "RESET TEST FAILED: acc = %0d", acc);

        $display("RESET TEST PASSED: acc = %0d", acc);

        rst = 0;
        en  = 1;

        // 12 × 8 = 96
        a = 12;
        b = 8;
        #10;

        if (acc !== 16'sd96)
            $fatal(1, "TEST 4 FAILED: acc = %0d", acc);

        $display("TEST 4 PASSED: acc = %0d", acc);


        // --------------------------------------------------------
        // Manual signed arithmetic tests
        // --------------------------------------------------------

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


        // --------------------------------------------------------
        // 1000 CASE RANDOM SIGNED VERIFICATION
        // --------------------------------------------------------

        run_random_signed_tests(1000);

        $display("");
        $display("==============================================");
        $display("AGNI-X MAC 1000-CASE SIGNED RANDOM TEST PASS");
        $display("==============================================");
        $display("");

        $finish;
    end


    // ------------------------------------------------------------
    // Random signed verification task
    // ------------------------------------------------------------
    task automatic run_random_signed_tests(input integer NUM_TESTS);

        integer i;

        logic signed [WIDTH-1:0] rand_a;
        logic signed [WIDTH-1:0] rand_b;

        logic signed [(2*WIDTH)-1:0] expected_product;
        logic signed [(2*WIDTH)-1:0] expected_acc;

        begin

            // Start from known state
            rst = 1;
            en  = 0;
            a   = 0;
            b   = 0;

            #10;

            if (acc !== 0)
                $fatal(1,
                    "RANDOM TEST RESET FAILED: acc = %0d",
                    acc
                );

            rst = 0;
            en  = 1;

            expected_acc = '0;

            for (i = 0; i < NUM_TESTS; i = i + 1) begin

                // Generate WIDTH-bit random signed values
                rand_a = $signed($urandom);
                rand_b = $signed($urandom);

                // Drive DUT inputs
                a = rand_a;
                b = rand_b;

                // Calculate reference product
                expected_product =
                    $signed(rand_a) * $signed(rand_b);

                // Calculate expected accumulator
                expected_acc =
                    expected_acc + expected_product;

                // Wait for rising edge
                #10;

                // Compare DUT against reference
                if (acc !== expected_acc) begin

                    $display("");
                    $display("!!!!!!!! RANDOM TEST FAILED !!!!!!!!");
                    $display("Iteration       = %0d", i);
                    $display("A               = %0d", rand_a);
                    $display("B               = %0d", rand_b);
                    $display("Expected product= %0d", expected_product);
                    $display("Expected acc    = %0d", expected_acc);
                    $display("Actual acc      = %0d", acc);
                    $display("");

                    $fatal(1,
                        "SIGNED RANDOM TEST FAILED"
                    );
                end

                // Progress output every 100 tests
                if (((i + 1) % 100) == 0) begin
                    $display(
                        "SIGNED RANDOM TEST: %0d / %0d PASSED | acc = %0d",
                        i + 1,
                        NUM_TESTS,
                        acc
                    );
                end

            end

            $display("");
            $display(
                "ALL %0d SIGNED RANDOM TESTS PASSED.",
                NUM_TESTS
            );
            $display("");

        end

    endtask

endmodule
